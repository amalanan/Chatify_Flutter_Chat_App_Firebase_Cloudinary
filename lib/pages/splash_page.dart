// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../services/cloudinary_service.dart';
// import '../services/database_service.dart';
// import '../services/navigation_service.dart';
// import 'package:get_it/get_it.dart';
// import '../services/media_service.dart';
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key, required this.onInitializationComplete});
//
//   final VoidCallback onInitializationComplete;
//
//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 1)).then((_) {
//       _setUp().then((_) => widget.onInitializationComplete());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: NavigationService.navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Chatify',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromRGBO(36, 35, 49, 1.0),
//           brightness: Brightness.dark,
//         ),
//       ),
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // LOGO
//               Container(
//                 width: 170,
//                 height: 200,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/logo.png'),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _setUp() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//     _registerServices();
//   }
//
//   void _registerServices() {
//     GetIt.instance.registerSingleton<NavigationService>(NavigationService());
//     GetIt.instance.registerSingleton<MediaService>(MediaService());
//     GetIt.instance.registerSingleton<CloudinaryService>(CloudinaryService());
//     GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
//   }
// }
//
// // ElevatedButton(
// //   onPressed: () async {
// //     final db = GetIt.instance<DatabaseService>();
// //     final media = GetIt.instance<MediaService>();
// //     final cloud = GetIt.instance<CloudinaryService>();
// //     final file = await media.pickImageFromLibrary();
// //
// //     if (file != null) {
// //       final url = await cloud.uploadImage(file);
// //
// //       if (url != null) {
// //         await db.sendImageMessage(
// //           chatId: "BXIaIeJq0b0yv06XqNv9",
// //           senderId: "uid1",
// //           imageUrl: url,
// //         );
// //       }
// //     }
// //   },
// //   child: Text("Send Image"),
// // ),
// // ElevatedButton(
// //   onPressed: () async {
// //     await FirebaseFirestore.instance.collection("chats").add({
// //       "members": ["uid1", "uid2"],
// //       "is_group": false,
// //       "is_active": true,
// //       "lastMessage": "Hello world 👋",
// //     });
// //     final mediaService = GetIt.instance<MediaService>();
// //
// //     final file = await mediaService.pickImageFromLibrary();
// //
// //     if (file != null) {
// //       final url = await CloudinaryService().uploadImage(file);
// //
// //       print("IMAGE URL: $url");
// //     } else {
// //       print("No image selected");
// //     }
// //   },
// //   child: Text("Send Text"),
// // ),
// // TEST BUTTON
// // ElevatedButton(
// //   onPressed: () async {
// //     final mediaService = GetIt.instance<MediaService>();
// //
// //     final file = await mediaService.pickImageFromLibrary();
// //
// //     if (file != null) {
// //       final url = await CloudinaryService().uploadImage(file);
// //
// //       print("IMAGE URL: $url");
// //     } else {
// //       print("No image selected");
// //     }
// //   },
// //   child: const Text("Test Upload Image"),
// // ),
import 'package:flutter/material.dart';
class SplashScreenUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
      body: Center(
        child: Container(
          width: 170,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo33.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
