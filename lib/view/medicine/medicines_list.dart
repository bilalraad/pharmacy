import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/models/medicine.dart';
import '../../controllers/controller_state.dart';
import '../../controllers/medicine_controller.dart';
import '../core/core.dart';
import './medicine_info.dart';

class MedicineList extends StatefulWidget {
  final String category;

  MedicineList({Key? key, required this.category}) : super(key: key);

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  final _medicienController = MedicineController.to;
  final scrollController = ScrollController();
  List<Medicine> meds = [];
  @override
  void initState() {
    super.initState();
    meds = _filterMedsByCategory();
    if (meds.isEmpty) _medicienController.getMedicines();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2.5 &&
        !scrollController.position.outOfRange) {
      if (_medicienController.hasNext) {
        _medicienController.getMedicines();
      }
    }
  }

  List<Medicine> _filterMedsByCategory() {
    print(_medicienController.medicines.length);
    return _medicienController.medicines
        .where((el) => el.category == widget.category && el.quantity != 0)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget textMedicine(Medicine medicine) {
      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.kPrimaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          title: Text(
            medicine.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return MedicineInfo(medicine: medicine);
              }),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: AppTextStyles.subHeaderStyle(),
        ),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          color: AppColors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GradientBackround(
        child: Obx(() {
          final loading =
              _medicienController.controllerState == ControllerState.loading;
          meds = _filterMedsByCategory();

          print(loading);
          if (loading) return Center(child: LoadingDialog());
          if (meds.isNotEmpty)
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: meds.length,
                    itemBuilder: (context, index) {
                      return textMedicine(meds[index]);
                    },
                  ),
                ),
                if (loading)
                  Center(
                    child: GestureDetector(
                      onTap: _medicienController.getMedicines,
                      child: Container(
                        height: 25,
                        width: 25,
                        margin: EdgeInsets.all(5),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          else
            return Center(
              child: Text(
                'There is no items here',
                style: AppTextStyles.body(),
              ),
            );
        }),
      ),
    );
  }
}
