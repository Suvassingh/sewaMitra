import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sewamitra/user/userHomeScreen.dart';

// ... (Keep your existing Service, ServiceProviderModel, and ServiceDataProvider classes)

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SewaMitra Provider',
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
                  'Provider Menu',
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
              title: const Text('Home', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.black),
              title: const Text('My Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushNamed(context, '/my_services'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.black),
              title: const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushNamed(context, '/notifications'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          const SizedBox(height: 10),

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
                  width: 250,
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
                      hintText: 'Search services...',
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
                return ProviderServiceCard(service: _filteredServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderServiceCard extends StatelessWidget {
  final Service service;

  const ProviderServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceRegistrationScreen(service: service),
          ),
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
//
// class ServiceRegistrationScreen extends StatefulWidget {
//   final Service service;
//
//   const ServiceRegistrationScreen({super.key, required this.service});
//
//   @override
//   State<ServiceRegistrationScreen> createState() => _ServiceRegistrationScreenState();
// }
//
// class _ServiceRegistrationScreenState extends State<ServiceRegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _experienceController = TextEditingController();
//
//   File? _idProofFile;
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickIdProof() async {
//     // Request storage permission
//     final status = await Permission.storage.request();
//     if (!status.isGranted) return;
//
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _idProofFile = File(pickedFile.path));
//     }
//   }
//
//   Future<String> _uploadIdProof() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw Exception('User not logged in');
//
//       // Create optimized filename with service ID and timestamp
//       final fileName = 'id_${widget.service.id}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_idProofFile!.path)}';
//
//       final storageRef = FirebaseStorage.instance.ref()
//           .child('provider_documents')
//           .child(user.uid)
//           .child(fileName);
//
//       final uploadTask = storageRef.putFile(_idProofFile!);
//
//       uploadTask.snapshotEvents.listen((taskSnapshot) {
//         setState(() {
//           _uploadProgress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
//         });
//       });
//
//       final taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       throw Exception('ID proof upload failed: $e');
//     }
//   }
//
//   Future<void> _submitRegistration() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_idProofFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload your ID proof')));
//       return;
//     }
//
//     setState(() => _isUploading = true);
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw Exception('User not logged in');
//
//       // Upload ID proof
//       final idProofUrl = await _uploadIdProof();
//
//       // Save to Firestore under the current user
//       await FirebaseFirestore.instance
//           .collection('service_providers')
//           .doc(user.uid)
//           .collection('registered_services')
//           .doc(widget.service.id)
//           .set({
//         'service_id': widget.service.id,
//         'service_name': widget.service.name,
//         'experience': int.parse(_experienceController.text),
//         'id_proof_url': idProofUrl,
//         'registration_date': Timestamp.now(),
//         'status': 'pending',
//       });
//
//       // Update user document to mark as service provider
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .update({
//         'is_service_provider': true,
//         'services': FieldValue.arrayUnion([widget.service.id]),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration submitted successfully!')));
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration failed: $e')));
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register for ${widget.service.name}'),
//       ),
//       body: _isUploading
//           ? _buildProgressIndicator()
//           : _buildRegistrationForm(),
//     );
//   }
//
//   Widget _buildProgressIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(value: _uploadProgress),
//           const SizedBox(height: 20),
//           Text(
//             'Uploading ID proof: ${(_uploadProgress * 100).toStringAsFixed(1)}%',
//             style: const TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRegistrationForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Service Provider Registration',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 20),
//
//             // Experience Field
//             TextFormField(
//               controller: _experienceController,
//               decoration: const InputDecoration(
//                 labelText: 'Experience (years)',
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter your years of experience',
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your experience';
//                 }
//                 if (int.tryParse(value) == null) {
//                   return 'Please enter a valid number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//
//             // ID Proof Section
//             _buildIdProofSection(),
//             const SizedBox(height: 32),
//
//             // Submit Button
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildIdProofSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'ID Proof Verification:',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Upload a clear photo of your government-issued ID',
//           style: TextStyle(color: Colors.grey),
//         ),
//         const SizedBox(height: 16),
//
//         if (_idProofFile != null)
//           _buildImagePreview(),
//
//         const SizedBox(height: 16),
//         ElevatedButton.icon(
//           onPressed: _pickIdProof,
//           icon: const Icon(Icons.upload),
//           label: const Text('Upload ID Proof'),
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 50),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImagePreview() {
//     return Column(
//       children: [
//         Container(
//           height: 200,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Image.file(
//             _idProofFile!,
//             fit: BoxFit.cover,
//             width: double.infinity,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Selected: ${path.basename(_idProofFile!.path)}',
//           style: const TextStyle(fontStyle: FontStyle.italic),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: _submitRegistration,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Theme.of(context).primaryColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: const Text(
//           'Submit Registration',
//           style: TextStyle(fontSize: 18, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//


class ServiceRegistrationScreen extends StatefulWidget {
  final Service service;

  const ServiceRegistrationScreen({super.key, required this.service});

  @override
  State<ServiceRegistrationScreen> createState() => _ServiceRegistrationScreenState();
}

class _ServiceRegistrationScreenState extends State<ServiceRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _experienceController = TextEditingController();
  bool _isSubmitting = false;

  // Get reference to Realtime Database
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // 1. Update provider document with service experience
      final providerServicesRef = _dbRef.child('providers/${user.uid}/services');

      // Push creates a new unique ID for each service registration
      final newServiceRef = providerServicesRef.push();

      await newServiceRef.set({
        'service_id': widget.service.id,
        'service_name': widget.service.name,
        'experience': int.parse(_experienceController.text),
        'registration_date': DateTime.now().millisecondsSinceEpoch,
        'status': 'pending',
      });



      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration submitted successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register for ${widget.service.name}'),
      ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : _buildRegistrationForm(),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Provider Registration',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const Text(
              'Please provide your experience for this service:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Experience Field
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Experience (years)',
                border: OutlineInputBorder(),
                hintText: 'Enter your years of experience',
                prefixIcon: Icon(Icons.work_history),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your experience';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (int.parse(value) < 0) {
                  return 'Experience cannot be negative';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Service Info Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Details:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Service: ${widget.service.name}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Registration',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
