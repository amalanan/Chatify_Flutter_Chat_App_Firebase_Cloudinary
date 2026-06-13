import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/chats/chats_usecase.dart';
import 'chats_state.dart';
import '../../../domain/entities/chats/chats.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetChatsUseCase getChatsUseCase;

  ChatsCubit(this.getChatsUseCase) : super(ChatsInitial());

  StreamSubscription? _subscription;

  void loadChats(String userId) {
    emit(ChatsLoading());

    _subscription?.cancel();

    _subscription = getChatsUseCase(userId).listen((event) {
      // event.fold(
      //       (error) {
      //     emit(ChatsError(error.toString()));
      //   },
      //       (data) {
      //     // data = List<Chats>
      //     emit(ChatsLoaded(List<Chats>.from(data)));
      //   },
      // );
      event.fold(
            (error) {
          emit(ChatsError(error.toString()));
        },
            (data) {
          emit(ChatsLoaded(List<Chats>.from(data)));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}