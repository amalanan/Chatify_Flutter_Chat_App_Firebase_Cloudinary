import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/configs/constants/app_urls.dart';
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
      print('Firebase Error Code: ${e.code}');

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;

        case 'wrong-password':
          message = 'Wrong password provided.';
          break;

        case 'invalid-email':
          message = 'Invalid email address.';
          break;

        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;

        default:
          message = e.message ?? 'Authentication failed.';
      }
      return Left(message);
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
      print('Firebase Signup Code: ${e.code}');
      print('Firebase Signup Message: ${e.message}');

      String message;

      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak';
          break;

        case 'email-already-in-use':
          message = 'An account already exists with that email.';
          break;

        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;

        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;

        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;

        default:
          message = e.message ?? 'Signup failed';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      final uid = firebaseAuth.currentUser?.uid;

      if (uid == null) {
        return const Left('User is not logged in');
      }

      final userDoc =
          await firebaseFirestore.collection('chat_users').doc(uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        return const Left('User data not found in Firestore');
      }

      UserModel userModel = UserModel.fromJson(userDoc.data()!, userDoc.id);

      userModel.image =
          firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;

      return Right(userModel.toEntity());
    } catch (e) {
      print('GetUser Error: $e');
      return Left(e.toString());
    }
  }
}
