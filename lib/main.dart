import './core/utils/import_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(ThemeController());

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isDark = box.read<bool>('isDarkMode') ?? false;
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'C Master',
          theme: AppTheme.lightTheme(themeCtrl.currentPalette),
          darkTheme: AppTheme.darkTheme(themeCtrl.currentPalette),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: Routes.LOGIN,
          getPages: AppPages.routes,
        ));
  }
}
