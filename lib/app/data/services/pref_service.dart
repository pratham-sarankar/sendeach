import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PrefService extends GetxService {
  late final GetStorage _box;
  late RxBool deleteAfterSent;

  Future<PrefService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    deleteAfterSent = readBool(Preference.deleteAfterSent).obs;
    return this;
  }

  void _update(Preference preference) {
    switch (preference) {
      case Preference.deleteAfterSent:
        deleteAfterSent.value = readBool(preference);
        break;
    }
  }

  Future<void> saveBool(Preference preference, bool value) async {
    await _box.write(preference.key, value);
    _update(preference);
    return;
  }

  bool readBool(Preference preference) {
    return _box.read<bool>(preference.key) ?? false;
  }
}

enum Preference {
  deleteAfterSent,
}

extension PreferenceExtension on Preference {
  String get key => toString().split('.').last;
}
