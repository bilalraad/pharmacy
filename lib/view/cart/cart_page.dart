import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Data/models/cart_item.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/controller_state.dart';
import '../../controllers/medicine_controller.dart';
import '../../main.dart';
import '../core/core.dart';
import '../medicine/medicine_info.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);
  final _cartController = CartController.to;
  final _medController = MedicineController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Text(
          "Cart",
          style: AppTextStyles.headerStyle(),
        ),
        centerTitle: true,
        leading: IconButton(
          color: AppColors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GradientBackround(child: Obx(() {
        return _cartController.cartItems.isNotEmpty
            ? LoadingOverlay(
                isLoading:
                    _cartController.controllerState == ControllerState.loading,
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: _cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                            cartItem: _cartController.cartItems[index]);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: PrimaryButton(
                          width: MediaQuery.of(context).size.width * 0.80,
                          text: 'Check Out',
                          onPressed: () async {
                            _cartController.cartItems.forEach((c) {
                              _medController.updateMedicine(
                                  medicine: c.medcine.copyWith(
                                      quantity:
                                          c.medcine.quantity - c.quantity));
                            });
                            try {
                              await _cartController.clearCart();
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  message:
                                      "The items have been removed from the repository successfully!",
                                ),
                              );
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: Text('No items are added to the cart'));
      })),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  CartItemWidget({required this.cartItem});
  final _cartController = CartController.to;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            width: 100,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LoadImage(
                url: cartItem.medcine.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          title: Text(
            cartItem.medcine.name,
            style: AppTextStyles.headerStyle(),
          ),
          subtitle: Row(
            children: [
              Text('QTY: ${cartItem.quantity}x'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              _cartController.removeFromCart(cartItem.cartItemId);
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return MedicineInfo(medicine: cartItem.medcine);
              }),
            );
          },
        ),
      ),
    );
  }
}
