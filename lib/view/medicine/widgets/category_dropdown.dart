import 'package:flutter/material.dart';

import '../../core/core.dart';

List<String> categories = [
  'Chroic Diseases',
  'Mediciences For Nerves',
  'Cosmic Medicines',
  'Gynecological',
  'DataHerbal remedy',
  'Skin-care',
  "Chemical drugs",
];

class CategoryDropDown extends StatelessWidget {
  final String currentCategory;
  final Function(String newCategory) onCategorySelected;
  const CategoryDropDown(
      {required this.currentCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Category',
          style: AppTextStyles.body(
            fontWeight: FontWeight.bold,
            textColor: AppColors.black,
          ),
        ),
        Container(
          // width: 300,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kPrimaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButton<String>(
            value: currentCategory.isEmpty ? categories.first : currentCategory,
            items: categories
                .map<DropdownMenuItem<String>>((category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: AppTextStyles.inputStyle(),
                      ),
                    ))
                .toList(),
            onChanged: (value) => onCategorySelected(value!),
            // isExpanded: true,
            underline: Container(),
            icon: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.kPrimaryColor,
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
