import 'package:dartz/dartz.dart';

abstract class ChatsRepository {
  Stream<Either> getChats(String userId);
}
