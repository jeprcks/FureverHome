import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/views/screens/Dogs/add_dog_screen.dart';
import 'package:furever_home_admin/views/screens/Dogs/bloc/dog_bloc.dart';
import 'package:furever_home_admin/views/screens/Dogs/bloc/dog_event.dart';
import 'package:furever_home_admin/views/screens/Dogs/bloc/dog_state.dart';
import 'package:furever_home_admin/views/screens/Dogs/models/dog_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DogsListScreen extends StatelessWidget {
  const DogsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DogBloc()..add(LoadDogs()),
      child: BlocListener<DogBloc, DogState>(
        listener: (context, state) {
          if (state is DogSuccess) {
            context.read<DogBloc>().add(LoadDogs());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dogs List'),
            actions: [
              // Add refresh button
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<DogBloc>().add(LoadDogs());
                },
              ),
            ],
          ),
          body: BlocBuilder<DogBloc, DogState>(
            builder: (context, state) {
              if (state is DogLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DogError) {
                return Center(
                    child: Text(state.message)); // Now matches the state class
              }
              if (state is DogsLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.dogs.length,
                  itemBuilder: (context, index) {
                    final dog = state.dogs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              if (dog.imageUrl != null &&
                                  dog.imageUrl!.isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: dog.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                )
                              else
                                Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.pets),
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
                                  child: const Text(
                                    'Available',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dog.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dog.breed,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      dog.gender.toLowerCase() == 'male'
                                          ? Icons.male
                                          : Icons.female,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dog.gender,
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
                                      dog.size,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showDogDetails(context, dog),
                                  child: const Text('View Details'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('No dogs available'));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<DogBloc>(),
                    child: const AddDogScreen(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showDogDetails(BuildContext context, Dog dog) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DogDetailsBottomSheet(dog: dog),
    );
  }
}

class DogDetailsBottomSheet extends StatelessWidget {
  final Dog dog;

  const DogDetailsBottomSheet({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dog.imageUrl != null && dog.imageUrl!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: dog.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image URL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        dog.imageUrl!,
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          Text(
            dog.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Breed: ${dog.breed}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Gender: ${dog.gender}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Size: ${dog.size}',
            style: const TextStyle(fontSize: 16),
          ),
          if (dog.description != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(dog.description!),
          ],
          const SizedBox(height: 16),
          const Text(
            'Medical Records:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...dog.medicalRecords.entries.map(
            (entry) => Text(
              '${entry.key}: ${entry.value ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
