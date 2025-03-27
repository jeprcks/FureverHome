import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/views/screens/Dogs/bloc/dog_event.dart';
import 'package:furever_home_admin/views/screens/Dogs/bloc/dog_state.dart';
import 'package:furever_home_admin/views/screens/Dogs/models/dog_model.dart';

class DogBloc extends Bloc<DogEvent, DogState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DogBloc() : super(DogInitial()) {
    on<LoadDogs>((event, emit) async {
      emit(DogLoading());
      try {
        final snapshot = await _firestore
            .collection('dogs')
            .orderBy('createdAt', descending: true)
            .get();
        final dogs = snapshot.docs
            .map((doc) => Dog.fromMap(doc.data(), doc.id))
            .toList();
        emit(DogsLoaded(dogs));
      } catch (e) {
        emit(DogError(e.toString()));
      }
    });

    on<AddDog>((event, emit) async {
      emit(DogLoading());
      try {
        await _firestore.collection('dogs').add({
          'name': event.name,
          'breed': event.breed,
          'gender': event.gender,
          'size': event.size,
          'medicalRecords': event.medicalRecords,
          'imageUrl': event.imageUrl,
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
