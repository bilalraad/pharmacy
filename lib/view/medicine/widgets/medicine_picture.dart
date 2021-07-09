import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/core.dart';

class MedicinePicture extends StatefulWidget {
  final Function(File newImage) onImageSelected;
  MedicinePicture({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _MedicinePictureState createState() => _MedicinePictureState();
}

class _MedicinePictureState extends State<MedicinePicture> {
  File? imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  _openGellery() async {
    try {
      var pickedFile = await _picker.getImage(source: ImageSource.gallery);
      Navigator.of(context).pop();
      if (pickedFile!.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        await updateData();
      }
      setState(() {});
    } catch (e) {
      print(e);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: "Unkown error happend, please try again later",
        ),
      );
    }
  }

  _openCamera() async {
    var pickedFile = await _picker.getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      imageFile = File(pickedFile.path);
      await updateData();
    }
    setState(() {});
  }

  Future<void> updateData() async {
    if (imageFile != null) widget.onImageSelected(imageFile!);
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose the photo'),
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
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () => _showDialog(context),
        child: Stack(
          children: <Widget>[
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryLightColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.kPrimaryColor, width: 2),
                image: imageFile != null
                    ? DecorationImage(
                        image: FileImage(imageFile!), fit: BoxFit.fitWidth)
                    : null,
              ),
              child: imageFile != null
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 40,
                          ),
                          Text('Add Medicine Photo'),
                          Text('1920 x 1080'),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
