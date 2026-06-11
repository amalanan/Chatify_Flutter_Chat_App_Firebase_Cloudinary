import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/configs/constants/app_urls.dart';
import '../../../domain/entities/auth/user.dart';
import '../../models/auth/create_user_req.dart';
import '../../models/auth/signin_user_req.dart';
import '../../models/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> signin(SignInUserReq signInUserReq);

  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SignInUserReq signInUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInUserReq.email,
        password: signInUserReq.password,
      );
      return Right('Sign In Was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'Invalid Email') {
        message = 'No User Found for that Email';
      } else if (e.code == 'invalid-credentials') {
        message = 'Wrong Password Provided';
      }
      return left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );
      await FirebaseFirestore.instance
          .collection('chat_users')
          .doc(data.user?.uid)
          .set({
            'name': createUserReq.name,
            'email': data.user!.email,
            'image': null,
            'last_active': FieldValue.serverTimestamp(),
          });
      return Right('Sign Up Was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      return left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user =
          await firebaseFirestore
              .collection('chat_users')
              .doc(firebaseAuth.currentUser?.uid)
              .get();

      UserModel userModel = UserModel.fromJson(user.data()!, user.id);
      userModel.image =
          firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
}
