import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _imageFile;
  final _picker = ImagePicker();
  Uint8List? webImage;

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
      if (kIsWeb && webImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the image
        await storageRef.putData(
          webImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        // Get the download URL
        return await storageRef.getDownloadURL();
      } else if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the file
        await storageRef.putFile(
          _imageFile!,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        // Get the download URL
        return await storageRef.getDownloadURL();
      }
      throw Exception('No image selected');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      if (webImage != null) {
        return Image.memory(webImage!, fit: BoxFit.cover);
      }
    } else {
      if (_imageFile != null) {
        return Image.file(_imageFile!, fit: BoxFit.cover);
      }
    }
    return const Icon(Icons.add_a_photo, size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventSuccess) {
            context.read<EventBloc>().add(LoadEvents());
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event added successfully')),
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
                // Add this image picker widget
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _buildImageWidget(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
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
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Event Date'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a location' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _maxAttendeesController,
                  decoration: const InputDecoration(
                    labelText: 'Max Attendees',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter max attendees';
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          String imageUrl = '';
                          if ((kIsWeb && webImage != null) ||
                              _imageFile != null) {
                            imageUrl = await _uploadImage();
                          }

                          context.read<EventBloc>().add(
                                AddEvent(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  date: _selectedDate,
                                  location: _locationController.text,
                                  imageUrl: imageUrl,
                                  maxAttendees:
                                      int.parse(_maxAttendeesController.text),
                                ),
                              );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error uploading image: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add Event'),
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
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }
}
