import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key, required String userId});

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  String? selectedRole;
  File? _image;
  String? _imageUrl;

  // Función para elegir la imagen del perfil
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Subir imagen a Firebase Storage
  Future<String?> _uploadImage() async {
    if (_image == null) return null;

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures');

      final imageRef =
          storageRef.child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await imageRef.putFile(_image!);
      final imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        showNotificationButton: true,
        title: '',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Registro de Usuario',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Foto de perfil
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/usuario.png')
                            as ImageProvider,
                    backgroundColor: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campos de información de usuario como TextFields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildEditableTextField(
                        context, 'Nombre y Apellido', nameController,
                        isName: true),
                    _buildDateField(context),
                    _buildGenderDropdown(),
                    _buildRoleDropdown(),
                    _buildPhoneField(),
                    _buildEditableTextField(
                        context, 'Dirección', addressController),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botón de guardar datos
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveUserData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Registrar Usuario',
                    style: TextStyle(fontSize: 16, color: AppColors.secondary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarAdmin(),
    );
  }

  // Widget para mostrar un campo editable como TextField
  Widget _buildEditableTextField(
      BuildContext context, String label, TextEditingController controller,
      {bool isName = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        textCapitalization:
            isName ? TextCapitalization.words : TextCapitalization.none,
        onChanged: (value) {
          if (isName) {
            List<String> names = value.split(' ');
            for (int i = 0; i < names.length; i++) {
              if (names[i].isNotEmpty) {
                names[i] = names[i][0].toUpperCase() +
                    names[i].substring(1).toLowerCase();
              }
            }
            String formattedValue =
                names.join(' '); // Juntar el nombre con espacio

            controller.text = formattedValue;

            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        },
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: birthdateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            birthdateController.text =
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          }
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: ['Masculino', 'Femenino']
            .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Sexo',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        items: [
          {'label': 'Usuario', 'value': 'user'},
          {'label': 'Administrador', 'value': 'admin'},
          {'label': 'Terapeuta', 'value': 'therapist'}
        ]
            .map((role) => DropdownMenuItem<String>(
                  child: Text(role['label']!), // Muestra el nombre en español
                  value: role['value'], // Guarda el valor en inglés
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Rol',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixText: '+569 ',
          labelText: 'Teléfono Celular',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        maxLength: 8,
      ),
    );
  }

  // Función para guardar datos del usuario en Firestore
  Future<void> _saveUserData(BuildContext context) async {
    if (nameController.text.isEmpty ||
        birthdateController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedGender == null) {
      _showErrorDialog(context);
    } else {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? imageUrl = await _uploadImage();
          String uid = user.uid;

          // Guardar los datos en Firestore
          await FirebaseFirestore.instance.collection('user').doc(uid).set({
            'name': nameController.text,
            'birthdate': birthdateController.text,
            'phone': '+569 ${phoneController.text}',
            'address': addressController.text,
            'gender': selectedGender,
            'role': selectedRole,
            'profileImage': imageUrl, // Guardamos la URL de la imagen
          }, SetOptions(merge: true)); // Merge para no sobrescribir otros datos

          _showConfirmationDialog(context);
        }
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          content: const Text(
            'Usuario registrado correctamente.',
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  color: AppColors.secondary,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/estadisticas");
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          content: const Text(
            'Debes completar todos los campos.',
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
