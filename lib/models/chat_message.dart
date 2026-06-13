import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime sentTime;

  ChatMessage({
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.sentTime,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json["sender_id"] ?? "",
      text: json["text"],
      imageUrl: json["imageUrl"],
      sentTime: (json["sent_time"] as Timestamp).toDate(),
    );
  }

  // ================= TO FIRESTORE =================

  Map<String, dynamic> toJson() {
    return {
      "sender_id": senderId,
      "text": text,
      "imageUrl": imageUrl,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }

  // ================= HELPERS =================

  bool get isText => text != null;
  bool get isImage => imageUrl != null;
}