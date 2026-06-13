// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_chat_app/data/models/chats/chats.dart';
//
// import '../../../domain/entities/chats/chats.dart';
// import '../../../domain/repository/chats/chats_repo.dart';
//
// class ChatsFirebaseService {
//   final FirebaseFirestore firestore;
//
//   ChatsFirebaseService(this.firestore);
//
//   Stream<QuerySnapshot> getChats(String userId) {
//     return firestore
//         .collection('chats')
//         .where('members', arrayContains: userId)
//         .snapshots();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatsFirebaseService {
  Stream<QuerySnapshot> getChats(String userId);
}

class ChatsFirebaseServiceImpl implements ChatsFirebaseService {
  final FirebaseFirestore firestore;

  ChatsFirebaseServiceImpl(this.firestore);

  @override
  Stream<QuerySnapshot> getChats(String userId) {
    return firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .snapshots();
  }
}
