import 'package:flutter/material.dart';
import 'package:pharmacy/main.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/user_controller.dart';
import '../core/core.dart';
import './widgets/profile_picture.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _userController = UserContoller.to;
  textinfo(String text, icon) {
    return Row(
      children: [
        SizedBox(height: 20),
        Icon(icon, size: 34),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackround(
        child: Column(
          children: [
            ProfilePicture(imageUrl: _userController.user.imageUrl),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textinfo(_userController.user.fullName, Icons.person),
                  textinfo(_userController.user.email, Icons.mark_email_unread),
                  textinfo(_userController.user.phoneNo, Icons.phone_in_talk),
                  textinfo(_userController.user.education, Icons.school),
                ],
              ),
            ),
            PrimaryButton(
              backroundColor: AppColors.kPrimaryLightColor,
              textColor: AppColors.black,
              onPressed: () async {
                try {
                  _userController.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Pharmacy();
                  }));
                } catch (e) {
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      backgroundColor: Colors.red,
                      message: "$e",
                    ),
                  );
                }
              },
              text: 'Logout',
            )
          ],
        ),
      ),
    );
  }
}
