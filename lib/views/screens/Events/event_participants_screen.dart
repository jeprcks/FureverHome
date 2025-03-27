import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventParticipantsScreen extends StatelessWidget {
  final String eventId;
  final String eventTitle;

  const EventParticipantsScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  // Dummy data for participants
  final List<Map<String, dynamic>> dummyParticipants = const [
    {
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '+1 234 567 8901',
      'status': 'Confirmed',
      'registrationDate': '2024-03-28',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@email.com',
      'phone': '+1 234 567 8902',
      'status': 'Pending',
      'registrationDate': '2024-03-27',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Bob Wilson',
      'email': 'bob.wilson@email.com',
      'phone': '+1 234 567 8903',
      'status': 'Confirmed',
      'registrationDate': '2024-03-26',
      'avatar': 'https://i.pravatar.cc/150?img=3',
    },
    {
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'phone': '+1 234 567 8904',
      'status': 'Confirmed',
      'registrationDate': '2024-03-25',
      'avatar': 'https://i.pravatar.cc/150?img=4',
    },
    {
      'name': 'Mike Brown',
      'email': 'mike.brown@email.com',
      'phone': '+1 234 567 8905',
      'status': 'Pending',
      'registrationDate': '2024-03-24',
      'avatar': 'https://i.pravatar.cc/150?img=5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Participants'),
            Text(
              eventTitle,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Add export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting participant list...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Total Participants: ${dummyParticipants.length}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusChip('Confirmed', Colors.green),
                const SizedBox(width: 8),
                _buildStatusChip('Pending', Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyParticipants.length,
              itemBuilder: (context, index) {
                final participant = dummyParticipants[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(participant['avatar']),
                      backgroundColor: Colors.grey[200],
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.person),
                    ),
                    title: Text(
                      participant['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(participant['email']),
                    trailing: _buildStatusChip(
                      participant['status'],
                      participant['status'] == 'Confirmed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.phone,
                              'Phone',
                              participant['phone'],
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Registration Date',
                              participant['registrationDate'],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.mail_outline),
                                  label: const Text('Contact'),
                                  onPressed: () {
                                    // Add contact functionality
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: const Text('Remove'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    // Add remove functionality
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        onPressed: () {
          // Add new participant functionality
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
