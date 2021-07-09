import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/cart_controller.dart';
import '../cart_page.dart';
import '../../core/core.dart';

class CartIcon extends StatelessWidget {
  CartIcon({Key? key}) : super(key: key);

  final _cartController = CartController.to;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: AppColors.black,
      icon: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.shopping_cart_outlined),
          ),
          Obx(() => Text(
                _cartController.cartItems.length == 0
                    ? ''
                    : _cartController.cartItems.length.toString(),
                style: AppTextStyles.textButtonStyle(),
              )),
        ],
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return CartPage();
        }));
      },
    );
  }
}
