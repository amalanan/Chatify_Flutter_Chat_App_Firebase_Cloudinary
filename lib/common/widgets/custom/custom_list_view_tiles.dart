import 'package:firebase_chat_app/common/widgets/custom/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../data/models/auth/user.dart';
import '../../../models/chat.dart';
import '../../../models/chat_message.dart';
import 'message_bubble.dart';

class CustomListViewTile extends StatelessWidget {
  final double height;
  final UserModel user;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomListViewTile({
    super.key,
    required this.height,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      onTap: onTap,
      minVerticalPadding: height * .20,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        size: height / 2,
        imagePath: user.image ?? Chat.defaultAvatar,
        isActive: user.lastActive != null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final UserModel user;
  final bool isActivity;
  final VoidCallback onTap;

  const CustomListViewTileWithActivity({
    super.key,
    required this.height,
    required this.user,
    required this.isActivity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: height * .20,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: super.key!,
        size: height / 2,
        imagePath: user.image ?? Chat.defaultAvatar,
        isActive: user.lastActive != null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          isActivity
              ? Row(
                children: [
                  SpinKitThreeBounce(color: Colors.white54, size: height * .10),
                ],
              )
              : Text(
                user.lastActive as String,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final UserModel sender;

  const CustomChatListViewTile({
    super.key,
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOwnMessage)
            RoundedImageNetwork(
              key: super.key!,
              imagePath: sender.image ?? Chat.defaultAvatar,
              size: width * .08,
            ),

          SizedBox(width: width * .05),

          MessageBubble(message: message, isOwnMessage: isOwnMessage),
        ],
      ),
    );
  }
}
