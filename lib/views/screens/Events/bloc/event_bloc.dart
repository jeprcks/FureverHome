import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/views/screens/Events/bloc/event_event.dart';
import 'package:furever_home_admin/views/screens/Events/bloc/event_state.dart';
import 'package:furever_home_admin/views/screens/Events/models/event_model.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventBloc() : super(EventInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final snapshot = await _firestore
            .collection('events')
            .orderBy('date', descending: false)
            .get();
        final events = snapshot.docs
            .map((doc) => Event.fromMap(doc.data(), doc.id))
            .toList();
        emit(EventsLoaded(events));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<AddEvent>((event, emit) async {
      emit(EventLoading());
      try {
        await _firestore.collection('events').add({
          'title': event.title,
          'description': event.description,
          'date': event.date,
          'location': event.location,
          'imageUrl': event.imageUrl,
          'maxAttendees': event.maxAttendees,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        emit(EventSuccess());
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
  }
}
