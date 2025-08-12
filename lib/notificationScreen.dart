// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class NotificationsScreen extends StatefulWidget {
//   @override
//   _NotificationsScreenState createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   final user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.checklist),
//             onPressed: _markAllAsRead,
//           ),
//         ],
//       ),
//       body: _buildNotificationsList(),
//     );
//   }
//
//   Widget _buildNotificationsList() {
//     if (user == null) {
//       return const Center(child: Text('Please sign in to view notifications'));
//     }
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('notifications')
//           .doc(user!.uid)
//           .collection('user_notifications')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No notifications'));
//         }
//
//         return ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             final doc = snapshot.data!.docs[index];
//             final data = doc.data() as Map<String, dynamic>;
//
//             return NotificationTile(
//               id: doc.id,
//               title: data['title'],
//               body: data['body'],
//               type: data['type'],
//               payload: data['payload'],
//               timestamp: data['timestamp']?.toDate(),
//               isRead: data['read'] ?? false,
//               userId: user!.uid,
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _markAllAsRead() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final snapshot = await FirebaseFirestore.instance
//         .collection('notifications')
//         .doc(user.uid)
//         .collection('user_notifications')
//         .where('read', isEqualTo: false)
//         .get();
//
//     final batch = FirebaseFirestore.instance.batch();
//
//     for (final doc in snapshot.docs) {
//       batch.update(doc.reference, {'read': true});
//     }
//
//     await batch.commit();
//   }
// }
//
// class NotificationTile extends StatelessWidget {
//   final String id;
//   final String title;
//   final String body;
//   final String type;
//   final Map<String, dynamic> payload;
//   final DateTime? timestamp;
//   final bool isRead;
//   final String userId;
//
//   const NotificationTile({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.type,
//     required this.payload,
//     required this.timestamp,
//     required this.isRead,
//     required this.userId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: _getIconForType(),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(body),
//           if (timestamp != null)
//             Text(
//               DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp!),
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//         ],
//       ),
//       trailing: isRead ? null : const Icon(Icons.brightness_1, size: 12, color: Colors.blue),
//       onTap: () {
//         if (!isRead) {
//           FirebaseFirestore.instance
//               .collection('notifications')
//               .doc(userId)
//               .collection('user_notifications')
//               .doc(id)
//               .update({'read': true});
//         }
//
//         _handleNotificationTap(context);
//       },
//     );
//   }
//
//   Widget _getIconForType() {
//     switch (type) {
//       case 'booking':
//         return const Icon(Icons.calendar_today, color: Colors.blue);
//       case 'approval':
//         return const Icon(Icons.check_circle, color: Colors.green);
//       case 'payment':
//         return const Icon(Icons.payment, color: Colors.amber);
//       default:
//         return const Icon(Icons.notifications, color: Colors.grey);
//     }
//   }
//
//   void _handleNotificationTap(BuildContext context) {
//     switch (type) {
//       case 'booking':
//         Navigator.pushNamed(
//           context,
//           '/booking_details',
//           arguments: payload['bookingId'],
//         );
//         break;
//       case 'approval':
//         Navigator.pushNamed(context, '/my_services');
//         break;
//       case 'payment':
//         Navigator.pushNamed(context, '/wallet');
//         break;
//       default:
//       // Do nothing
//         break;
//     }
//   }
// }