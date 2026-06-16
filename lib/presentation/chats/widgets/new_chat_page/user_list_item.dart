import 'package:firebase_chat_app/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import '../../../../core/configs/theme/app_colors.dart';

class UserListItem extends StatelessWidget {
  final String receiverId;
  final String name;
  final String image;
  final VoidCallback onTap;

  const UserListItem({
    super.key,
    required this.receiverId,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color:
                  context.isDarkMode
                      ? AppColors.lightBackground
                      : AppColors.darkBackground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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