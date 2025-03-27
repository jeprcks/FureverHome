import 'package:furever_home_admin/views/screens/Events/models/event_model.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventSuccess extends EventState {}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}
