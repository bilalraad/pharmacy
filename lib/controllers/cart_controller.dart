import 'package:get/get.dart';
import 'package:pharmacy/Data/cart_repo.dart';
import 'package:pharmacy/Data/models/cart_item.dart';
import 'package:pharmacy/controllers/controller_state.dart';

class CartController extends GetxController {
  late CartRepo _cartRepository;

  static CartController get to => Get.find();

  final _cartItems = <CartItem>[].obs;

  final _controllerState = ControllerState.init.obs;

  ControllerState get controllerState {
    return _controllerState.value;
  }

  List<CartItem> get cartItems {
    return _cartItems;
  }

  @override
  void onInit() async {
    super.onInit();
    _cartRepository = CartRepo();
    _updateControllerState(ControllerState.loading);
    _cartItems.value = await _cartRepository.getCartItems();

    _updateControllerState(ControllerState.loaded);
  }

  Future<void> addToCart({required CartItem cartItem}) async {
    _updateControllerState(ControllerState.loading);
    try {
      //if the poduct is in the cart just increase the quantity.
      final ck = _cartItems
          .any((e) => e.medcine.medicineId == cartItem.medcine.medicineId);
      if (ck) {
        increaseQTY(cartItem.medcine.medicineId, cartItem.quantity);
      } else {
        //add the item to cart without it's id
        _cartItems.add(cartItem);
        final newcartItem = await _cartRepository.addToCart(cartItem: cartItem);
        //then update it after we get the id from database
        _cartItems[_cartItems.indexWhere((element) =>
                element.medcine.medicineId == cartItem.medcine.medicineId)] =
            newcartItem;
      }
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<void> increaseQTY(String medId, int increaseBy) async {
    try {
      final index = _cartItems.indexWhere((e) => e.medcine.medicineId == medId);
      _cartItems[index] = _cartItems[index]
          .copyWith(quantity: _cartItems[index].quantity + increaseBy);
      _cartRepository.updateCartItem(cartItem: _cartItems[index]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> decreaseQTY(String medId, int decreaseBy) async {
    try {
      final index = _cartItems.indexWhere((e) => e.medcine.medicineId == medId);
      _cartItems[index] = _cartItems[index]
          .copyWith(quantity: _cartItems[index].quantity - decreaseBy);
      _cartRepository.updateCartItem(cartItem: _cartItems[index]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    _updateControllerState(ControllerState.loading);
    try {
      await _cartRepository.clearCart(cartItems: _cartItems);
      _cartItems.clear();
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);
      rethrow;
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      _cartItems.removeWhere((element) => element.cartItemId == cartItemId);
      update();
      _cartRepository.removeFromCart(cartItemId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartItem({required CartItem cartItem}) async {
    _updateControllerState(ControllerState.loading);
    try {
      _cartRepository.updateCartItem(cartItem: cartItem);
      final index =
          _cartItems.indexWhere((e) => e.cartItemId == cartItem.cartItemId);
      _cartItems[index] = cartItem;
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);
      rethrow;
    }
  }

  void _updateControllerState(ControllerState state) {
    _controllerState.value = state;
    update();
  }
}
