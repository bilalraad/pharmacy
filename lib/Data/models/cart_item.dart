import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pharmacy/Data/models/medicine.dart';

class CartItem {
  final Medicine medcine;
  final String cartItemId;
  final int quantity;
  CartItem({
    required this.medcine,
    required this.cartItemId,
    required this.quantity,
  });

  CartItem copyWith({
    Medicine? medcine,
    String? cartItemId,
    int? quantity,
  }) {
    return CartItem(
      medcine: medcine ?? this.medcine,
      cartItemId: cartItemId ?? this.cartItemId,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromDocument(DocumentSnapshot doc, DocumentSnapshot medDoc) {
    return CartItem.fromMap(doc, medDoc);
  }

  Map<String, dynamic> toMap() {
    return {
      'medicineId': medcine.medicineId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(doc, medDoc) {
    return CartItem(
      medcine: Medicine.fromDocument(medDoc),
      cartItemId: doc.id,
      quantity: doc['quantity'],
    );
  }

  @override
  String toString() =>
      'CartItem(medcine: $medcine, cartItemId: $cartItemId, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.medcine == medcine &&
        other.cartItemId == cartItemId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode =>
      medcine.hashCode ^ cartItemId.hashCode ^ quantity.hashCode;
}
