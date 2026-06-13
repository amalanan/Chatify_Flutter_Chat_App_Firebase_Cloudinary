// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // //
// // // import '../../../providers/authentication_provider.dart';
// // // import '../bloc/chats_cubit.dart';
// // // import '../bloc/chats_state.dart';
// // //
// // // class ChatsPage extends StatefulWidget {
// // //   const ChatsPage({super.key});
// // //
// // //   @override
// // //   State<ChatsPage> createState() => _ChatsPageState();
// // // }
// // //
// // // class _ChatsPageState extends State<ChatsPage> {
// // //   late ChatsCubit cubit;
// // //   late AuthenticationProvider auth;
// // //
// // //   @override
// // //   void didChangeDependencies() {
// // //     super.didChangeDependencies();
// // //
// // //     cubit = context.read<ChatsCubit>();
// // //     //  auth = context.read<AuthenticationProvider>();
// // //     // final userId = FirebaseAuth.instance.currentUser?.uid;
// // //     // cubit.loadChats(userId!);
// // //   }
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       final userId = FirebaseAuth.instance.currentUser?.uid;
// // //
// // //       if (userId == null) return;
// // //
// // //       context.read<ChatsCubit>().loadChats(userId);
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: BlocBuilder<ChatsCubit, ChatsState>(
// // //         builder: (context, state) {
// // //           if (state is ChatsLoading) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //
// // //           if (state is ChatsError) {
// // //             return Center(child: Text(state.message));
// // //           }
// // //
// // //           if (state is ChatsLoaded) {
// // //             if (state.chats.isEmpty) {
// // //               return const Center(child: Text("No Chats Found"));
// // //             }
// // //
// // //             return ListView.builder(
// // //               itemCount: state.chats.length,
// // //               itemBuilder: (context, index) {
// // //                 final chat = state.chats[index];
// // //
// // //                 return ListTile(
// // //                   title: Text(chat.members.toString()),
// // //                   subtitle: Text(chat.isGroup ? "Group" : "Private"),
// // //                 );
// // //               },
// // //             );
// // //           }
// // //           return const SizedBox();
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   // @override
// // //   // Widget build(BuildContext context) {
// // //   //   return BlocBuilder<ChatsCubit, ChatsState>(
// // //   //     builder: (context, state) {
// // //   //       if (state is ChatsLoading) {
// // //   //         return const Center(child: CircularProgressIndicator());
// // //   //       }
// // //   //
// // //   //       if (state is ChatsError) {
// // //   //         return Center(child: Text(state.message));
// // //   //       }
// // //   //
// // //   //       if (state is ChatsLoaded) {
// // //   //         if (state.chats.isEmpty) {
// // //   //           return const Center(child: Text("No Chats Found"));
// // //   //         }
// // //   //
// // //   //         return ListView.builder(
// // //   //           itemCount: state.chats.length,
// // //   //           itemBuilder: (context, index) {
// // //   //             final chat = state.chats[index];
// // //   //
// // //   //             return ListTile(
// // //   //               title: Text(chat.members.toString()),
// // //   //               subtitle: Text(chat.isGroup ? "Group" : "Private"),
// // //   //             );
// // //   //           },
// // //   //         );
// // //   //       }
// // //   //
// // //   //       return const SizedBox();
// // //   //     },
// // //   //   );
// // //   // }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// //
// // import '../../../common/widgets/custom/top_bar.dart';
// // import '../bloc/chats_cubit.dart';
// // import '../bloc/chats_state.dart';
// //
// // class ChatsPage extends StatefulWidget {
// //   const ChatsPage({super.key});
// //
// //   @override
// //   State<ChatsPage> createState() => _ChatsPageState();
// // }
// //
// // class _ChatsPageState extends State<ChatsPage> {
// //   late double _deviceHeight;
// //   late double _deviceWidth;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final userId = FirebaseAuth.instance.currentUser?.uid;
// //       if (userId != null) {
// //         context.read<ChatsCubit>().loadChats(userId);
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     _deviceHeight = MediaQuery.of(context).size.height;
// //     _deviceWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(
// //             horizontal: _deviceWidth * 0.03,
// //             vertical: _deviceHeight * 0.02,
// //           ),
// //           child: Column(
// //             children: [
// //               _topBar(),
// //               SizedBox(height: _deviceHeight * 0.01),
// //               _chatsList(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _topBar() {
// //     return TopBar(
// //       'Chats',
// //       primaryAction: IconButton(
// //         icon: const Icon(Icons.logout, color: Color.fromRGBO(0, 82, 218, 1.0)),
// //         onPressed: () {
// //           FirebaseAuth.instance.signOut();
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _chatsList() {
// //     return Expanded(
// //       child: BlocBuilder<ChatsCubit, ChatsState>(
// //         builder: (context, state) {
// //           if (state is ChatsLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //
// //           if (state is ChatsError) {
// //             return Center(child: Text(state.message));
// //           }
// //
// //           if (state is ChatsLoaded) {
// //             final chats = state.chats;
// //
// //             if (chats.isEmpty) {
// //               return const Center(
// //                 child: Text(
// //                   "No Chats Found.",
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //               );
// //             }
// //
// //             return ListView.builder(
// //               itemCount: chats.length,
// //               itemBuilder: (context, index) {
// //                 final chat = chats[index];
// //
// //                 return ListTile(
// //                   contentPadding: const EdgeInsets.symmetric(vertical: 8),
// //
// //                   leading: const CircleAvatar(
// //                     child: Icon(Icons.chat),
// //                   ),
// //
// //                   title: Text(
// //                     chat.members.toString(),
// //                     style: const TextStyle(color: Colors.black),
// //                   ),
// //
// //                   subtitle: Text(
// //                     chat.isGroup ? "Group Chat" : "Private Chat",
// //                     style: const TextStyle(color: Colors.black),
// //                   ),
// //
// //                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// //
// //                   onTap: () {
// //                     // navigate to chat page لاحقًا
// //                   },
// //                 );
// //               },
// //             );
// //           }
// //
// //           return const SizedBox();
// //         },
// //       ),
// //     );
// //   }
// // }
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// //
// // import '../../../core/configs/assets/app_vectors.dart';
// // import '../../../core/configs/theme/app_colors.dart';
// // import '../bloc/chats_cubit.dart';
// // import '../bloc/chats_state.dart';
// // import 'chat_page.dart';
// //
// // class ChatsPage extends StatefulWidget {
// //   const ChatsPage({super.key});
// //
// //   @override
// //   State<ChatsPage> createState() => _ChatsPageState();
// // }
// //
// // class _ChatsPageState extends State<ChatsPage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final userId = FirebaseAuth.instance.currentUser?.uid;
// //       if (userId != null) {
// //         context.read<ChatsCubit>().loadChats(userId);
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         centerTitle: false,
// //         backgroundColor: Colors.transparent,
// //         title: Text(
// //           'Chats',
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 25,
// //             color: context.isDarkMode ? Colors.white : Colors.black,
// //           ),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               Icons.logout,
// //               color: context.isDarkMode ? Colors.white : Colors.black,
// //             ),
// //             onPressed: () {
// //               FirebaseAuth.instance.signOut();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         child: BlocBuilder<ChatsCubit, ChatsState>(
// //           builder: (context, state) {
// //             if (state is ChatsLoading) {
// //               return Center(
// //                 child: CircularProgressIndicator(color: AppColors.primary),
// //               );
// //             }
// //
// //             if (state is ChatsError) {
// //               return Center(
// //                 child: Text(
// //                   state.message,
// //                   style: TextStyle(
// //                     color: context.isDarkMode ? Colors.white : Colors.black,
// //                   ),
// //                 ),
// //               );
// //             }
// //
// //             if (state is ChatsLoaded) {
// //               final chats = state.chats;
// //
// //               if (chats.isEmpty) {
// //                 return _emptyState(context);
// //               }
// //
// //               return ListView.separated(
// //                 itemCount: chats.length,
// //                 separatorBuilder: (_, __) => const SizedBox(height: 10),
// //                 itemBuilder: (context, index) {
// //                   final chat = chats[index];
// //
// //                   final currentUid = FirebaseAuth.instance.currentUser!.uid;
// //                   final receiverId = chat.members.firstWhere(
// //                         (uid) => uid != currentUid,
// //                     orElse: () => '',
// //                   );
// //
// //                   return _chatItem(
// //                     context: context,
// //                     membersText: chat.members.toString(),
// //                     subtitle: chat.isGroup ? 'Group Chat' : 'Private Chat',
// //                     onTap: () async {
// //                       String receiverName = 'Unknown';
// //                       String receiverImage = '';
// //
// //                       if (receiverId.isNotEmpty) {
// //                         final userDoc = await FirebaseFirestore.instance
// //                             .collection('users')
// //                             .doc(receiverId)
// //                             .get();
// //
// //                         final userData = userDoc.data();
// //                         receiverName = userData?['name'] ?? 'Unknown';
// //                         receiverImage = userData?['image'] ?? '';
// //                       }
// //
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => ChatPage(
// //                             chatId: chat.id,
// //                             receiverId: receiverId,
// //                             receiverName: receiverName,
// //                             receiverImage: receiverImage,
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   );
// //                 },
// //               );
// //             }
// //
// //             return const SizedBox();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _emptyState(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //       //    SvgPicture.asset(AppVectors.chatBubble, height: 80),
// //           const SizedBox(height: 20),
// //           Text(
// //             'No Chats Found',
// //             style: TextStyle(
// //               fontWeight: FontWeight.w600,
// //               fontSize: 16,
// //               color: context.isDarkMode ? Colors.white : Colors.black,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Start chatting with your friends',
// //             style: TextStyle(
// //               fontWeight: FontWeight.w400,
// //               fontSize: 13,
// //               color: AppColors.grey,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _chatItem({
// //     required BuildContext context,
// //     required String membersText,
// //     required String subtitle,
// //     required VoidCallback onTap,
// //   }) {
// //     return InkWell(
// //       borderRadius: BorderRadius.circular(15),
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: context.isDarkMode
// //               ? Colors.white.withOpacity(0.05)
// //               : AppColors.grey,
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         child: Row(
// //           children: [
// //             CircleAvatar(
// //               radius: 26,
// //               backgroundColor: AppColors.grey.withOpacity(0.3),
// //               child: Icon(Icons.chat, color: AppColors.grey),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     membersText,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 15,
// //                       color: context.isDarkMode ? Colors.white : Colors.black,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     subtitle,
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w400,
// //                       fontSize: 13,
// //                       color: AppColors.grey,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Icon(
// //               Icons.arrow_forward_ios,
// //               size: 16,
// //               color: AppColors.grey,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../core/configs/assets/app_vectors.dart';
// import '../../../core/configs/theme/app_colors.dart';
// import '../../auth/pages/loginPage.dart';
// import '../bloc/chats_cubit.dart';
// import '../bloc/chats_state.dart';
// import 'chat_page.dart';
// import 'new_chat_page.dart';
//
// class ChatsPage extends StatefulWidget {
//   const ChatsPage({super.key});
//
//   @override
//   State<ChatsPage> createState() => _ChatsPageState();
// }
//
// class _ChatsPageState extends State<ChatsPage> {
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         context.read<ChatsCubit>().loadChats(userId);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: false,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'Chats',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//             color: context.isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.edit_outlined,
//               color: context.isDarkMode ? Colors.white : Colors.black,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NewChatPage()),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.logout,
//               color: context.isDarkMode ? Colors.white : Colors.black,
//             ),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//
//               if (!context.mounted) return;
//
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => SignInPage()),
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: BlocBuilder<ChatsCubit, ChatsState>(
//           builder: (context, state) {
//             if (state is ChatsLoading) {
//               return Center(
//                 child: CircularProgressIndicator(color: AppColors.primary),
//               );
//             }
//
//             if (state is ChatsError) {
//               return Center(
//                 child: Text(
//                   state.message,
//                   style: TextStyle(
//                     color: context.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//               );
//             }
//
//             if (state is ChatsLoaded) {
//               final chats = state.chats;
//
//               if (chats.isEmpty) {
//                 return _emptyState(context);
//               }
//
//               return ListView.separated(
//                 itemCount: chats.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 10),
//                 itemBuilder: (context, index) {
//                   final chat = chats[index];
//
//                   final currentUid = FirebaseAuth.instance.currentUser!.uid;
//                   final receiverId = chat.members.firstWhere(
//                     (uid) => uid != currentUid,
//                     orElse: () => '',
//                   );
//
//                   return _chatItem(
//                     context: context,
//                     membersText: chat.members.toString(),
//                     subtitle: chat.isGroup ? 'Group Chat' : 'Private Chat',
//                     onTap: () async {
//                       String receiverName = 'Unknown';
//                       String receiverImage = '';
//
//                       if (receiverId.isNotEmpty) {
//                         final userDoc =
//                             await FirebaseFirestore.instance
//                                 .collection('chat_users')
//                                 .doc(receiverId)
//                                 .get();
//
//                         final userData = userDoc.data();
//                         receiverName = userData?['name'] ?? 'Unknown';
//                         receiverImage = userData?['image'] ?? '';
//                       }
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => ChatPage(
//                                 chatId: chat.id,
//                                 receiverId: receiverId,
//                                 receiverName: receiverName,
//                                 receiverImage: receiverImage,
//                               ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             }
//
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _emptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           //SvgPicture.asset(AppVectors.chatBubble, height: 80),
//           const SizedBox(height: 20),
//           Text(
//             'No Chats Found',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: context.isDarkMode ? Colors.white : Colors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start chatting with your friends',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 13,
//               color: AppColors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _chatItem({
//     required BuildContext context,
//     required String membersText,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(15),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color:
//               context.isDarkMode
//                   ? Colors.white.withOpacity(0.05)
//                   : AppColors.grey,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: AppColors.grey.withOpacity(0.3),
//               child: Icon(Icons.chat, color: AppColors.grey),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     membersText,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       color: context.isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13,
//                       color: AppColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/chats_cubit.dart';
import '../bloc/chats_state.dart';
import '../../auth/pages/loginPage.dart';
import 'chat_page.dart';
import 'new_chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        context.read<ChatsCubit>().loadChats(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: context.isDarkMode ? Colors.white : AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: context.isDarkMode ? Colors.white : AppColors.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewChatPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: context.isDarkMode ? Colors.white : Colors.purple.shade900,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignInPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<ChatsCubit, ChatsState>(
          builder: (context, state) {
            if (state is ChatsLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is ChatsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              );
            }

            if (state is ChatsLoaded) {
              final chats = state.chats;

              if (chats.isEmpty) {
                return _emptyState(context);
              }

              return ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final currentUid = FirebaseAuth.instance.currentUser!.uid;
                  final receiverId = chat.members.firstWhere(
                    (uid) => uid != currentUid,
                    orElse: () => '',
                  );

                  return Dismissible(
                    key: Key(chat.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Delete Chat'),
                                  content: const Text(
                                    'Are you sure you want to delete this conversation? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          ) ??
                          false;
                    },
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chat.id)
                          .delete();
                    },
                    child: FutureBuilder<DocumentSnapshot>(
                      future:
                          receiverId.isNotEmpty
                              ? FirebaseFirestore.instance
                                  .collection('chat_users')
                                  .doc(receiverId)
                                  .get()
                              : null,
                      builder: (context, userSnapshot) {
                        String receiverName = 'Unknown';
                        String receiverImage = '';

                        if (userSnapshot.hasData && userSnapshot.data!.exists) {
                          final userData =
                              userSnapshot.data!.data()
                                  as Map<String, dynamic>?;
                          receiverName = userData?['name'] ?? 'Unknown';
                          receiverImage = userData?['image'] ?? '';
                        }

                        return _chatItem(
                          context: context,
                          name: chat.isGroup ? 'Group Chat' : receiverName,
                          image: receiverImage,
                          subtitle:
                              chat.lastMessage.isNotEmpty
                                  ? chat.lastMessage
                                  : (chat.isGroup
                                      ? 'Group Chat'
                                      : 'Private Chat'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatPage(
                                      chatId: chat.id,
                                      receiverId: receiverId,
                                      receiverName: receiverName,
                                      receiverImage: receiverImage,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //   SvgPicture.asset(AppVectors.chatBubble, height: 80),
          const SizedBox(height: 20),
          Text(
            'No Chats Found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with your friends',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatItem({
    required BuildContext context,
    required String name,
    required String image,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              context.isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.grey.withOpacity(0.30),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.grey.withOpacity(0.3),
              backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
              child:
                  image.isEmpty
                      ? Icon(Icons.person, color: AppColors.primary)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
