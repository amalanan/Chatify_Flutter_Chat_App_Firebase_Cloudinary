import 'package:dartz/dartz.dart';
import '../../repository/chats/chats_repo.dart';

class GetChatsUseCase {
  final ChatsRepository repository;

  GetChatsUseCase(this.repository);

  Stream<Either> call(String userId) {
    return repository.getChats(userId);
  }
}
