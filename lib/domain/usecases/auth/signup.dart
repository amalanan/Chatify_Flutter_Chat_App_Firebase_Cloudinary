import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/models/auth/create_user_req.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class SignUpUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) {
    print("INSIDE SIGNUP USECASE");
    return sl<AuthRepository>().signup(params!);
  }
}
