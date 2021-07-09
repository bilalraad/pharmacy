import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Data/models/user.dart';
import '../../controllers/controller_state.dart';
import '../../controllers/user_controller.dart';
import '../core/core.dart';
import '../home_page.dart';
import './login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _educationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final usercontroller = UserContoller.to;
  bool loading = false;
  bool isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _educationController.dispose();
    _fullNameController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      loading = usercontroller.controllerState == ControllerState.loading;

      return Scaffold(
        body: GradientBackround(
            child: LoadingOverlay(
          isLoading: loading,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //Contains the logo
                  alignment: Alignment.topCenter,
                  child: Image.asset("assets/images/logo.png",
                      fit: BoxFit.cover, width: 185),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.75,
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
                        topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: Text("Create a new account.",
                            style: AppTextStyles.headerStyle()),
                      ),
                      SizedBox(height: 50),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RoundedInputField(
                                keyboardType: TextInputType.name,
                                hintText: "Full name",
                                controller: _fullNameController,
                                icon: Icons.person_sharp,
                                validator: (value) {
                                  return validateName(value);
                                },
                              ),
                              RoundedInputField(
                                keyboardType: TextInputType.emailAddress,
                                hintText: "email",
                                controller: _emailController,
                                icon: Icons.email,
                                validator: (value) {
                                  return validateEmail(value);
                                },
                              ),
                              RoundedInputField(
                                hintText: "password",
                                controller: _passwordController,
                                icon: Icons.security,
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordHidden = !isPasswordHidden;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  return validatePassword(value);
                                },
                              ),
                              RoundedInputField(
                                keyboardType: TextInputType.phone,
                                hintText: "Phone number",
                                controller: _phoneNoController,
                                icon: Icons.phone,
                                validator: (value) {
                                  return validatePhoneNo(value);
                                },
                              ),
                              RoundedInputField(
                                keyboardType: TextInputType.text,
                                hintText: "Education",
                                controller: _educationController,
                                icon: Icons.book,
                                validator: (value) {
                                  return validateString(value);
                                },
                              ),
                            ],
                          )),
                      SizedBox(height: 18),
                      PrimaryButton(onPressed: signUp, text: 'Sign Up'),
                      SizedBox(height: 18),
                      Text('Or'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return LoginPage();
                          }));
                        },
                        child: Text(
                          "Log in",
                          style: AppTextStyles.textButtonStyle(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      );
    });
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      try {
        final newUser = UserModel(
            uid: '',
            fullName: _fullNameController.text,
            email: _emailController.text,
            education: _educationController.text,
            phoneNo: _phoneNoController.text);
        usercontroller.signUp(_passwordController.text, newUser);
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
