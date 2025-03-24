import 'package:flutter/material.dart';

class MerchScreen extends StatelessWidget {
  const MerchScreen({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Price: Low to High'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Price: High to Low'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF32649B), // Background color for whole screen
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Container
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Search TextField
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white, // Light background for search bar
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search items...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                contentPadding: const EdgeInsets.only(left: 16),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.search, color: Color(0xFF32649B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Filter Icon
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white), // White filter icon
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
            ),
            // Rest of your content goes here
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Page1()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF32649B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.food_bank_outlined),
                      label: const Text('Treats'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Page2()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF32649B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.sports_baseball_sharp),
                      label: const Text('Toys'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Page3()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF32649B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.health_and_safety),
                      label: const Text('Health'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Page4()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF32649B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.handyman_outlined),
                      label: const Text('Accessories'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}