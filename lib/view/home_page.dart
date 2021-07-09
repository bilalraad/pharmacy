import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/controllers/cart_controller.dart';
import 'package:pharmacy/controllers/medicine_controller.dart';

import './medicine/medicines_categories_tab.dart';
import './profile/profile_tab.dart';
import './settings_tab.dart';
import './cart/widgets/cart_icon.dart';
import './core/core.dart';
import './home_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<Widget> _pageS = [
  MedicinesCategoriesTab(),
  HomeTab(),
  ProfileTab(),
  SettingsTab(),
];

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Get.put<MedicineController>(MedicineController());
    Get.put<CartController>(CartController());

    super.initState();
  }

  int pageindex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Image.asset("assets/images/logo.png"),
        title: Text(
          "Lazurite",
          style: AppTextStyles.headerStyle().copyWith(color: AppColors.white),
        ),
        actions: [CartIcon()],
      ),
      backgroundColor: AppColors.kPrimaryLightColor,
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        animationDuration: Duration(milliseconds: 400),
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(Icons.list_sharp, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() => pageindex = index);
        },
      ),
      body: _pageS[pageindex],
    );
  }
}
