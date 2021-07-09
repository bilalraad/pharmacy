import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  final String medicineId;
  final String name;
  final String imageUrl;
  final String description;
  final String temperature;
  final String durationToWork;
  final DateTime expirationDate;
  final int quantity;
  final String category;
  Medicine({
    required this.medicineId,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.temperature,
    required this.durationToWork,
    required this.expirationDate,
    required this.quantity,
    required this.category,
  });

  Medicine copyWith({
    String? medicineId,
    String? name,
    String? imageUrl,
    String? description,
    String? temperature,
    String? durationToWork,
    DateTime? expirationDate,
    int? quantity,
    String? category,
  }) {
    return Medicine(
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      temperature: temperature ?? this.temperature,
      durationToWork: durationToWork ?? this.durationToWork,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  factory Medicine.init() {
    return Medicine(
      medicineId: '',
      name: '',
      imageUrl: '',
      category: 'Chroic Diseases',
      description: '',
      durationToWork: '',
      expirationDate: DateTime.now(),
      quantity: 0,
      temperature: '',
    );
  }

  factory Medicine.fromDocument(DocumentSnapshot doc) {
    return Medicine(
      medicineId: doc.id,
      name: doc['name'],
      imageUrl: doc['imageUrl'],
      category: doc['category'],
      description: doc['description'],
      durationToWork: doc['durationToWork'],
      expirationDate:
          DateTime.fromMillisecondsSinceEpoch(doc['expirationDate']),
      quantity: doc['quantity'] as int,
      temperature: doc['temperature'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'temperature': temperature,
      'durationToWork': durationToWork,
      'expirationDate': expirationDate.millisecondsSinceEpoch,
      'quantity': quantity,
      'category': category,
    };
  }

  factory Medicine.fromMap(map) {
    return Medicine(
      medicineId: map['medicineId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      temperature: map['temperature'],
      durationToWork: map['durationToWork'],
      expirationDate:
          DateTime.fromMillisecondsSinceEpoch(map['expirationDate']),
      quantity: map['quantity'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Medicine.fromJson(String source) =>
      Medicine.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Medicine(medicineId: $medicineId, name: $name, imageUrl: $imageUrl, description: $description, temperature: $temperature, durationToWork: $durationToWork, expirationDate: $expirationDate, quantity: $quantity, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Medicine &&
        other.medicineId == medicineId &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.temperature == temperature &&
        other.durationToWork == durationToWork &&
        other.expirationDate == expirationDate &&
        other.quantity == quantity &&
        other.category == category;
  }

  @override
  int get hashCode {
    return medicineId.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        temperature.hashCode ^
        durationToWork.hashCode ^
        expirationDate.hashCode ^
        quantity.hashCode ^
        category.hashCode;
  }
}
