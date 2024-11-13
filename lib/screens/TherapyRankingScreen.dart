import 'package:flutter/material.dart';
import 'package:paraflorseer/utils/firestore_service.dart';

class TherapyRankingScreen extends StatefulWidget {
  @override
  _TherapyRankingScreenState createState() => _TherapyRankingScreenState();
}

class _TherapyRankingScreenState extends State<TherapyRankingScreen> {
  Future<Map<String, Map<String, int>>>? _rankingFuture;

  @override
  void initState() {
    super.initState();
    // Instanciar el servicio y obtener los datos
    _rankingFuture = FirestoreService().getTherapyAndTherapistRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ranking de Terapias y Terapeutas')),
      body: FutureBuilder<Map<String, Map<String, int>>>(
        future: _rankingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el ranking'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          }

          final ranking = snapshot.data!;
          return ListView(
            children: ranking.keys.map((therapy) {
              final therapistCounts = ranking[therapy]!;
              return ExpansionTile(
                title: Text(therapy),
                children: therapistCounts.keys.map((therapist) {
                  int count = therapistCounts[therapist]!;
                  return ListTile(
                    title: Text(therapist),
                    trailing: Text('$count reservas'),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
