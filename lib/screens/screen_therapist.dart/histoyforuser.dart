import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_therapist.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart';

class HistoryForUserScreen extends StatefulWidget {
  const HistoryForUserScreen({super.key});

  @override
  _HistoryForUserScreenState createState() => _HistoryForUserScreenState();
}

class _HistoryForUserScreenState extends State<HistoryForUserScreen> {
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

  // Función para obtener el historial de citas de un usuario
  Future<List<Map<String, dynamic>>> _getUserHistory(String userId) async {
    final historySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('history')
        .get();

    if (historySnapshot.docs.isEmpty) {
      return [];
    }

    return historySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarBack(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Historial de Citas del Usuario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _searchUsers();
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
                        icon: const Icon(Icons.event),
                        onPressed: () async {
                          var history = await _getUserHistory(user.id);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Historial de Citas de ${user['name']}'),
                                content: history.isEmpty
                                    ? const Text('No tiene historial de citas.')
                                    : SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: history.map((cita) {
                                            int index = history.indexOf(cita);
                                            Color backgroundColor =
                                                index % 2 == 0
                                                    ? AppColors.primary
                                                    : AppColors.secondary;
                                            return Card(
                                              color: backgroundColor,
                                              margin: const EdgeInsets.only(
                                                  bottom: 16),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Cita N° ${index + 1}',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.text,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Terapia: ${cita['service_name']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.text,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Fecha: ${cita['day']} - Hora: ${cita['time']}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.text,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Terapeuta: ${cita['therapist']}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.text,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              );
                            },
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
      bottomNavigationBar: const BottomNavBarTherapist(),
    );
  }
}
