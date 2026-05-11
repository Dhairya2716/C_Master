import '../../core/utils/import_export.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.SIGNUP, page: () => RegisterPage()),
    GetPage(name: Routes.DASHBOARD, page: () => DashboardPage()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsPage()),
    GetPage(name: Routes.TOPICS, page: () => TopicListPage()),
    GetPage(name: Routes.TOPIC_DETAIL, page: () => const TopicDetailPage()),
    GetPage(name: Routes.QUIZ, page: () => QuizPage()),
    GetPage(name: Routes.QUIZ_RESULT, page: () => const ResultPage()),
    GetPage(name: Routes.PROGRESS, page: () => ProgressPage()),
    GetPage(name: Routes.BOOKMARKS, page: () => BookmarkPage()),
  ];
}
