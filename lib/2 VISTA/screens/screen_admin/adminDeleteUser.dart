import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_logo.dart';

class AdminDeleteUserScreen extends StatefulWidget {
  const AdminDeleteUserScreen({super.key});

  @override
  _AdminDeleteUserScreenState createState() => _AdminDeleteUserScreenState();
}

class _AdminDeleteUserScreenState extends State<AdminDeleteUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<DocumentSnapshot> _searchResults = [];

  // Función para buscar usuarios en Firestore
  Future<void> _searchUsers() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isGreaterThanOrEqualTo: _searchQuery)
        .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
        .get();

    setState(() {
      _searchResults = querySnapshot.docs;
    });
  }

  // Función para eliminar un usuario de Firestore y Authentication
  Future<void> _deleteUser(String userId, String email) async {
    try {
      // Eliminar usuario de Firestore
      await FirebaseFirestore.instance.collection('user').doc(userId).delete();

      // Buscar usuario en Authentication por correo electrónico
      final userRecord =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (userRecord.isNotEmpty) {
        // Si el usuario existe en Authentication, se elimina
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password:
              'password-temporal', // Asegúrate de manejar la contraseña correctamente
        );
        await user.user?.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado correctamente')),
      );

      _searchUsers(); // Actualiza los resultados después de eliminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarLoggedOut(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto "Eliminar usuario"
            const Text(
              "Eliminar usuario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Campo de búsqueda
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _searchUsers(); // Realiza la búsqueda en Firestore
              },
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 30),

            // Mostrar resultados de la búsqueda
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text('Email: ${user['email']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          // Confirma antes de eliminar el usuario
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar eliminación'),
                              content: Text(
                                  '¿Estás seguro de que deseas eliminar a ${user['name']}? Esta acción no se puede deshacer.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteUser(user.id, user['email']);
                                  },
                                  child: const Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarAdmin(),
    );
  }
}
