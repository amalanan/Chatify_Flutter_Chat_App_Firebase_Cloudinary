import '../../../domain/entities/chats/chats.dart';

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chats> chats;

  ChatsLoaded(this.chats);
}

class ChatsError extends ChatsState {
  final String message;

  ChatsError(this.message);
}