import 'package:flutter_bloc/flutter_bloc.dart';
import 'dog_event.dart';
import 'dog_state.dart';

class DogBloc extends Bloc<DogEvent, DogState> {
  DogBloc() : super(DogInitial()) {
    on<AddDog>((event, emit) async {
      emit(DogLoading());
      try {
        // TODO: Implement API call to add dog
        // For now, just simulating success
        await Future.delayed(const Duration(seconds: 1));
        emit(DogSuccess());
      } catch (e) {
        emit(DogError(e.toString()));
      }
    });
  }
}
