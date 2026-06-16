import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../../core/configs/theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String? text;
  final String? imageUrl;
  final bool isMe;
  final Timestamp? sentTime;

  const MessageBubble({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.isMe,
    required this.sentTime,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
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

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final hasText = text != null && text!.isNotEmpty;

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
                      onTap: () => _showFullImage(context, imageUrl!),
                      child: Image.network(
                        imageUrl!,
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
                      text!,
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
              _formatTime(sentTime!.toDate()),
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
}
