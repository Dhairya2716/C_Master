import './core/utils/import_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put(AuthController());

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isDark = box.read<bool>('isDarkMode') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C Master',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    );
  }
}
