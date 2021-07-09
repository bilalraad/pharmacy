import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controller_state.dart';
import '../../controllers/user_controller.dart';
import 'reset_password.dart';
import '../core/core.dart';
import '../home_page.dart';
import './sign_up.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final usercontroller = UserContoller.to;
  bool loading = false;
  bool isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      loading = usercontroller.controllerState == ControllerState.loading;
      return Scaffold(
        body: LoadingOverlay(
          isLoading: loading,
          child: GradientBackround(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/logo.png",
                        fit: BoxFit.cover, width: 188),
                  ),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height * 0.7,
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
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 9),
                              alignment: Alignment.centerLeft,
                              child: Text("Welcome ...",
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: AppColors.secondaryColor,
                                  )),
                            ),
                            SizedBox(height: 20),
                            Text("Login", style: AppTextStyles.headerStyle()),
                            //todo: add better loading functionality
                            SizedBox(height: 30),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    RoundedInputField(
                                      keyboardType: TextInputType.name,
                                      hintText: "email",
                                      controller: _emailController,
                                      icon: Icons.person_sharp,
                                      validator: (value) {
                                        return validateEmail(value);
                                      },
                                    ),
                                    SizedBox(height: 30),
                                    RoundedInputField(
                                      hintText: "password",
                                      controller: _passwordController,
                                      obscureText: isPasswordHidden,
                                      suffixIcon: IconButton(
                                        icon: Icon(isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordHidden =
                                                !isPasswordHidden;
                                          });
                                        },
                                      ),
                                      icon: Icons.security,
                                      validator: (value) {
                                        return validatePassword(value);
                                      },
                                    ),
                                  ],
                                )),
                            Container(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ResetPassword();
                                  }));
                                },
                                child: Text("Forgot password ?",
                                    style: AppTextStyles.textButtonStyle()),
                              ),
                            ),
                            PrimaryButton(
                                onPressed: loading ? null : logIn,
                                text: "Login"),
                            SizedBox(height: 30),

                            Text('Or'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return SignUpPage();
                                }));
                              },
                              child: Text(
                                "Create a new account", //Go to Forgot password page
                                style: AppTextStyles.textButtonStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void logIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await usercontroller.logIn(
            _passwordController.text, _emailController.text);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
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
    }
  }
}
