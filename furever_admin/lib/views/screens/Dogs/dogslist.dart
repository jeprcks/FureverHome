import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:furever_home_admin/views/screens/Dogs/add_dog_screen.dart';
import 'package:http/http.dart' as http;
=======
import 'package:furever_home_admin/views/screens/Dogs/add_dog_screen.dart';
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481

class DogsListScreen extends StatelessWidget {
  const DogsListScreen({super.key});

<<<<<<< HEAD
  Future<String> _getDownloadUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching download URL: $e');
      return '';
    }
  }

  Future<bool> _checkImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      print('URL check error: $e');
      return false;
    }
  }

  Widget _buildDogImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    print('Loading image from URL: $imageUrl'); // Debug print

    return Container(
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          cacheWidth: 800, // Add caching for better performance
          headers: kIsWeb
              ? const {
                  'Access-Control-Allow-Origin': '*',
                  'Cache-Control': 'max-age=3600',
                }
              : null,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return _buildErrorWidget(error.toString());
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.pets, size: 50),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Unable to load image\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

=======
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs List'),
      ),
<<<<<<< HEAD
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dogs')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Firestore error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No dogs available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final dog =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final imageUrl = dog['imageUrl'] as String?;

              print(
                  'Processing dog: ${dog['name']}, Image URL: $imageUrl'); // Debug print

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDogImage(imageUrl),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dog['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dog['breed'] ?? 'Unknown breed',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                dog['gender'] == 'Male'
                                    ? Icons.male
                                    : Icons.female,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dog['gender'] ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.straighten,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dog['size'] ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _showDogDetails(context, dog),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900],
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('View Details'),
                                ),
                              ),
                            ],
                          ),
                        ],
=======
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      'https://placedog.net/500/300?id=${index + 1}',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${index + 1} year old',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
              );
            },
=======
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDogName(index),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDogBreed(index),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.male,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Male',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.straighten,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Medium',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showDogDetails(context, index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
<<<<<<< HEAD
          Navigator.of(context).push(AddDogScreen.route());
        },
        child: const Icon(Icons.add),
=======
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDogScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
      ),
    );
  }

<<<<<<< HEAD
  void _showDogDetails(BuildContext context, Map<String, dynamic> dog) {
=======
  void _showDogDetails(BuildContext context, int index) {
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                child: dog['imageUrl'] != null &&
                        dog['imageUrl'].toString().isNotEmpty
                    ? FutureBuilder<String>(
                        future: _getDownloadUrl(dog['imageUrl'].toString()),
                        builder: (context, urlSnapshot) {
                          if (urlSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }

                          if (urlSnapshot.hasError ||
                              !urlSnapshot.hasData ||
                              urlSnapshot.data!.isEmpty) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.error),
                            );
                          }

                          return CachedNetworkImage(
                            imageUrl: urlSnapshot.data!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) {
                              print('Error loading image: $error');
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline,
                                        size: 40, color: Colors.red),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Error loading image: ${error.toString()}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(Icons.pets, size: 50),
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                dog['name'] ?? 'Unknown',
=======
                child: Image.network(
                  'https://placedog.net/500/300?id=${index + 1}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _getDogName(index),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
<<<<<<< HEAD
                dog['breed'] ?? 'Unknown breed',
=======
                _getDogBreed(index),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
<<<<<<< HEAD
                  _buildDetailChip(Icons.pets, dog['gender'] ?? 'Unknown'),
                  _buildDetailChip(Icons.straighten, dog['size'] ?? 'Unknown'),
=======
                  _buildDetailChip(Icons.cake, '2y'),
                  _buildDetailChip(Icons.male, 'Male'),
                  _buildDetailChip(Icons.straighten, 'Medium'),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Medical Records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
<<<<<<< HEAD
                dog['medicalRecords'] ?? 'No medical records available',
=======
                '• Vaccinated: Complete\n• Dewormed: Yes\n• Spayed/Neutered: Yes',
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
<<<<<<< HEAD
                dog['description'] ?? 'No description available',
=======
                _getDogDescription(index),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
=======

  String _getDogName(int index) {
    final names = ['Max', 'Luna', 'Charlie', 'Bella', 'Rocky'];
    return names[index];
  }

  String _getDogBreed(int index) {
    final breeds = [
      'Golden Retriever',
      'German Shepherd',
      'Labrador',
      'Aspin',
      'Husky'
    ];
    return breeds[index];
  }

  String _getDogDescription(int index) {
    final descriptions = [
      'Max is a friendly and energetic Golden Retriever who loves to play fetch and go for long walks. He\'s great with children and other dogs.',
      'Luna is a curious and intelligent German Shepherd puppy. She\'s already showing great potential for training and loves to learn new tricks.',
      'Charlie is a gentle Labrador who enjoys swimming and cuddles. He\'s perfect for an active family.',
      'Bella is a sweet Aspin who was rescued from the streets. She\'s very loyal and protective of her loved ones.',
      'Rocky is a playful Husky who needs lots of exercise and attention. He\'s best suited for an experienced dog owner.'
    ];
    return descriptions[index];
  }
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
}
