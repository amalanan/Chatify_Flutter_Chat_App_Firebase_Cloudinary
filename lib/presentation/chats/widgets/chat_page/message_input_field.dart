import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../../core/configs/theme/app_colors.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isUploading;
  final VoidCallback onSendMessage;
  final VoidCallback onSendImage;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.isUploading,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: isUploading ? null : onSendImage,
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
                  isUploading
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
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xff383838),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSendMessage,
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
