// import 'package:flutter/material.dart';
// import 'package:sewamitra/main.dart';
// import 'package:sewamitra/notificationService.dart';
//
// class NotificationHandler extends StatefulWidget {
//   final Widget child;
//
//   const NotificationHandler({required this.child});
//
//   @override
//   _NotificationHandlerState createState() => _NotificationHandlerState();
// }
//
// class _NotificationHandlerState extends State<NotificationHandler> {
//   @override
//   void initState() {
//     super.initState();
//     NotificationService.notificationStream.listen(_handleNotification);
//   }
//
//   void _handleNotification(Map<String, dynamic> data) {
//     final type = data['type'];
//
//     switch (type) {
//       case 'booking':
//         navigatorKey.currentState?.pushNamed(
//           '/booking_details',
//           arguments: data['bookingId'],
//         );
//         break;
//       case 'approval':
//         navigatorKey.currentState?.pushNamed('/my_services');
//         break;
//       case 'payment':
//         navigatorKey.currentState?.pushNamed('/wallet');
//         break;
//       default:
//       // Do nothing
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }