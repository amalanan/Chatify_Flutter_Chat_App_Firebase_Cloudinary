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
        final chats =
            snapshot.docs.map((doc) {
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
