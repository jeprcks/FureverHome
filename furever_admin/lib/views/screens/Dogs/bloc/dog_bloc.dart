import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_event.dart';
import 'dog_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'dart:convert';

class DogBloc extends Bloc<DogEvent, DogState> {
  DogBloc() : super(DogInitial()) {
    on<AddDog>((event, emit) async {
      try {
        emit(DogLoading());

        String imageUrl = '';
        if (event.imageUrl.isNotEmpty) {
          final storageRef = FirebaseStorage.instance.ref();
          final String fileName =
              '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final imageRef = storageRef.child('dogs/$fileName');

          try {
            // Convert base64 to bytes
            final Uint8List imageBytes = base64Decode(event.imageUrl);

            // Upload to Firebase Storage
            await imageRef.putData(
                imageBytes, SettableMetadata(contentType: 'image/jpeg'));

            // Get download URL
            imageUrl = await imageRef.getDownloadURL();
          } catch (storageError) {
            print('Storage error: $storageError');
            emit(DogError('Failed to upload image: $storageError'));
            return;
          }
        }

        // Add to Firestore
        await FirebaseFirestore.instance.collection('dogs').add({
          'name': event.name,
          'breed': event.breed,
          'gender': event.gender,
          'size': event.size,
          'medicalRecords': event.medicalRecords,
          'imageUrl': imageUrl,
          'description': event.description,
          'createdAt': FieldValue.serverTimestamp(),
        });

        emit(DogSuccess());
      } catch (e) {
        emit(DogError(e.toString()));
      }
    });
  }
}
