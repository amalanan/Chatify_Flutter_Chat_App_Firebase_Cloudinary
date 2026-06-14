import 'package:equatable/equatable.dart';
import '../../../domain/entities/chats/chats.dart';

abstract class ChatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chats> chats;

  ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsError extends ChatsState {
  final String message;

  ChatsError(this.message);

  @override
  List<Object?> get props => [message];
}
