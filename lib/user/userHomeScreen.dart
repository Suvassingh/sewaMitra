// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
//
// // Service Model
// class Service {
//   final String id;
//   final String name;
//   final String imageUrl;
//
//   Service({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//   });
// }
//
// // Service Provider Model
// class ServiceProviderModel {
//   final String id;
//   final String name;
//   final String serviceId;
//   final String imageUrl;
//   final double rating;
//   final int completedJobs;
//   final double distance;
//   final double hourlyRate;
//
//   ServiceProviderModel({
//     required this.id,
//     required this.name,
//     required this.serviceId,
//     required this.imageUrl,
//     this.rating = 4.5,
//     this.completedJobs = 50,
//     this.distance = 5.0,
//     this.hourlyRate = 25.0,
//   });
// }
//
// // Service Provider (ChangeNotifier)
// class ServicesProvider with ChangeNotifier {
//   final List<Service> _services = [
//     Service(
//       id: '1',
//       name: 'Cleaning',
//       imageUrl: 'https://images.unsplash.com/photo-1581578021426-3c1b74b96b6a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
//     ),
//     // ... other services
//   ];
//
//   final List<ServiceProviderModel> _serviceProviders = [
//     ServiceProviderModel(
//       id: 'p1',
//       name: 'CleanPro Services',
//       serviceId: '1',
//       imageUrl: 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
//       rating: 4.8,
//       completedJobs: 120,
//       distance: 3.2,
//       hourlyRate: 30.0,
//     ),
//     ServiceProviderModel(
//       id: 'p2',
//       name: 'Sparkle Clean Team',
//       serviceId: '1',
//       imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
//       rating: 4.6,
//       completedJobs: 85,
//       distance: 2.5,
//       hourlyRate: 28.0,
//     ),
//     ServiceProviderModel(
//       id: 'p3',
//       name: 'HomeFresh Cleaners',
//       serviceId: '1',
//       imageUrl: 'https://images.unsplash.com/photo-1597047084897-51e81819a499?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
//       rating: 4.9,
//       completedJobs: 200,
//       distance: 4.1,
//       hourlyRate: 35.0,
//     ),
//     // Add more providers for other services
//   ];
//
//   List<Service> get services => _services;
//
//   // Search method
//   List<Service> searchServices(String query) {
//     if (query.isEmpty) return _services;
//
//     return _services.where((service) {
//       return service.name.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//   }
//
//   // Get providers for a specific service
//   List<ServiceProviderModel> getProvidersForService(String serviceId) {
//     return _serviceProviders.where((provider) => provider.serviceId == serviceId).toList();
//   }
// }
//
// class ServiceProvidersScreen extends StatelessWidget {
//   static const routeName = '/service_providers';
//
//   const ServiceProvidersScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final serviceId = ModalRoute.of(context)!.settings.arguments as String;
//     final serviceProviders = Provider.of<ServicesProvider>(context).getProvidersForService(serviceId);
//     final service = Provider.of<ServicesProvider>(context).services.firstWhere((s) => s.id == serviceId);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${service.name} Providers'),
//         centerTitle: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15),
//           ),
//         ),
//         backgroundColor: Colors.white38,
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//       ),
//       body: serviceProviders.isEmpty
//           ? const Center(child: Text('No providers available for this service'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: serviceProviders.length,
//         itemBuilder: (context, index) {
//           final provider = serviceProviders[index];
//           return ServiceProviderCard(provider: provider);
//         },
//       ),
//     );
//   }
// }
//
// class ServiceProviderCard extends StatelessWidget {
//   final ServiceProviderModel provider;
//
//   const ServiceProviderCard({super.key, required this.provider});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           // Navigate to provider detail screen
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Provider Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   provider.imageUrl,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       Container(
//                         width: 80,
//                         height: 80,
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.person, size: 40),
//                       ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//
//               // Provider Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       provider.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//
//                     // Rating and Reviews
//                     Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 16),
//                         const SizedBox(width: 4),
//                         Text(
//                           provider.rating.toString(),
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '(${provider.completedJobs} jobs)',
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//
//                     // Distance and Rate
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 16, color: Colors.blue),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${provider.distance} km away',
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                         const Spacer(),
//                         const Icon(Icons.attach_money, size: 16, color: Colors.green),
//                         const SizedBox(width: 4),
//                         Text(
//                           '\$${provider.hourlyRate}/hr',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // Book Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Book this provider
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: const Text(
//                           'Book Now',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});
//
//   @override
//   State<UserHomeScreen> createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   final List<String> carouselImages = const [
//     'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
//     'https://images.unsplash.com/photo-1540518614846-7eded433c457?ixlib=rb-4.0.3&auto=format&fit=crop&w=1457&q=80',
//     'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=1474&q=80',
//   ];
//
//   final TextEditingController _searchController = TextEditingController();
//   List<Service> _filteredServices = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with all services
//     _filteredServices = Provider.of<ServiceProvider>(context, listen: false).services;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final serviceProvider = Provider.of<ServiceProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SewaMitra',
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black
//           ),
//           textAlign: TextAlign.center,
//         ),
//         centerTitle: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15),
//           ),
//         ),
//         backgroundColor: Colors.white38,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart, color: Colors.black),
//             onPressed: () => Navigator.pushNamed(context, '/cart'),
//           ),
//         ],
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//       ),
//       drawer: Drawer(
//         width: 250,
//         backgroundColor: Colors.indigo[400],
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             Container(
//               height: 160,
//               decoration: const BoxDecoration(
//                 color: Colors.white38,
//               ),
//               child: const Center(
//                 child: Text(
//                   'Menu',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home, color: Colors.black),
//               title: const Text('Home',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.person,color: Colors.black),
//               title: const Text('Profile',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.wallet,color: Colors.black),
//               title: const Text('Wallet',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/wallet');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.notifications,color: Colors.black),
//               title: const Text('Notifications',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/notifications');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//
//
//           // Carousel Slider
//           CarouselSlider(
//             options: CarouselOptions(
//               height: 180,
//               autoPlay: true,
//               viewportFraction: 0.8,
//               enlargeCenterPage: true,
//             ),
//             items: carouselImages.map((url) {
//               return Container(
//                 margin: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.cover,
//                     width: 1000,
//                     errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.error, size: 50),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Services Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Services',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Container(
//                   width: 2500, // Adjust width as needed
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(fontSize: 14),
//                       prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                       isDense: true,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _filteredServices = serviceProvider.searchServices(value);
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Services Grid
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: 0.9,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 15,
//               ),
//               itemCount: _filteredServices.length,
//               itemBuilder: (context, index) {
//                 return ServiceCard(service: _filteredServices[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ServiceCard extends StatelessWidget {
//   final Service service;
//
//   const ServiceCard({super.key, required this.service});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => Navigator.pushNamed(
//           context,
//           ServiceProvidersScreen.routeName,
//           arguments: service.id,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.network(
//                 service.imageUrl,
//                 height: 60,
//                 width: 60,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                 const Icon(Icons.error_outline, size: 40),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 service.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Service Model
class Service {
  final String id;
  final String name;
  final String imageUrl;

  Service({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

// Service Provider Model
class ServiceProviderModel {
  final String id;
  final String name;
  final String serviceId;
  final String imageUrl;
  final double rating;
  final int completedJobs;
  final double distance;
  final double hourlyRate;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.serviceId,
    required this.imageUrl,
    this.rating = 4.5,
    this.completedJobs = 50,
    this.distance = 5.0,
    this.hourlyRate = 25.0,
  });
}

// Service Data Provider (ChangeNotifier)
class ServiceDataProvider with ChangeNotifier {
  final List<Service> _services = [
    Service(
      id: '1',
      name: 'Cleaning',
      imageUrl: 'https://images.unsplash.com/photo-1581578021426-3c1b74b96b6a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    ),
    Service(
      id: '2',
      name: 'Plumbing',
      imageUrl: 'https://images.unsplash.com/photo-1633441380346-615a1a87f7c3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    ),
    Service(
      id: '3',
      name: 'Electrical',
      imageUrl: 'https://images.unsplash.com/photo-1590959651373-a3db0f38a961?ixlib=rb-4.0.3&auto=format&fit=crop&w=1478&q=80',
    ),
    Service(
      id: '4',
      name: 'Painting',
      imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    ),
    Service(
      id: '5',
      name: 'Carpenter',
      imageUrl: 'https://images.unsplash.com/photo-1601342630314-8427c38bf5e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1381&q=80',
    ),
    Service(
      id: '6',
      name: 'Gardening',
      imageUrl: 'https://images.unsplash.com/photo-1591892150210-0be5b3c7d7b1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    ),
  ];

  final List<ServiceProviderModel> _serviceProviders = [
    ServiceProviderModel(
      id: 'p1',
      name: 'CleanPro Services',
      serviceId: '1',
      imageUrl: 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      rating: 4.8,
      completedJobs: 120,
      distance: 3.2,
      hourlyRate: 30.0,
    ),
    ServiceProviderModel(
      id: 'p2',
      name: 'Sparkle Clean Team',
      serviceId: '1',
      imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      rating: 4.6,
      completedJobs: 85,
      distance: 2.5,
      hourlyRate: 28.0,
    ),
    ServiceProviderModel(
      id: 'p3',
      name: 'HomeFresh Cleaners',
      serviceId: '1',
      imageUrl: 'https://images.unsplash.com/photo-1597047084897-51e81819a499?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      rating: 4.9,
      completedJobs: 200,
      distance: 4.1,
      hourlyRate: 35.0,
    ),
    ServiceProviderModel(
      id: 'p4',
      name: 'FixIt Plumbing',
      serviceId: '2',
      imageUrl: 'https://images.unsplash.com/photo-1604336755604-96fa6a978a6c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      rating: 4.7,
      completedJobs: 150,
      distance: 1.8,
      hourlyRate: 45.0,
    ),
    ServiceProviderModel(
      id: 'p5',
      name: 'Master Electricians',
      serviceId: '3',
      imageUrl: 'https://images.unsplash.com/photo-1607799279861-4dd421887fb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      rating: 4.9,
      completedJobs: 300,
      distance: 0.5,
      hourlyRate: 60.0,
    ),
  ];

  List<Service> get services => _services;

  // Search method
  List<Service> searchServices(String query) {
    if (query.isEmpty) return _services;

    return _services.where((service) {
      return service.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get providers for a specific service
  List<ServiceProviderModel> getProvidersForService(String serviceId) {
    return _serviceProviders.where((provider) => provider.serviceId == serviceId).toList();
  }
}

class ServiceProvidersScreen extends StatelessWidget {
  static const routeName = '/service_providers';

  const ServiceProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceId = ModalRoute.of(context)!.settings.arguments as String;
    final serviceProviders = Provider.of<ServiceDataProvider>(context).getProvidersForService(serviceId);
    final service = Provider.of<ServiceDataProvider>(context).services.firstWhere((s) => s.id == serviceId);

    return Scaffold(
      appBar: AppBar(
        title: Text('${service.name} Providers'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white38,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: serviceProviders.isEmpty
          ? const Center(
          child: Text(
            'No providers available for this service',
            style: TextStyle(fontSize: 18),
          ))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: serviceProviders.length,
        itemBuilder: (context, index) {
          final provider = serviceProviders[index];
          return ServiceProviderCard(provider: provider);
        },
      ),
    );
  }
}

class ServiceProviderCard extends StatelessWidget {
  final ServiceProviderModel provider;

  const ServiceProviderCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to provider detail screen
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  provider.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                ),
              ),
              const SizedBox(width: 16),

              // Provider Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating and Reviews
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          provider.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${provider.completedJobs} jobs)',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Distance and Rate
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.distance} km away',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        const Icon(Icons.attach_money, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          '\$${provider.hourlyRate}/hr',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Book this provider
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final List<String> carouselImages = const [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    'https://images.unsplash.com/photo-1540518614846-7eded433c457?ixlib=rb-4.0.3&auto=format&fit=crop&w=1457&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&auto=format&fit=crop&w=1474&q=80',
  ];

  late TextEditingController _searchController;
  late List<Service> _filteredServices;
  late ServiceDataProvider _serviceProvider;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredServices = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serviceProvider = Provider.of<ServiceDataProvider>(context, listen: false);
    if (_filteredServices.isEmpty) {
      _filteredServices = _serviceProvider.services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SewaMitra',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white38,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: Colors.indigo[400],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white38,
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text('Home',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black),
              title: const Text('Profile',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet,color: Colors.black),
              title: const Text('Wallet',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/wallet');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications,color: Colors.black),
              title: const Text('Notifications',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Carousel Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
            items: carouselImages.map((url) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: 1000,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 50),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Services Header with Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredServices = _serviceProvider.searchServices(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Services Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(service: _filteredServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(
          context,
          ServiceProvidersScreen.routeName,
          arguments: service.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                service.imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error_outline, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                service.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}