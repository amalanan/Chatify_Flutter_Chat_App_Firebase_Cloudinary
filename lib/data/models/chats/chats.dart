import '../../../domain/entities/chats/chats.dart';

class ChatsModel extends Chats {
  ChatsModel({
    required super.id,
    required super.members,
    required super.isGroup,
    required super.isActive,
    required super.lastMessage,
  });

  factory ChatsModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatsModel(
      id: id,
      members: List<String>.from(json["members"] ?? []),
      isGroup: json["is_group"] ?? false,
      isActive: json["is_active"] ?? false,
      lastMessage: json["lastMessage"] ?? "",
    );
  }
}
