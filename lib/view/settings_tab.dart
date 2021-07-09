import 'package:flutter/material.dart';

import './core/core.dart';
import './medicine/add_medicine.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackround(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add medicine'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddMedicine();
                    }));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.details_sharp),
                  title: Text('Out off stock medicines'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return AddMedicine();
                    // }));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
