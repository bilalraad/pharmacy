import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/controller_state.dart';
import '../../controllers/user_controller.dart';
import '../core/core.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userController = UserContoller.to;
  bool loading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      loading = _userController.controllerState == ControllerState.loading;

      return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: GradientBackround(
          child: SingleChildScrollView(
            child: LoadingOverlay(
              isLoading: loading,
              child: Column(
                  //Column that contains the items
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      //Contains the logo
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                        width: 188,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 29),
                            blurRadius: 100,
                            color: Colors.black87,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 60),
                        child: Column(
                          children: [
                            Text("Find your account .",
                                style: AppTextStyles.headerStyle()),
                            SizedBox(height: 30),
                            Text(
                              "Please enter your email and we will send you a link to reset your password.",
                              style: AppTextStyles.body(),
                            ),
                            SizedBox(height: 40),
                            Form(
                              key: _formKey,
                              child: RoundedInputField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                hintText: "Emali or Phone",
                                icon: Icons.email,
                                validator: (value) => validateEmail(value),
                              ),
                            ),
                            SizedBox(height: 60),
                            PrimaryButton(
                                onPressed: resetPassword,
                                text: "Reset password"),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _userController.resetPassword(_emailController.text);
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            backgroundColor: AppColors.kPrimaryColor,
            message: "A reset password link has been sent to your email",
          ),
        );
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
  }
}
