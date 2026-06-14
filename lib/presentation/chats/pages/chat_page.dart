import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'package:get_it/get_it.dart';
import '../../../services/cloudinary_service.dart';
import '../../../services/media_service.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MediaService _mediaService = GetIt.instance<MediaService>();
  final CloudinaryService _cloudinaryService =
      GetIt.instance<CloudinaryService>();
  bool _isUploading = false;

  String get _currentUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await _sendMessageData(text: text, imageUrl: null);

    _messageController.clear();
  }

  Future<void> _sendImage() async {
    final pickedFile = await _mediaService.pickImageFromLibrary();
    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final imageUrl = await _cloudinaryService.uploadImage(pickedFile);

      if (imageUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
        return;
      }

      await _sendMessageData(text: null, imageUrl: imageUrl);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _sendMessageData({String? text, String? imageUrl}) async {
    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId);

    final messageRef = chatRef.collection('messages').doc();

    await messageRef.set({
      'sender_id': _currentUid,
      'text': text,
      'imageUrl': imageUrl,
      'sent_time': FieldValue.serverTimestamp(),
    });

    await chatRef.set({
      'members': [_currentUid, widget.receiverId],
      'is_active': true,
      'is_group': false,
      'lastMessage': text ?? '📷 Photo',
    }, SetOptions(merge: true));

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final diff = now.difference(lastActive);

    if (diff.inMinutes < 2) {
      return 'Active now';
    } else if (diff.inMinutes < 60) {
      return 'Active ${diff.inMinutes}m ago';
    } else if (diff.inHours < 24 && now.day == lastActive.day) {
      return 'Active today at ${_formatTime(lastActive)}';
    } else if (diff.inDays < 2) {
      return 'Active yesterday at ${_formatTime(lastActive)}';
    } else {
      return 'Active on ${lastActive.day}/${lastActive.month}/${lastActive.year}';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('chat_users')
                  .doc(widget.receiverId)
                  .snapshots(),
          builder: (context, snapshot) {
            String statusText = '';

            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              final lastActive = data?['last_active'];

              if (lastActive is Timestamp) {
                statusText = _formatLastActive(lastActive.toDate());
              }
            }
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.grey.withOpacity(0.3),
                  backgroundImage:
                      widget.receiverImage.isNotEmpty
                          ? NetworkImage(widget.receiverImage)
                          : null,
                  child:
                      widget.receiverImage.isEmpty
                          ? Icon(Icons.person, color: AppColors.grey, size: 20)
                          : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.receiverName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (statusText.isNotEmpty)
                      Text(
                        statusText,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .orderBy('sent_time', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hi 👋',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['sender_id'] == _currentUid;
                    final text = data['text'] as String?;
                    final imageUrl = data['imageUrl'] as String?;
                    final sentTime = data['sent_time'] as Timestamp?;

                    return _messageBubble(
                      context: context,
                      text: text,
                      imageUrl: imageUrl,
                      isMe: isMe,
                      sentTime: sentTime,
                    );
                  },
                );
              },
            ),
          ),
          _messageInputField(context),
        ],
      ),
    );
  }

  Widget _messageBubble({
    required BuildContext context,
    required String? text,
    required String? imageUrl,
    required bool isMe,
    required Timestamp? sentTime,
  }) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final hasText = text != null && text.isNotEmpty;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding:
                hasImage
                    ? const EdgeInsets.all(4)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? AppColors.primary
                      : context.isDarkMode
                      ? Colors.white.withOpacity(0.08)
                      : AppColors.grey,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () => _showFullImage(context, imageUrl),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 150,
                              width: 150,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image),
                            ),
                      ),
                    ),
                  ),
                if (hasText)
                  Padding(
                    padding:
                        hasImage
                            ? const EdgeInsets.fromLTRB(8, 6, 8, 2)
                            : EdgeInsets.zero,
                    child: Text(
                      text,
                      style: TextStyle(
                        color:
                            isMe
                                ? Colors.white
                                : context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (sentTime != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              _formatTime(sentTime.toDate()),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(child: Image.network(imageUrl)),
            ),
          ),
    );
  }

  Widget _messageInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _sendImage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    context.isDarkMode
                        ? Colors.white.withOpacity(0.08)
                        : AppColors.grey,
                shape: BoxShape.circle,
              ),
              child:
                  _isUploading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                      : Icon(
                        Icons.image_outlined,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
