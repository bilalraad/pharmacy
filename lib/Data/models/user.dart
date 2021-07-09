import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String education;
  final String phoneNo;

  final String? imageUrl;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.education,
    required this.phoneNo,
    this.imageUrl,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? education,
    String? phoneNo,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      education: education ?? this.education,
      phoneNo: phoneNo ?? this.phoneNo,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserModel.init() {
    return UserModel(
      uid: '',
      fullName: '',
      email: '',
      education: '',
      imageUrl: '',
      phoneNo: '',
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        uid: doc.id,
        fullName: doc['fullName'],
        email: doc['email'],
        education: doc['education'],
        imageUrl: doc['imageUrl'],
        phoneNo: doc['phoneNo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'education': education,
      'phoneNo': phoneNo,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      education: map['education'],
      phoneNo: map['phoneNo'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, education: $education, phoneNo: $phoneNo, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.education == education &&
        other.phoneNo == phoneNo &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        education.hashCode ^
        phoneNo.hashCode ^
        imageUrl.hashCode;
  }
}
