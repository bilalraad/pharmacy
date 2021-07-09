import 'package:flutter/material.dart';

import '../core/core.dart';
import './widgets/category_dropdown.dart';
import 'medicines_list.dart';

class MedicinesCategoriesTab extends StatefulWidget {
  @override
  _ListmedicineView createState() => _ListmedicineView();
}

class _ListmedicineView extends State {
  Container containerview(String category) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 180,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.kPrimaryColor,
      ),
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return MedicineList(category: category);
            }));
          },
          child: Text(category, style: AppTextStyles.headerStyle())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: GradientBackround(
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return containerview(categories[index]);
          },
        ),
      ),
    );
  }
}
