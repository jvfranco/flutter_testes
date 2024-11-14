import "dart:math";

import "package:flutter_listin/products/helpers/calculate_total_price.dart";
import "package:flutter_listin/products/model/product.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  // Comando para rodar os testes de somente um grupo via terminal
  // flutter test "path do arquivo de testes" --name "Nome do Grupo"
  // flutter test test/products/helpers/calculate_total_price_test.dart  --name "Entradas simples: "
  group("Entradas simples: ", () {
    test("Se uma lista de produtos vazia, retorna total zero.", () {
      List<Product> listProducts = [];

      double result = calculateTotalPriceFromListProduct(listProducts);

      expect(result, 0);
    });

    test(
        "Se a lista tiver apenas um produto, retornar a multiplicação dos valores.",
            () {
          List<Product> listProducts = [];
          Product product = Product(
            id: "id",
            name: "Desinfetante",
            obs: "obs",
            category: "",
            isKilograms: false,
            isPurchased: true,
            price: 5,
            amount: 2,
          );

          listProducts.add(product);

          expect(
            calculateTotalPriceFromListProduct(listProducts),
            product.amount! * product.price!,
            reason:
            "Espera-se que a função leve em consideração não apenas no valor mas a quantidade do item.",
          );
        });

    test(
      "A função não pode retornar valores negativos.",
          () {
        List<Product> listProducts = [];
        Product product = Product(
          id: "id",
          name: "Desinfetante",
          obs: "obs",
          category: "",
          isKilograms: false,
          isPurchased: true,
          price: Random().nextDouble() * 10,
          amount: Random().nextInt(10).toDouble(),
        );

        listProducts.add(product);

        double result = calculateTotalPriceFromListProduct(listProducts);

        expect(result, isNonNegative);
      }, retry: 1000000,
    );
  },);

  group("Casos Excepcionais: ", () {
    test(
      "A função deve lançar uma exceção caso um dos produtos não esteja no carrinho.",
          () {
        List<Product> listProducts = [];
        Product product = Product(
          id: "id",
          name: "Desinfetante",
          obs: "obs",
          category: "",
          isKilograms: false,
          isPurchased: true,
          price: Random().nextDouble() * 10,
          amount: Random().nextInt(10).toDouble(),
        );
        Product product2 = Product(
          id: "id",
          name: "Desinfetante",
          obs: "obs",
          category: "",
          isKilograms: false,
          isPurchased: false,
          price: Random().nextDouble() * 10,
          amount: Random().nextInt(10).toDouble(),
        );

        listProducts.addAll([product, product2]);

        expect(() => calculateTotalPriceFromListProduct(listProducts), throwsA(isA<ProductNotPurchasedException>()));
      },
    );
  },);
}
