import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/Data/medicine_repo.dart';

import './view/app_startup.dart';
import './controllers/user_controller.dart';
import './view/Auth/login.dart';
import 'view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MedicineRepo.uploadMedicines();
  Get.put<UserContoller>(UserContoller());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pharmacy(),
    );
  }
}

class Pharmacy extends StatefulWidget {
  @override
  _PharmacyState createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  final _userController = UserContoller.to;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_userController.authState == AuthState.init)
        return AppStartup();
      else if (_userController.authState == AuthState.authenticated)
        return HomePage();
      else if (_userController.authState == AuthState.notAuthenticated)
        return LoginPage();
      else
        return LoginPage();
    });
  }
}
