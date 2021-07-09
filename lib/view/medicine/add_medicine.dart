import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../core/core.dart';
import './widgets/medicine_picture.dart';
import '../../Data/models/medicine.dart';
import '../../controllers/controller_state.dart';
import '../../controllers/medicine_controller.dart';
import '../../main.dart';
import './widgets/category_dropdown.dart';
import './widgets/datetime_picker.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final _medNameController = TextEditingController();
  final _decriptionController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _durationOfWorkController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? expirationDate;
  File? imageFile;
  final _formKey = GlobalKey<FormState>();
  final _medicineController = MedicineController.to;
  Medicine _medicine = Medicine.init();
  bool loading = false;

  @override
  void dispose() {
    _medNameController.dispose();
    _decriptionController.dispose();
    _temperatureController.dispose();
    _durationOfWorkController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onImageSelected(File newImage) {
    setState(() {
      imageFile = newImage;
    });
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
                        child: Text("Add new Medicine",
                            style: AppTextStyles.headerStyle()),
                      ),
                      SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              MedicinePicture(
                                  onImageSelected: _onImageSelected),
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
                          onPressed: addMedicine, text: 'Add to database'),
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

  void addMedicine() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (imageFile == null) {
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            backgroundColor: AppColors.kPrimaryColor,
            message: "Please upload medicine image",
          ),
        );
        return;
      }
      try {
        _medicine = _medicine.copyWith(
          description: _decriptionController.text,
          durationToWork: _durationOfWorkController.text,
          name: _medNameController.text,
          temperature: _temperatureController.text,
          quantity: int.parse(_quantityController.text),
        );
        await _medicineController.addMedicine(
            medicine: _medicine, image: imageFile!);
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            backgroundColor: AppColors.kPrimaryColor,
            message: "The medicine has been successfully added",
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
