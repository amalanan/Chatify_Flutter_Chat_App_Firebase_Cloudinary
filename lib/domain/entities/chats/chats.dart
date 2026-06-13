class Chats {
  final String id;
  final List<String> members;
  final bool isGroup;
  final bool isActive;
  final String lastMessage;

  Chats({
    required this.id,
    required this.members,
    required this.isGroup,
    required this.isActive,
    required this.lastMessage,
  });
}
