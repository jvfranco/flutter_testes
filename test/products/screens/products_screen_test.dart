import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:flutter_listin/products/widgets/product_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("As informações básicas devem ser mostradas.", (widgetTester) async {
    Product product = Product(
      id: "ID001",
      name: "Detergente",
      obs: "",
      category: "",
      isKilograms: false,
      isPurchased: false,
      amount: 2,
      price: 2.5,
    );

    /*
      widgetTester é uma classe fornecida pelo Flutter no pacote flutter_test.
      Ele permite testar a UI de maneira eficiente e eficaz.
      Com ele, você pode simular interações do usuário, encontrar widgets na árvore de widgets
      e verificar o estado da sua UI após várias operações.

      1. pumpWidget: Carrega o widget a ser testado no ambiente de teste = await tester.pumpWidget(MyWidget());
      2. pump: Avança o relógio do teste para permitir a conclusão das animações = await tester.pump();
      3. pumpAndSettle: Avança o relógio até que não haja mais animações pendentes = await tester.pumpAndSettle();
      4. tap: Simula um toque em um widget específico = await tester.tap(find.byType(ElevatedButton));
      5. drag: Simula um gesto de arrasto em um widget = await tester.drag(find.byType(ListView), const Offset(0, -200));
      6. enterText: Insere texto em um campo de texto = await tester.enterText(find.byType(TextField), 'Novo texto');
      7. pumpFrames: Avança o relógio do teste por uma quantidade específica de frames = await tester.pumpFrames(myWidget, Duration(seconds: 1));

      Boas Práticas
        1. Isolamento dos testes: Cada teste deve ser independente. Evite dependências entre testes para garantir que a falha de um não cause a falha de outro.
        2. Limpeza após os testes: Use o método tearDown para limpar qualquer estado ou configuração após a execução dos testes.
          tearDown(() {
            // Limpeza necessária
          });
        3. Uso de pumpAndSettle com moderação: Embora útil, o pumpAndSettle pode aumentar o tempo de execução dos testes.
           Use-o apenas quando necessário para aguardar a conclusão das animações.
        4. Verificação de estados intermediários: Em testes complexos, verifique os estados intermediários
           para garantir que cada etapa da interação está funcionando corretamente.
            await tester.tap(find.byIcon(Icons.add));
            await tester.pump();
            expect(find.text('1'), findsOneWidget);
        5. Testes de acessibilidade: Inclua testes para verificar a acessibilidade, como rotulagem correta de widgets e navegação por teclado.
            expect(find.bySemanticsLabel('Adicionar item'), findsOneWidget);
     */

    // Existe uma função callback no clique no checkbox, essa função deve ser passada para o widget, para que não ocorram erros no teste
    checkboxTap({required Product product, required String listinId}) {
      product.isPurchased = !product.isPurchased;
    }

    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              ProductListItem(
                  listinId: "LISTIN_ID",
                  product: product,
                  onTap: () {},
                  onCheckboxTap: checkboxTap,
                  onTrailButtonTap: () {})
            ],
          ),
        ),
      ),
    );

    Finder findCheckbox = find.byType(Checkbox);
    Finder findDelete = find.widgetWithIcon(IconButton, Icons.delete);
    Finder findTitle = find.text("${product.name} (x${product.amount!.toInt()})");
    Finder findSubtitle = find.byKey(const Key("subtitle"));

    expect(findCheckbox, findsOne);
    expect(findSubtitle, findsOne);
    expect(findDelete, findsOne);
    expect(findTitle, findsOne);

    Text textSubtitle = widgetTester.widget<Text>(findSubtitle);
    expect(textSubtitle.data, equals("R\$ ${product.price!}"));

    await widgetTester.tap(findCheckbox);
    await widgetTester.pumpAndSettle();

    expect(widgetTester.widget<Checkbox>(findCheckbox).value, product.isPurchased);

  });
}
