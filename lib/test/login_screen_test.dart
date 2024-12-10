import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock de Firestore
class MockFirestore extends Mock implements FirebaseFirestore {}

// Mock de CollectionReference
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// Mock de DocumentReference
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  setUp(() {
    // Inicializar los bindings de Flutter para las pruebas
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Guardar datos en Firestore', () async {
    // GIVEN: Configuramos los mocks
    final mockFirestore = MockFirestore();
    final mockCollection = MockCollectionReference();
    final mockDocument = MockDocumentReference();

    // Configurar los mocks para devolver objetos válidos
    when(mockFirestore.collection('user')).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocument);
    var any2 = any;
    when(mockDocument.set(any2, any)).thenAnswer((_) async => null);

    // Datos a guardar
    String name = "Juan Perez";
    String birthdate = "1990-01-01";
    String phone = "987654321";
    String address = "Calle Ficticia 123";
    String gender = "Masculino";
    String imageUrl = "http://example.com/image.jpg";

    // WHEN: Llamamos a la función que guarda los datos
    await mockFirestore.collection('user').doc("testUID").set({
      'name': name,
      'birthdate': birthdate,
      'phone': '+569 $phone',
      'address': address,
      'gender': gender,
      'profileImage': imageUrl,
      'tokens': [],
    }, SetOptions(merge: true));

    // THEN: Verificamos que el método 'set' fue llamado correctamente
    verify(mockCollection.doc("testUID")).called(1);
    verify(mockDocument.set({
      'name': name,
      'birthdate': birthdate,
      'phone': '+569 $phone',
      'address': address,
      'gender': gender,
      'profileImage': imageUrl,
      'tokens': [],
    }, SetOptions(merge: true)))
        .called(1);
  });
}
