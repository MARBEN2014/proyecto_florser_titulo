import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/adminEditUserScreen.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';

class AdminFindUserScreen extends StatefulWidget {
  const AdminFindUserScreen({super.key});

  @override
  _AdminFindUserScreenState createState() => _AdminFindUserScreenState();
}

class _AdminFindUserScreenState extends State<AdminFindUserScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWelcome(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto "Editar usuario"
            const Text(
              "Editar usuario",
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
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Al presionar el botón, redirige a la pantalla de edición de perfil de usuario
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserProfileScreen(
                                userId: user.id,
                                // Pasa el userId encontrado
                              ),
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
