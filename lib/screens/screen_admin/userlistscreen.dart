import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart';

class UserListScreen extends StatelessWidget {
  final String title;
  final List<String> userIds;

  const UserListScreen({super.key, required this.title, required this.userIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBack(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where(FieldPath.documentId,
                whereIn: userIds) // Filtra los usuarios por sus IDs
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los usuarios'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              String name = user['name'];
              return ListTile(
                title: Text(name),
              );
            },
          );
        },
      ),
    );
  }
}
