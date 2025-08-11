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
    } else {
      setState(() {
        isLoading = false;
        userRole = null;
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
            'icon': Icons.home_repair_service, // you can customize icons mapping here
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

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/role_selection');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDarkMode
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
        : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)];

    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (userRole == 'user') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomeServe', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {}, // add navigation to cart screen
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {}, // add notifications handler
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      SizedBox(height: 15),
                      Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 20)),
                      Text('HomeServe User', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white70),
                  title: const Text('Home', style: TextStyle(color: Colors.white70)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.white70),
                  title: const Text('Cart', style: TextStyle(color: Colors.white70)),
                  onTap: () {}, // navigate to Cart
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Colors.white70),
                  title: const Text('History', style: TextStyle(color: Colors.white70)),
                  onTap: () {}, // navigate to History
                ),
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.white70),
                  title: const Text('Favorites', style: TextStyle(color: Colors.white70)),
                  onTap: () {}, // navigate to Favorites
                ),
                const Divider(color: Colors.white54),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white70),
                  title: const Text('Settings', style: TextStyle(color: Colors.white70)),
                  onTap: () {}, // navigate to Settings
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Colors.white70),
                  title: const Text('Help Center', style: TextStyle(color: Colors.white70)),
                  onTap: () {}, // navigate to Help Center
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white70),
                  title: const Text('Logout', style: TextStyle(color: Colors.white70)),
                  onTap: _signOut,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Find Home Services',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Book trusted professionals for all your home needs',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.85,
                  ),
                  items: carouselImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
                            ],
                            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Popular Services',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[300]!),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // TODO: Handle service tap
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.blue[800]!.withOpacity(0.3)
                                    : Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                service['icon'] as IconData? ?? Icons.home_repair_service,
                                size: 30,
                                color: isDarkMode ? Colors.white : Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              service['name'] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Special Offers',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    children: [
                      _offerCard('AC Service @ ₹499', 'Limited time offer'),
                      _offerCard('Full Home Cleaning', 'Get 20% OFF'),
                      _offerCard('Plumbing Package', '3 fixes for ₹999'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (userRole == 'provider') {
      // Provider HomeScreen (simplified with sign out)
      return Scaffold(
        appBar: AppBar(
          title: const Text('Provider Home', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
          backgroundColor: const Color(0xFF5D69BE),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome, Provider!',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF5D69BE),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _signOut,
                  child: const Text(
                    'Sign out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // No role found or not logged in
      return Scaffold(
        body: Center(
          child: Text(
            'Unable to determine user role.\nPlease log in again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 18),
          ),
        ),
      );
    }
  }

  Widget _offerCard(String title, String subtitle) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueAccent,
            Colors.purpleAccent,
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: const Text('Book Now',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
