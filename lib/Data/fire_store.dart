import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'check_connection.dart';

class FirebaseStorageRepository {
  /// this function is used to upload profile picture
  static Future<String> uploadPicture(
      {required File image, required String fileName}) async {
    if (!await connected()) throw 'no internet Connection';

    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    try {
      await firebaseStorageRef.putFile(image);
      final imageUrl = await firebaseStorageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deletePicture({required String fileName}) async {
    if (!await connected()) throw 'no internet Connection';

    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    try {
      await firebaseStorageRef.delete();
    } catch (e) {
      rethrow;
    }
  }
}
