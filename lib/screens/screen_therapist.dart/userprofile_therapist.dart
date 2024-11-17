import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_therapist.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart';

class UserprofileTherapist extends StatefulWidget {
  const UserprofileTherapist({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserprofileTherapist> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  File? _image;
  String? _imageUrl;
  String? name;

  // Función para obtener los datos del usuario desde Firestore
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      final data = userDoc.data();

      if (data != null) {
        setState(() {
          name = data['name']; // Guardamos el nombre para mostrar
          nameController.text = data['name'] ?? '';
          birthdateController.text = data['birthdate'] ?? '';
          phoneController.text = data['phone']?.substring(5) ?? '';
          addressController.text = data['address'] ?? '';
          selectedGender = data['gender'];
          _imageUrl = data['profileImage'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Cargar datos al iniciar la pantalla
  }

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
      appBar: const CustomAppbarBack(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Perfil de Usuario',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Mostrar el nombre del usuario
              Center(
                child: Text(
                  name != null ? 'Hola, $name' : 'Hola, Usuario',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
                    'Guardar Datos',
                    style: TextStyle(fontSize: 16, color: AppColors.secondary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarTherapist(),
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
            // Separar el nombre y el apellido automáticamente si es necesario
            List<String> names = value.split(' ');
            for (int i = 0; i < names.length; i++) {
              if (names[i].isNotEmpty) {
                names[i] = names[i][0].toUpperCase() +
                    names[i].substring(1).toLowerCase();
              }
            }
            String formattedValue =
                names.join(' '); // Juntar el nombre con espacio

            // Actualizar el texto del controlador con el formato adecuado
            controller.text = formattedValue;

            // Mover el cursor al final del texto
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        },
      ),
    );
  }

  // Widget para la fecha de nacimiento
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

  // Widget para el menú desplegable de género
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

  // Campo de teléfono con código fijo 569
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
            'profileImage': imageUrl, // Guardamos la URL de la imagen
          }, SetOptions(merge: true)); // Merge para no sobrescribir otros datos

          _showConfirmationDialog(context);
        }
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
  }

  // Diálogo de confirmación de datos guardados
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          content: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.only(top: 20),
            child: const Center(
              child: Text(
                'Datos guardados correctamente.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de error si falta un campo por completar
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          content: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.only(top: 20),
            child: const Center(
              child: Text(
                'Por favor complete todos los campos.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
