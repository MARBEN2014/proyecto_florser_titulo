import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';

class EditUserProfileScreen extends StatefulWidget {
  final String userId;
  const EditUserProfileScreen({super.key, required this.userId});

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  String? selectedRole;
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar los datos del usuario desde Firestore
  Future<void> _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(
            widget.userId) // Usar el userId recibido desde la pantalla anterior
        .get();
    if (userDoc.exists) {
      final data = userDoc.data();
      nameController.text = data?['name'] ?? '';
      birthdateController.text = data?['birthdate'] ?? '';
      phoneController.text = data?['phone'] ?? '';
      addressController.text = data?['address'] ?? '';
      selectedGender = data?['gender'];
      selectedRole = data?['role'];
      _imageUrl = data?['profileImage'];
    }
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

  // Función para guardar los datos del usuario editados en Firestore
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
          //String uid = user.uid;

          // Guardar los datos en Firestore
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.userId)
              .set({
            'name': nameController.text,
            'birthdate': birthdateController.text,
            'phone': '+569 ${phoneController.text}',
            'address': addressController.text,
            'gender': selectedGender,
            'role': selectedRole,
            'profileImage':
                imageUrl ?? _imageUrl, // Guardamos la URL de la imagen
          }, SetOptions(merge: true)); // Merge para no sobrescribir otros datos

          _showConfirmationDialog(context);
        }
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
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

  // Función para mostrar diálogo de confirmación
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          content: const Text(
            'Perfil actualizado correctamente.',
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
                // Cierra el diálogo
                Navigator.pop(context);

                // Opcional: navega a la pantalla de perfil después
                //Navigator.pushNamed(context, "/perfil");
              },
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar diálogo de error
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
                  'Editar Perfil de Usuario',
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
                        : _imageUrl != null
                            ? NetworkImage(_imageUrl!)
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

              // Botón de Guardar
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                  ),
                  onPressed: () {
                    _saveUserData(context);
                  },
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 18,
                    ),
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
}
