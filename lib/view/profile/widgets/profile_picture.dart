import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/controller_state.dart';
import '../../../controllers/user_controller.dart';
import '../../core/core.dart';

class ProfilePicture extends StatefulWidget {
  final String? imageUrl;
  ProfilePicture({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? imageFile;
  final _picker = ImagePicker();
  NetworkImage? profilepic;
  final _userController = UserContoller.to;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
      profilepic = NetworkImage(widget.imageUrl!);
  }

  _openGellery() async {
    try {
      var pickedFile = await _picker.getImage(source: ImageSource.gallery);
      Navigator.of(context).pop();
      if (pickedFile!.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        profilepic = null;
        await updateData();
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _openCamera() async {
    var pickedFile = await _picker.getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      imageFile = File(pickedFile.path);
      profilepic = null;
      await updateData();
    }
    setState(() async {});
  }

  Future<void> updateData() async {
    try {
      await _userController.updateUserData(
          user: _userController.user, image: imageFile);
    } catch (e) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: "$e",
        ),
      );
    }
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change the photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () => _openGellery(),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () => _openCamera(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () => _showDialog(context),
        child: Stack(
          children: <Widget>[
            Obx(() {
              final _loading =
                  _userController.controllerState == ControllerState.loading;
              return Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                    color: AppColors.kPrimaryColor, shape: BoxShape.circle),
                child: _loading
                    ? CircularProgressIndicator()
                    : _userController.user.imageUrl != null &&
                            _userController.user.imageUrl!.isNotEmpty
                        ? LoadImage(
                            url: _userController.user.imageUrl!,
                            fit: BoxFit.cover,
                            boxShape: BoxShape.circle,
                          )
                        : Icon(Icons.person),
              );
            }),
            Transform.translate(
              offset: const Offset(150, 150),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.camera, size: 40),
              ),
            )
          ],
        ),
      ),
    );
  }
}
