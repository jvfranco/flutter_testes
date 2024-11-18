import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_listin/listins/models/listin.dart';
import 'package:flutter_listin/listins/services/listin_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listin_service_test.mocks.dart';

// Informa ao Mockito quais as classes devem ser 'mockadas'
@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<QuerySnapshot>(),
  MockSpec<CollectionReference>(),
  MockSpec<QueryDocumentSnapshot>(),
])
void main() {

  group("getListins: ", () {
    late MockFirebaseFirestore mockFirebaseFirestore;
    late String uid;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;

    // tearDown() é o método que executa após a execução de cada teste, usada para limpar ou desfazer qualquer mudança no ambiente de testes
    
    // Método que inicializa antes de cada execução de teste
    setUp(() {
      mockFirebaseFirestore = MockFirebaseFirestore();
      MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot = MockQuerySnapshot();
      mockCollectionReference = MockCollectionReference();
      MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot001 = MockQueryDocumentSnapshot();
      MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot002 = MockQueryDocumentSnapshot();

      uid = "MEU_UID";

      Listin listin001 = Listin(
          id: "ID001",
          name: "Feira de Outubro",
          obs: "obs",
          dateCreate: DateTime.now().subtract(const Duration(days: 32)),
          dateUpdate: DateTime.now().subtract(const Duration(days: 32))
      );

      Listin listin002 = Listin(
          id: "ID002",
          name: "Feira de Novembro",
          obs: "obs",
          dateCreate: DateTime.now(),
          dateUpdate: DateTime.now()
      );

      // Se o retorno for sincrono utilizar thenReturn // Se o retorno for assincrono utilizar thenAnswer
      when(mockQueryDocumentSnapshot001.data()).thenReturn(listin001.toMap());
      when(mockQueryDocumentSnapshot002.data()).thenReturn(listin002.toMap());
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot001, mockQueryDocumentSnapshot002]);
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);

      when(mockFirebaseFirestore.collection(uid)).thenReturn(mockCollectionReference);
    });

    test("O método deve retornar uma lista de listin.", () async {
      ListinService listinService = ListinService(
        firestore: mockFirebaseFirestore,
        uid: uid,
      );

      List<Listin> result = await listinService.getListins();

      expect(result.length, 2);
    });

    test("O método get deve ser chamado apenas uma vez.", () async {
      ListinService listinService = ListinService(
        firestore: mockFirebaseFirestore,
        uid: uid,
      );

      await listinService.getListins();

      verify(mockCollectionReference.get()).called(equals(1));
    });
  });

}