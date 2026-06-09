// import 'package:cloud_firestore/cloud_firestore.dart';
//
// //Models
// import '../models/chat_message.dart';
//
// const String USER_COLLECTION = "chat_users";
// const String CHAT_COLLECTION = "chats";
// const String MESSAGES_COLLECTION = "messages";
//
// class DatabaseService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   DatabaseService();
//
//   // ================= USERS =================
//
//   Future<void> createUser(
//       String uid,
//       String email,
//       String name,
//       String image, // Cloudinary URL
//       ) async {
//     try {
//       await _db.collection(USER_COLLECTION).doc(uid).set({
//         "email": email,
//         "image": image,
//         "last_active": FieldValue.serverTimestamp(),
//         "name": name,
//       });
//     } catch (e) {
//       print("createUser error: $e");
//     }
//   }
//
//   Future<DocumentSnapshot> getUser(String uid) {
//     return _db.collection(USER_COLLECTION).doc(uid).get();
//   }
//
//   Future<QuerySnapshot> getUsers({String? name}) {
//     Query query = _db.collection(USER_COLLECTION);
//
//     if (name != null && name.isNotEmpty) {
//       query = query
//           .where("name", isGreaterThanOrEqualTo: name)
//           .where("name", isLessThanOrEqualTo: "$name\uf8ff");
//     }
//
//     return query.get();
//   }
//
//   Future<void> updateUserLastSeenTime(String uid) async {
//     try {
//       await _db.collection(USER_COLLECTION).doc(uid).update({
//         "last_active": DateTime.now().toUtc(),
//       });
//     } catch (e) {
//       print("updateUserLastSeenTime error: $e");
//     }
//   }
//
//   // ================= CHATS =================
//
//   Stream<QuerySnapshot> getChatsForUser(String uid) {
//     return _db
//         .collection(CHAT_COLLECTION)
//         .where('members', arrayContains: uid)
//         .snapshots();
//   }
//
//   Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
//     try {
//       return await _db.collection(CHAT_COLLECTION).add(data);
//     } catch (e) {
//       print("createChat error: $e");
//       return null;
//     }
//   }
//
//   Future<void> updateChatData(
//       String chatId,
//       Map<String, dynamic> data,
//       ) async {
//     try {
//       await _db.collection(CHAT_COLLECTION).doc(chatId).update(data);
//     } catch (e) {
//       print("updateChatData error: $e");
//     }
//   }
//
//   Future<void> deleteChat(String chatId) async {
//     try {
//       await _db.collection(CHAT_COLLECTION).doc(chatId).delete();
//     } catch (e) {
//       print("deleteChat error: $e");
//     }
//   }
//
//   // ================= MESSAGES =================
//
//   Stream<QuerySnapshot> streamMessagesForChat(String chatId) {
//     return _db
//         .collection(CHAT_COLLECTION)
//         .doc(chatId)
//         .collection(MESSAGES_COLLECTION)
//         .orderBy("sent_time", descending: false)
//         .snapshots();
//   }
//
//   Future<QuerySnapshot> getLastMessageForChat(String chatId) {
//     return _db
//         .collection(CHAT_COLLECTION)
//         .doc(chatId)
//         .collection(MESSAGES_COLLECTION)
//         .orderBy("sent_time", descending: true)
//         .limit(1)
//         .get();
//   }
//
//   Future<void> addMessageToChat(
//       String chatId,
//       ChatMessage message,
//       ) async {
//     try {
//       await _db
//           .collection(CHAT_COLLECTION)
//           .doc(chatId)
//           .collection(MESSAGES_COLLECTION)
//           .add(message.toJson());
//     } catch (e) {
//       print("addMessageToChat error: $e");
//     }
//   }
//
//   // ================= IMAGE MESSAGE HELPERS =================
//
//   Future<void> sendTextMessage({
//     required String chatId,
//     required ChatMessage message,
//   }) async {
//     await addMessageToChat(chatId, message);
//   }
//
//   Future<void> sendImageMessage({
//     required String chatId,
//     required String senderId,
//     required String imageUrl,
//   }) async {
//     try {
//       await _db
//           .collection(CHAT_COLLECTION)
//           .doc(chatId)
//           .collection(MESSAGES_COLLECTION)
//           .add({
//         "sender_id": senderId,
//         "text": null,
//         "imageUrl": imageUrl, // from Cloudinary
//         "sent_time": FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("sendImageMessage error: $e");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "chat_users";
const String CHAT_COLLECTION = "chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  // ================= USERS =================

  Future<void> createUser({
    required String uid,
    required String email,
    required String name,
    String? image, // Cloudinary URL
  }) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        "email": email,
        "name": name,
        "image": image,
        "last_active": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("createUser error: $e");
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _db.collection(USER_COLLECTION);

    if (name != null && name.isNotEmpty) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: "$name\uf8ff");
    }

    return query.get();
  }

  Future<void> updateUserLastSeen(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("updateUserLastSeen error: $e");
    }
  }

  // ================= CHATS =================

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<DocumentReference?> createChat({
    required List<String> members,
    bool isGroup = false,
  }) async {
    try {
      return await _db.collection(CHAT_COLLECTION).add({
        "members": members,
        "is_group": isGroup,
        "is_active": true,
        "lastMessage": "",
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("createChat error: $e");
      return null;
    }
  }

  Future<void> updateChatData({
    required String chatId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).update(data);
    } catch (e) {
      print("updateChatData error: $e");
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatId).delete();
    } catch (e) {
      print("deleteChat error: $e");
    }
  }

  // ================= MESSAGES =================

  Stream<QuerySnapshot> streamMessages(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> sendTextMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .add({
        "sender_id": senderId,
        "text": text,
        "imageUrl": null,
        "sent_time": FieldValue.serverTimestamp(),
      });

      await _db.collection(CHAT_COLLECTION).doc(chatId).update({
        "lastMessage": text,
      });
    } catch (e) {
      print("sendTextMessage error: $e");
    }
  }

  Future<void> sendImageMessage({
    required String chatId,
    required String senderId,
    required String imageUrl,
  }) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .add({
        "sender_id": senderId,
        "text": null,
        "imageUrl": imageUrl,
        "sent_time": FieldValue.serverTimestamp(),
      });

      await _db.collection(CHAT_COLLECTION).doc(chatId).update({
        "lastMessage": "📷 Image",
      });
    } catch (e) {
      print("sendImageMessage error: $e");
    }
  }
}