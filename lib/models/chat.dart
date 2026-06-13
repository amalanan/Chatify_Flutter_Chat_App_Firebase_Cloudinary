import '../data/models/auth/user.dart';

class Chat {
  final String uid;
  final bool isActive;
  final bool isGroup;
  final List<UserModel> members;

  late final List<UserModel> _recipients;

  Chat({
    required this.uid,
    required this.members,
    required this.isActive,
    required this.isGroup,
    required String currentUserUid,
  }) {
    _recipients = members.where((user) => user.uid != currentUserUid).toList();
  }

  List<UserModel> recipients() => _recipients;

  // ================= TITLE =================

  String title() {
    if (!isGroup) {
      return _recipients.isNotEmpty ? _recipients.first.name : "Unknown";
    }

    return _recipients.map((u) => u.name).join(", ");
  }

  // ================= IMAGE =================

  String imageURL() {
    if (!isGroup) {
      return _recipients.isNotEmpty
          ? (_recipients.first.image ?? defaultAvatar)
          : defaultAvatar;
    }

    return groupAvatar;
  }

  static const String defaultAvatar = "https://www.gravatar.com/avatar/?d=mp";

  static const String groupAvatar =
      "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
}
