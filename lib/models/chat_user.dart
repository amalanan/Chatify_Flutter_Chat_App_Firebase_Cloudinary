import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String? imageURL;
  final DateTime? lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    this.imageURL,
    this.lastActive,
  });

  // ================= FROM FIRESTORE =================

  factory ChatUser.fromJson(Map<String, dynamic> json, String docId) {
    return ChatUser(
      uid: docId, // important fix 🔥
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      imageURL: json["image"],
      lastActive: json["last_active"] != null
          ? (json["last_active"] as Timestamp).toDate()
          : null,
    );
  }

  // ================= TO FIRESTORE =================

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "image": imageURL,
      "last_active": lastActive != null
          ? Timestamp.fromDate(lastActive!)
          : FieldValue.serverTimestamp(),
    };
  }

  // ================= HELPERS =================

  bool get isOnline {
    if (lastActive == null) return false;
    return DateTime.now().difference(lastActive!).inMinutes < 5;
  }

  String get lastSeenText {
    if (lastActive == null) return "Never active";
    return "${lastActive!.hour}:${lastActive!.minute}";
  }
}