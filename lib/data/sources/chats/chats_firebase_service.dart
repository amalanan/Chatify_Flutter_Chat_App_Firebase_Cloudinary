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
