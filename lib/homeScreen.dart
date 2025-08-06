



import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userRole;
  bool isLoading = true;
  List<Map<String, dynamic>> services = [];
  final List<String> carouselImages = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    'https://images.unsplash.com/photo-1540518614846-7eded433c457?ixlib=rb-4.0.3&auto=format&fit=crop&w=1457&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=1474&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadServices();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final database = FirebaseDatabase.instance.ref();
      final userSnapshot = await database.child('users').child(user.uid).get();
      final providerSnapshot = await database.child('providers').child(user.uid).get();

      setState(() {
        if (userSnapshot.exists) {
          userRole = 'user';
        } else if (providerSnapshot.exists) {
          userRole = 'provider';
        }
        isLoading = false;
      });
    }
  }

  Future<void> _loadServices() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('services').get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        services = data.entries.map((e) {
          return {
            'id': e.key,
            'name': e.value['name'],
            'icon': e.value['icon'],
          };
        }).toList();
      });
    } else {
      setState(() {
        services = [
          {'id': '1', 'name': 'AC Repair', 'icon': Icons.ac_unit},
          {'id': '2', 'name': 'Painting', 'icon': Icons.brush},
          {'id': '3', 'name': 'Waterproofing', 'icon': Icons.water_drop},
          {'id': '4', 'name': 'Wall Panels', 'icon': Icons.wallpaper},
          {'id': '5', 'name': 'Plumber', 'icon': Icons.plumbing},
          {'id': '6', 'name': 'Washing Machine Repair', 'icon': Icons.local_laundry_service},
          {'id': '7', 'name': 'Kitchen Cleaning', 'icon': Icons.clean_hands},
          {'id': '8', 'name': 'Microwave Repair', 'icon': Icons.microwave},
          {'id': '9', 'name': 'Carpenter', 'icon': Icons.carpenter},
          {'id': '10', 'name': 'Sofa Cleaning', 'icon': Icons.chair},
        ];
      });
    }
  }

  void _navigateTo(String route) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SimpleScreen(title: route)),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () => _navigateTo('Cart'),
          ),
          ListTile(
            leading: const Icon(Icons.brush),
            title: const Text('Beauty'),
            onTap: () => _navigateTo('Beauty'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => _navigateTo('Profile'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return userRole == 'user'
        ? UserHomeScreen(
      services: services,
      carouselImages: carouselImages,
      drawer: _buildDrawer(),
    )
        : ProviderHomeScreen(
      services: services,
      carouselImages: carouselImages,
      drawer: _buildDrawer(),
    );
  }
}

class UserHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final List<String> carouselImages;
  final Widget drawer;

  const UserHomeScreen({
    super.key,
    required this.services,
    required this.carouselImages,
    required this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeServe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SimpleScreen(title: 'Cart')),
            ),
          ),
        ],
      ),
      drawer: drawer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarouselSlider(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Services', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(
                  context: context,
                  service: services[index],
                  isDarkMode: isDarkMode,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: carouselImages.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required Map<String, dynamic> service,
    required bool isDarkMode,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              service['icon'] as IconData? ?? Icons.home_repair_service,
              size: 40,
              color: isDarkMode ? Colors.blue[200] : Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              service['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final List<String> carouselImages;
  final Widget drawer;

  const ProviderHomeScreen({
    super.key,
    required this.services,
    required this.carouselImages,
    required this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Provider Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SimpleScreen(title: 'Profile')),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(Icons.book_online, 'Bookings', '12'),
            const SizedBox(height: 10),
            _buildSummaryCard(Icons.attach_money, 'Earnings', 'Rs. 18,000'),
            const SizedBox(height: 10),
            _buildSummaryCard(Icons.notifications, 'Notifications', '3'),
            const SizedBox(height: 20),
            const Text(
              'Your Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        service['icon'] as IconData? ?? Icons.miscellaneous_services,
                        size: 40,
                        color: isDarkMode ? Colors.blue[200] : Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        service['name'],
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}


class SimpleScreen extends StatelessWidget {
  final String title;
  const SimpleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title screen.')),
    );
  }
}



