import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Data/models/cart_item.dart';
import '../../Data/models/medicine.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/medicine_controller.dart';
import '../cart/widgets/cart_icon.dart';
import '../core/core.dart';
import './edit_medicine.dart';

class MedicineInfo extends StatefulWidget {
  final Medicine medicine;

  const MedicineInfo({Key? key, required this.medicine}) : super(key: key);
  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  late CartItem _cartItem;
  final _cartController = CartController.to;
  final _medController = MedicineController.to;

  @override
  void initState() {
    _cartItem = CartItem(quantity: 1, medcine: widget.medicine, cartItemId: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          color: AppColors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [CartIcon()],
      ),
      body: GradientBackround(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: LoadImage(
                    url: widget.medicine.imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            '${widget.medicine.name} ',
                            style: AppTextStyles.headerStyle(),
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red,
                          ),
                          child: IconButton(
                              onPressed: removeMed,
                              color: AppColors.white,
                              icon: Icon(Icons.delete)),
                        ),
                        SizedBox(width: 2),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.kPrimaryColor,
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return EditMedicine(oldMed: widget.medicine);
                                }));
                              },
                              color: AppColors.white,
                              icon: Icon(Icons.edit)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Description:",
                  style: AppTextStyles.subHeaderStyle()
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.medicine.description}",
                  style: AppTextStyles.body(),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: AppTextStyles.subHeaderStyle()
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Ideal Temperature: ${widget.medicine.temperature} °C",
                      style: AppTextStyles.body(),
                    ),
                    Text(
                      "Starting to work with: ${widget.medicine.durationToWork}",
                      style: AppTextStyles.body(),
                    ),
                    Text(
                      "Category: ${widget.medicine.category}",
                      style: AppTextStyles.body(),
                    ),
                    Text(
                      "Expiration Date: ${widget.medicine.expirationDate.day} "
                      "/ ${widget.medicine.expirationDate.month} "
                      "/ ${widget.medicine.expirationDate.year}",
                      style: AppTextStyles.body(),
                    ),
                    Text(
                      "${widget.medicine.quantity} available in stock",
                      style: AppTextStyles.body(),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CartStepper(
                  count: _cartItem.quantity,
                  size: 45,
                  activeBackgroundColor: AppColors.kPrimaryLightColor,
                  activeForegroundColor: AppColors.black,
                  didChangeCount: (count) {
                    setState(() {
                      _cartItem = _cartItem.copyWith(quantity: count);
                    });
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: PrimaryButton(
                      onPressed: () {
                        _cartController.addToCart(cartItem: _cartItem);
                      },
                      width: MediaQuery.of(context).size.width * 0.8,
                      text: 'Add to cart',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> removeMed() async {
    try {
      await _medController.removeMedicine(widget.medicine.medicineId);
      Navigator.of(context).pop();
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          backgroundColor: AppColors.kPrimaryColor,
          message: "The medicine has been successfully added",
        ),
      );
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
