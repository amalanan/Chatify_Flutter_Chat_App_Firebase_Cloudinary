import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../../core/configs/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
}
