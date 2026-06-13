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
              color:
                  context.isDarkMode ? AppColors.secondary : AppColors.primary,
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
              color:
                  context.isDarkMode
                      ? AppColors.secondary
                      : Colors.purple.shade900,
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
                    color:
                        context.isDarkMode
                            ? AppColors.secondary
                            : AppColors.primary,
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
                                  title: Text(
                                    'Delete Chat',
                                    style: TextStyle(
                                      color:
                                          context.isDarkMode
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                    ),
                                  ),
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
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color:
                                              context.isDarkMode
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
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
              color:
                  context.isDarkMode ? AppColors.secondary : AppColors.primary,
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
                      ? Icon(
                        Icons.person,
                        color:
                            context.isDarkMode
                                ? AppColors.secondary
                                : AppColors.primary,
                      )
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
                      color:
                          context.isDarkMode
                              ? AppColors.secondary
                              : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color:
                    context.isDarkMode
                        ? AppColors.secondary
                        : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
