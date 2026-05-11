import '../core/utils/import_export.dart';

class DashboardController extends GetxController{

  var username = "User".obs;

  @override
  void onInit(){
    super.onInit();
    loadUser();
  }

  void loadUser(){

    final user = FirebaseAuth.instance.currentUser;

    if(user != null){
      username.value = user.email ?? "User";
    }

  }

}