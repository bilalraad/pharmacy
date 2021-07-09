import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Data/models/medicine.dart';
import '../controllers/controller_state.dart';
import '../controllers/medicine_controller.dart';

import 'core/core.dart';
import 'medicine/medicine_info.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _medsController = MedicineController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: GradientBackround(
          child: ListView(
            children: [
              medicinesSlider(
                  _medsController.medicines, "Mediciences For Nerves"),
              medicinesSlider(_medsController.medicines, "Chroic Diseases"),
              medicinesSlider(_medsController.medicines, "Gynecological"),
            ],
          ),
        ));
  }

  Widget medicinesSlider(List<Medicine> meds, String category) {
    return Obx(() {
      final loading =
          _medsController.controllerState == ControllerState.loading;
      return Column(
        children: [
          SizedBox(height: 10),
          Text(category,
              textAlign: TextAlign.center, style: AppTextStyles.headerStyle()),
          SizedBox(
            width: 400,
            height: 200,
            child: loading
                ? Container(
                    // color: AppColors.secondaryColor,
                    child: LoadingDialog(bgColor: Colors.transparent),
                  )
                : Container(
                    child: CarouselSlider(
                      items: _medsController.medicines
                          .where((e) => e.category == category)
                          .take(5)
                          .toList()
                          .map((med) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MedicineInfo(medicine: med);
                              }),
                            );
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LoadImage(
                                url: med.imageUrl,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            margin: EdgeInsets.all(4.5),
                            width: 400,
                            height: 200,
                            alignment: Alignment.center,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        pauseAutoPlayOnTouch: false,
                        viewportFraction: 0.8,
                        height: 180,
                        enableInfiniteScroll: true,
                        initialPage: 0,
                      ),
                    ),
                  ),
          )
        ],
      );
    });
  }
}
