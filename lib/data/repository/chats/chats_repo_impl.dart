// // import 'package:dartz/dartz.dart';
// // import '../../../domain/repository/chats/chats_repo.dart';
// // import '../../models/chats/chats.dart';
// // import '../../sources/chats/chats_firebase_service.dart';
// //
// // class ChatsRepositoryImpl implements ChatsRepository {
// //   final ChatsFirebaseService service;
// //
// //   ChatsRepositoryImpl(this.service);
// //
// //   @override
// //   Stream<Either> getChats(String userId) {
// //     return service.getChats(userId).map((snapshot) {
// //       final chats =
// //           snapshot.docs.map((doc) {
// //             final data = doc.data() as Map<String, dynamic>;
// //             return ChatModel.fromJson(doc.id, data);
// //           }).toList();
// //       return Right(chats);
// //     });
// //   }
// // }
// import 'package:dartz/dartz.dart';
// import '../../../domain/repository/chats/chats_repo.dart';
// import '../../models/chats/chats.dart';
// import '../../sources/chats/chats_firebase_service.dart';
//
// class ChatsRepositoryImpl implements ChatsRepository {
//   final ChatsFirebaseService service;
//
//   ChatsRepositoryImpl(this.service);
//
//   // @override
//   // Stream<Either> getChats(String userId) {
//   //   try {
//   //     return service.getChats(userId).map((snapshot) {
//   //       final chats = snapshot.docs.map((doc) {
//   //         final data = doc.data() as Map<String, dynamic>;
//   //
//   //         return {
//   //           "id": doc.id,
//   //           "members": data["members"],
//   //           "is_group": data["is_group"],
//   //           "is_active": data["is_active"],
//   //           "lastMessage": data["lastMessage"] ?? "",
//   //         };
//   //       }).toList();
//   //
//   //       return Right(chats);
//   //     });
//   //   } catch (e) {
//   //     return Stream.value(Left(e.toString()));
//   //   }
//   // }
//   @override
//   Stream<Either> getChats(String userId) {
//     return service.getChats(userId).map((snapshot) {
//       final chats = snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//
//         return ChatsModel.fromJson(doc.id, data);
//       }).toList();
//
//       return Right(chats);
//     });
//   }
// }
import 'package:dartz/dartz.dart';
import '../../../domain/repository/chats/chats_repo.dart';
import '../../models/chats/chats.dart';
import '../../sources/chats/chats_firebase_service.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsFirebaseService service;

  ChatsRepositoryImpl(this.service);

  @override
  Stream<Either<String, List<ChatsModel>>> getChats(String userId) {
    return service.getChats(userId).map((snapshot) {
      try {
        final chats = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return ChatsModel.fromJson(doc.id, data);
        }).toList();

        return Right(chats);
      } catch (e) {
        return Left(e.toString());
      }
    });
  }
}