import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../main.dart';
import '../core/core.dart';
import '../../Data/models/medicine.dart';
import '../../controllers/controller_state.dart';
import '../../controllers/medicine_controller.dart';
import './widgets/category_dropdown.dart';
import './widgets/datetime_picker.dart';

class EditMedicine extends StatefulWidget {
  final Medicine oldMed;

  const EditMedicine({required this.oldMed});
  @override
  _EditMedicineState createState() => _EditMedicineState();
}

class _EditMedicineState extends State<EditMedicine> {
  late TextEditingController _medNameController;
  late TextEditingController _decriptionController;
  late TextEditingController _temperatureController;
  late TextEditingController _durationOfWorkController;
  late TextEditingController _quantityController;
  DateTime? expirationDate;
  final _formKey = GlobalKey<FormState>();
  final _medicineController = MedicineController.to;
  late Medicine _medicine;
  bool loading = false;

  @override
  void initState() {
    _medicine = widget.oldMed;
    expirationDate = widget.oldMed.expirationDate;
    _medNameController = TextEditingController(text: _medicine.name);
    _temperatureController = TextEditingController(text: _medicine.temperature);
    _decriptionController = TextEditingController(text: _medicine.description);
    _durationOfWorkController =
        TextEditingController(text: _medicine.durationToWork);
    _quantityController =
        TextEditingController(text: _medicine.quantity.toString());

    super.initState();
  }

  @override
  void dispose() {
    _medNameController.dispose();
    _decriptionController.dispose();
    _temperatureController.dispose();
    _durationOfWorkController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      loading = _medicineController.controllerState == ControllerState.loading;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryLightColor,
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
                        child: Text("Edit Medicine",
                            style: AppTextStyles.headerStyle()),
                      ),
                      SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: 400,
                                height: 200,
                                alignment: Alignment.center,
                                child: LoadImage(
                                  url: _medicine.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                  'You can\'t change the medicine picture for now'),
                              RoundedInputField(
                                keyboardType: TextInputType.name,
                                hintText: "Medicine Name",
                                controller: _medNameController,
                                validator: (value) {
                                  return validateName(value);
                                },
                              ),
                              RoundedInputField(
                                keyboardType: TextInputType.text,
                                hintText: "Duration Of Work",
                                controller: _durationOfWorkController,
                                validator: (value) {
                                  return validateString(value);
                                },
                              ),
                              RoundedInputField(
                                keyboardType: TextInputType.multiline,
                                hintText: "Description",
                                minLines: 5,
                                controller: _decriptionController,
                                validator: (value) {
                                  return validateString(value);
                                },
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Ideal Temperature',
                                        style: AppTextStyles.body(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: RoundedInputField(
                                          keyboardType: TextInputType.number,
                                          hintText: "In Celsius",
                                          controller: _temperatureController,
                                          validator: (value) {
                                            return validateNumber(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: AppTextStyles.body(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: RoundedInputField(
                                          keyboardType: TextInputType.number,
                                          hintText: "In stock",
                                          controller: _quantityController,
                                          validator: (value) {
                                            return validateNumber(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 18),
                      DateTimePickerWidget(
                        onDateTimeSelected: (newDate) {
                          setState(() {
                            _medicine =
                                _medicine.copyWith(expirationDate: newDate);
                          });
                        },
                        currentDateTime: _medicine.expirationDate,
                      ),
                      SizedBox(height: 18),
                      CategoryDropDown(
                        currentCategory: _medicine.category,
                        onCategorySelected: (newCat) {
                          setState(() {
                            _medicine = _medicine.copyWith(category: newCat);
                          });
                        },
                      ),
                      SizedBox(height: 18),
                      PrimaryButton(
                          onPressed: updateMedicine, text: 'Update Medicine'),
                      SizedBox(height: 18),
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

  void updateMedicine() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        _medicine = _medicine.copyWith(
          description: _decriptionController.text,
          durationToWork: _durationOfWorkController.text,
          name: _medNameController.text,
          temperature: _temperatureController.text,
          quantity: int.parse(_quantityController.text),
        );
        await _medicineController.updateMedicine(medicine: _medicine);
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            backgroundColor: AppColors.kPrimaryColor,
            message: "The medicine has been successfully updated",
          ),
        );
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return Pharmacy();
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
