import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy/Data/models/cart_item.dart';

import 'check_connection.dart';

abstract class BaseCartCollection {
  Future<List<CartItem>> getCartItems();
  Future<CartItem> addToCart({required CartItem cartItem});
  Future<void> removeFromCart(String cartItemId);
  Future<void> updateCartItem({required CartItem cartItem});
  Future<void> clearCart({required List<CartItem> cartItems});
}

class CartRepo implements BaseCartCollection {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('cart');
  @override
  Future<CartItem> addToCart({required CartItem cartItem}) async {
    if (!await connected()) throw 'no internet Connection';

    try {
      final doc = _cartCollection.doc();
      cartItem = cartItem.copyWith(cartItemId: doc.id);
      doc.set(cartItem.toMap());
      return cartItem;
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    if (!await connected()) throw 'no internet Connection';
    try {
      await _cartCollection.doc(cartItemId).delete();
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<void> updateCartItem({required CartItem cartItem}) async {
    if (!await connected()) throw 'no internet Connection';

    try {
      await _cartCollection.doc(cartItem.cartItemId).set(cartItem.toMap());
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    if (!await connected()) throw 'no internet Connection';

    QuerySnapshot cartSnapshot;
    try {
      cartSnapshot = await _cartCollection.get();

      if (cartSnapshot.docs.isNotEmpty) {
        final items = await _cartListFromSnapshot(cartSnapshot);
        return items;
      } else
        return [];
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<void> clearCart({required List<CartItem> cartItems}) async {
    try {
      var snapshots = await _cartCollection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  Future<List<CartItem>> _cartListFromSnapshot(QuerySnapshot snap) async {
    List<CartItem> items = [];

    for (var doc in snap.docs) {
      try {
        final medDoc = await FirebaseFirestore.instance
            .collection('medicines')
            .doc(doc['medicineId'])
            .get();
        items.add(CartItem.fromDocument(doc, medDoc));
      } catch (e) {
        print(e);
        rethrow;
      }
    }

    return items;
  }
}
