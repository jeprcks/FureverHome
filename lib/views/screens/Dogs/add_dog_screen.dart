import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/views/screens/Dogs/models/dog_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'bloc/dog_bloc.dart';
import 'bloc/dog_event.dart';
import 'bloc/dog_state.dart';

class AddDogScreen extends StatefulWidget {
  const AddDogScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => DogBloc(), // Provide DogBloc here
        child: const AddDogScreen(),
      ),
    );
  }

  @override
  State<AddDogScreen> createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedSize = 'Medium';
  final _descriptionController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();
  Uint8List? webImage; // Add this for web support

  final _medicalRecordController = TextEditingController();

  final Map<String, bool> _medicalRecords = {
    'Vaccinated': false,
    'Dewormed': false,
    'Spayed/Neutered': false,
  };

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          // Handle web platform
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            webImage = bytes;
          });
        } else {
          // Handle mobile platform
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String> _uploadImage() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      if (kIsWeb && webImage != null) {
        // Create a storage reference
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('dog_images')
            .child('$timestamp.jpg');

        // Add metadata with CORS settings
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'timestamp': timestamp},
          cacheControl: 'public, max-age=3600',
        );

        // Upload the image with metadata
        await storageRef.putData(
          webImage!,
          metadata,
        );

        // Get the download URL
        final downloadUrl = await storageRef.getDownloadURL();
        return downloadUrl;
      } else if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('dog_images')
            .child('$timestamp.jpg');

        // Upload the file with metadata
        await storageRef.putFile(
          _imageFile!,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'timestamp': timestamp},
            cacheControl: 'public, max-age=3600',
          ),
        );

        return await storageRef.getDownloadURL();
      }
      throw Exception('No image selected');
    } catch (e) {
      print('Upload error: $e'); // Add logging
      throw Exception('Failed to upload image: $e');
    }
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      if (webImage != null) {
        return Image.memory(
          webImage!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Image error: $error'); // Add logging
            return const Icon(Icons.error_outline, size: 50);
          },
        );
      }
    } else {
      if (_imageFile != null) {
        return Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Image error: $error'); // Add logging
            return const Icon(Icons.error_outline, size: 50);
          },
        );
      }
    }
    return const Icon(Icons.add_a_photo, size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Dog'),
      ),
      body: BlocListener<DogBloc, DogState>(
        listener: (context, state) {
          if (state is DogSuccess) {
            context.read<DogBloc>().add(LoadDogs());
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dog added successfully')),
            );
          } else if (state is DogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(state.message)), // Corrected to use state.message
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildImageWidget(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Breed',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a breed' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Small', 'Medium', 'Large']
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Medical Records',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medicalRecordController,
                  decoration: const InputDecoration(
                    labelText: 'Medical Records',
                    border: OutlineInputBorder(),
                    hintText: 'Enter medical history and status',
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _medicalRecords['Vaccinated'] =
                          value.toLowerCase().contains('vaccinated');
                      _medicalRecords['Dewormed'] =
                          value.toLowerCase().contains('dewormed');
                      _medicalRecords['Spayed/Neutered'] =
                          value.toLowerCase().contains('spayed') ||
                              value.toLowerCase().contains('neutered');
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a description'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String imageData = '';
                        if (kIsWeb && webImage != null) {
                          imageData = await _uploadImage();
                        } else if (_imageFile != null) {
                          imageData = await _uploadImage();
                        }

                        final dog = Dog(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          breed: _breedController.text,
                          gender: _selectedGender,
                          size: _selectedSize,
                          description: _descriptionController.text,
                          imageUrl: imageData,
                          medicalRecords: _medicalRecords,
                        );

                        context.read<DogBloc>().add(AddDog(dog: dog));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add Dog'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _descriptionController.dispose();
    _medicalRecordController.dispose();
    super.dispose();
  }
}
