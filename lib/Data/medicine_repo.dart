import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:pharmacy/Data/fake_data.dart';

import 'check_connection.dart';
import 'fire_store.dart';
import 'models/medicine.dart';

abstract class BaseMedicineCollection {
  Future<List<Medicine>> getMedicines(int take, {String lastItemId});
  Future<Medicine> getMedicineData(String medId);
  Future<List<Medicine>> getMedicinesByCategory(int take, String category,
      {String? lastItemId});
  Future<void> addMedicine({required Medicine medicine, required File image});
  Future<void> removeMedicine(String medicineId);
  Future<void> updateMedicine({required Medicine medicine, File? image});
}

class MedicineRepo implements BaseMedicineCollection {
  final CollectionReference _medCollection =
      FirebaseFirestore.instance.collection('medicines');

  static Future<void> uploadMedicines() async {
    final medsRef = FirebaseFirestore.instance.collection('medicines');
    final currentMeds = await medsRef.limit(1).get();
    if (currentMeds.docs.isEmpty) {
      for (final med in List.of(meds)) {
        await medsRef.add(med);
      }
    }
  }

  @override
  Future<Medicine> addMedicine(
      {required Medicine medicine, required File image}) async {
    if (!await connected()) throw 'no internet Connection';

    try {
      final doc = _medCollection.doc();

      String imageUrl;
      imageUrl = await FirebaseStorageRepository.uploadPicture(
          image: image, fileName: doc.id);
      medicine = medicine.copyWith(imageUrl: imageUrl, medicineId: doc.id);

      await doc.set(medicine.toMap());
      return medicine;
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<void> removeMedicine(String medicineId) async {
    if (!await connected()) throw 'no internet Connection';
    try {
      await _medCollection.doc(medicineId).delete();
      await FirebaseStorageRepository.deletePicture(fileName: medicineId);
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<void> updateMedicine({required Medicine medicine, File? image}) async {
    if (!await connected()) throw 'no internet Connection';

    try {
      if (image != null) {
        String imageUrl;
        imageUrl = await FirebaseStorageRepository.uploadPicture(
            image: image, fileName: medicine.medicineId);
        medicine = medicine.copyWith(imageUrl: imageUrl);
      }

      await _medCollection.doc(medicine.medicineId).set(medicine.toMap());
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<List<Medicine>> getMedicines(int take, {String? lastItemId}) async {
    if (!await connected()) throw 'no internet Connection';

    QuerySnapshot medSnapshot;
    try {
      final medRef = _medCollection.orderBy('quantity').limit(take);
      if (lastItemId == null) {
        medSnapshot = await medRef.get();
      } else {
        final doc = await _medCollection.doc(lastItemId).get();
        medSnapshot = await medRef.startAfterDocument(doc).get();
      }
      return _medListFromSnapshot(medSnapshot);
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  @override
  Future<List<Medicine>> getMedicinesByCategory(int take, String category,
      {String? lastItemId}) async {
    if (!await connected()) throw 'no internet Connection';

    QuerySnapshot medSnapshot;
    try {
      final medRef = _medCollection
          // .orderBy('category')
          .where('category', isEqualTo: category)
          .limit(take);
      if (lastItemId == null) {
        medSnapshot = await medRef.get();
      } else {
        final doc = await _medCollection.doc(lastItemId).get();
        medSnapshot = await medRef.startAfterDocument(doc).get();
      }
      return _medListFromSnapshot(medSnapshot);
    } catch (e) {
      print(e);
      throw 'Unknown error, please try agan later';
    }
  }

  List<Medicine> _medListFromSnapshot(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      return Medicine.fromDocument(doc);
    }).toList();
  }

  Future<Medicine> getMedicineData(String medId) async {
    try {
      final medDoc = await _medCollection.doc(medId).get();
      var med = Medicine.fromDocument(medDoc);
      return med;
    } catch (e) {
      throw 'Unknown error, please try agan later';
    }
  }
}
