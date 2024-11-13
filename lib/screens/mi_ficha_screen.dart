import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';

import '../descripcions_servicios/descriptions _test.dart';

class MiFichaScreen extends StatefulWidget {
  const MiFichaScreen({Key? key}) : super(key: key);

  @override
  _MiFichaScreenState createState() => _MiFichaScreenState();
}

class _MiFichaScreenState extends State<MiFichaScreen> {
  final TerapiasService _terapiasService = TerapiasService();
  Map<String, dynamic>? _terapiasData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      Map<String, dynamic> data =
          await _terapiasService.fetchTerapiasDescripcion();
      setState(() {
        _terapiasData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _terapiasData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: _terapiasData!.values.map((value) {
                          // Muestra únicamente el valor de cada campo
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const Center(
                      child: Text('No se encontraron datos.'),
                    ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
