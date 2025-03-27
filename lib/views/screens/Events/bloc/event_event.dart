abstract class EventEvent {}

class LoadEvents extends EventEvent {}

class AddEvent extends EventEvent {
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? imageUrl;
  final int maxAttendees;

  AddEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.maxAttendees,
  });
}
