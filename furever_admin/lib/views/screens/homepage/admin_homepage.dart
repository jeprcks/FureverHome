// lib/views/admin_home_view.dart
import 'package:flutter/material.dart';
import 'package:furever_home_admin/views/screens/authentication/bloc/auth_bloc.dart';
import 'package:furever_home_admin/views/screens/authentication/bloc/auth_event.dart';
import 'package:furever_home_admin/views/screens/authentication/login/admin_signin_view.dart';
import 'package:furever_home_admin/views/screens/Events/eventlist.dart';
import 'package:furever_home_admin/views/screens/dashboard/dashboard.dart';
import 'package:furever_home_admin/views/screens/donationlist/donationlist.dart';
import 'package:furever_home_admin/views/screens/dogs/dogslist.dart';
import 'package:furever_home_admin/views/screens/clients/clients.dart';
import 'package:furever_home_admin/views/screens/AdoptedDogs/adopted.dart';
import 'package:furever_home_admin/views/screens/Merch/merch.dart';
import 'package:furever_home_admin/views/screens/Donations/donations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool openDrawer;

  const AdminHomeView({
    super.key,
    this.scaffoldKey,
    this.openDrawer = false,
  });

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.openDrawer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.scaffoldKey?.currentState?.openDrawer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        title: const Text('Furever Home Admin'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data?.exists == true) {
                    final adminData =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    final adminName = adminData?['name'] ?? 'Admin User';
                    return Text(
                      adminName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  }
                  return Text(
                    'Admin User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            _buildDrawerItem(0, Icons.home, 'Home', isHome: true),
            _buildDrawerItem(1, Icons.dashboard, 'Dashboard'),
            _buildDrawerItem(2, Icons.event, 'Events'),
            _buildDrawerItem(4, Icons.pets, 'Dogs'),
            _buildDrawerItem(6, Icons.favorite, 'Adopted'),
            _buildDrawerItem(5, Icons.people, 'Clients'),
            _buildDrawerItem(3, Icons.monetization_on, 'Donations'),
            _buildDrawerItem(8, Icons.list, 'Donation List'),
            _buildDrawerItem(7, Icons.shopping_cart, 'Merch'),
            const Divider(),
            _buildDrawerItem(-2, Icons.logout, 'Logout',
                isLogout: true, onTap: () => _handleLogout(context)),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // First dispatch logout event to the AuthBloc
    context.read<AuthBloc>().add(SignOutRequested());

    // Navigate to sign in screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => AdminSignInView(),
      ),
      (route) => false, // This will remove all previous routes
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label,
      {bool isHome = false, bool isLogout = false, VoidCallback? onTap}) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue[900] : Colors.grey[700],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue[900] : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap ??
          () {
            if (isLogout) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminSignInView(),
                ),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });

              Navigator.pop(context); // Close drawer first

              // Handle navigation based on index after drawer is closed
              Future.delayed(Duration.zero, () {
                switch (index) {
                  case 0: // Home
                    // Stay on home page
                    break;
                  case 1: // Dashboard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                    break;
                  case 2: // Events
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventScreen(),
                      ),
                    );
                    break;
                  case 3: // Donations
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TopDonatorsScreen(),
                      ),
                    );
                    break;
                  case 4: // Dogs
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DogsListScreen(),
                      ),
                    );
                    break;
                  case 5: // Clients
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClientsScreen(),
                      ),
                    );
                    break;
                  case 6: // Adopted
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdoptedDogsScreen(),
                      ),
                    );
                    break;
                  case 7: // Merch
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchScreen(),
                      ),
                    );
                    break;
                  case 8: // Donation List
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationListScreen(),
                      ),
                    );
                    break;
                }
              });
            }
          },
    );
  }
}
