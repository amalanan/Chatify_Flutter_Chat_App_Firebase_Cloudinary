import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../common/helpers/is_dark_mode.dart';
import '../../../../data/models/chats/chats.dart';
import '../../pages/chat_page.dart';

class ChatItem extends StatelessWidget {
  final ChatsModel chat;
  final int unreadCount;
  final String receiverId;
  final String currentUid;

  const ChatItem({
    super.key,
    required this.chat,
    required this.unreadCount,
    required this.receiverId,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

    return Dismissible(
      key: Key(chat.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.secondary
              : AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Chat',
              style: TextStyle(
                color: context.isDarkMode
                    ? AppColors.secondary
                    : AppColors.primary,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete this conversation? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: context.isDarkMode
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
        future: receiverId.isNotEmpty
            ? FirebaseFirestore.instance
            .collection('chat_users')
            .doc(receiverId)
            .get()
            : null,
        builder: (context, userSnapshot) {
          String receiverName = 'Unknown';
          String receiverImage = '';

          if (userSnapshot.hasData &&
              userSnapshot.data!.exists) {
            final userData = userSnapshot.data!.data()
            as Map<String, dynamic>?;

            receiverName = userData?['name'] ?? 'Unknown';
            receiverImage = userData?['image'] ?? '';
          }

          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chat.id)
                  .update({'unreadCount.$currentUid': 0});

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    chatId: chat.id,
                    receiverId: receiverId,
                    receiverName: receiverName,
                    receiverImage: receiverImage,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.grey.withOpacity(0.30),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                    AppColors.grey.withOpacity(0.3),
                    backgroundImage: receiverImage.isNotEmpty
                        ? NetworkImage(receiverImage)
                        : null,
                    child: receiverImage.isEmpty
                        ? Icon(
                      Icons.person,
                      color: context.isDarkMode
                          ? AppColors.secondary
                          : AppColors.primary,
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.isGroup
                              ? 'Group Chat'
                              : receiverName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.lastMessage.isNotEmpty
                              ? chat.lastMessage
                              : (chat.isGroup
                              ? 'Group Chat'
                              : 'Private Chat'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 13,
                            color: hasUnread
                                ? (context.isDarkMode
                                ? Colors.white
                                : Colors.black)
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.secondary
                            : AppColors.primary,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Text(
                        unreadCount > 99
                            ? '99+'
                            : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}