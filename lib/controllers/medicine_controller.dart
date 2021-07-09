import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:pharmacy/Data/medicine_repo.dart';
import 'package:pharmacy/Data/models/medicine.dart';
import 'package:pharmacy/controllers/controller_state.dart';

class MedicineController extends GetxController {
  late MedicineRepo _medRepository;

  static MedicineController get to => Get.find();

  final _medicines = <Medicine>[].obs;
  final _controllerState = ControllerState.init.obs;
  int medicinesLimit = 15;
  bool _hasNext = true;

  ControllerState get controllerState => _controllerState.value;
  List<Medicine> get medicines => _medicines;
  bool get hasNext => _hasNext;

  @override
  void onInit() async {
    super.onInit();
    _medRepository = MedicineRepo();
    _updateControllerState(ControllerState.loading);
    try {
      _medicines.value = await _medRepository.getMedicines(medicinesLimit);

      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);
    }
  }

  Future<void> getMedicines() async {
    if (_controllerState.value == ControllerState.loading) return;
    _updateControllerState(ControllerState.loading);
    List<Medicine> newMeds = [];
    try {
      newMeds = await _medRepository.getMedicines(
        medicinesLimit,
        lastItemId: _medicines.isNotEmpty ? _medicines.last.medicineId : null,
      );

      print('getMedicines');
      print(newMeds.length);
      _medicines.addAll(newMeds);
      if (newMeds.length < medicinesLimit) _hasNext = false;
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<void> addMedicine(
      {required Medicine medicine, required File image}) async {
    _updateControllerState(ControllerState.loading);
    try {
      medicine =
          await _medRepository.addMedicine(medicine: medicine, image: image);

      _medicines.add(medicine);
      update();

      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<void> removeMedicine(String medicineId) async {
    _updateControllerState(ControllerState.loading);
    try {
      _medicines.removeWhere((m) => m.medicineId == medicineId);
      _medRepository.removeMedicine(medicineId);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<void> updateMedicine({required Medicine medicine, File? image}) async {
    _updateControllerState(ControllerState.loading);
    try {
      _medicines[_medicines
          .indexWhere((m) => m.medicineId == medicine.medicineId)] = medicine;
      _medRepository.updateMedicine(medicine: medicine, image: image);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<Medicine> getMedicineData(String medId) async {
    try {
      final isIsAvailable = _medicines.any((e) => e.medicineId == medId);
      if (isIsAvailable) {
        return _medicines.firstWhere((e) => e.medicineId == medId);
      } else {
        final med = await _medRepository.getMedicineData(medId);
        return med;
      }
    } catch (e) {
      rethrow;
    }
  }

  void _updateControllerState(ControllerState state) {
    _controllerState.value = state;
    update();
  }
}
