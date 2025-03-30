import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadDogImage(File imageFile, String dogId) async {
    try {
      final ref = _storage.ref().child('dogs').child('$dogId.jpg');
      await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteDogImage(String dogId) async {
    try {
      await _storage.ref().child('dogs').child('$dogId.jpg').delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
