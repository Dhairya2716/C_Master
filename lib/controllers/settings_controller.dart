import 'package:c_master/core/utils/import_export.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var notificationsEnabled = true.obs;

  final user = FirebaseAuth.instance.currentUser;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _box.read<bool>('isDarkMode') ?? false;
    notificationsEnabled.value = _box.read<bool>('notifications') ?? true;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _box.write('isDarkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _box.write('notifications', value);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
  }
}