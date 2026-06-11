import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/auth/user.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  late final String? image;
  final DateTime? lastActive;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.image,
    this.lastActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      uid: docId,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      image: json["image"],
      lastActive:
          json["last_active"] != null
              ? (json["last_active"] as Timestamp).toDate()
              : null,
    );
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      name: name,
      image: image,
      uid: uid,
      lastActive: lastActive,
    );
  }
}
