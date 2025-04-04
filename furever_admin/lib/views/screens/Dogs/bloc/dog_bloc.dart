import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_event.dart';
import 'dog_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html; // Add for web
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DogBloc extends Bloc<DogEvent, DogState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DogBloc() : super(DogInitial()) {
    on<AddDog>((event, emit) async {
      try {
        emit(DogLoading());

        String? base64Image;
        if (event.imageFile != null) {
          if (kIsWeb) {
            // Web specific image handling
            final reader = html.FileReader();
            reader.readAsArrayBuffer(event.imageFile as html.File);
            await reader.onLoad.first;
            final bytes = reader.result as List<int>;
            base64Image = base64Encode(bytes);
          } else {
            // For mobile
            final bytes = await event.imageFile!.readAsBytes();
            base64Image = base64Encode(bytes);
          }
        }

        await _firestore.collection('dogs').add({
          'name': event.name,
          'breed': event.breed,
          'description': event.description,
          'imageData': base64Image, // Store image as Base64
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'available',
        });

        emit(DogSuccess());
      } catch (e) {
        print('Error: $e'); // Debug log
        emit(DogError(e.toString()));
      }
    });
  }
}
