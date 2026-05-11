import '../core/utils/import_export.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController{

  final AuthService _authService = AuthService();
  final FirestoreService _firebaseService = FirestoreService();

  var isLoading = false.obs;

  Future login(String email, String password) async{

    try{

      isLoading.value = true;

      final user = await _authService.login(email, password);

      if(user != null){
        Get.offNamed(Routes.DASHBOARD);
      }

    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }
    finally{
      isLoading.value = false;
    }

  }

  Future register(String email, String password) async{

    try{

      isLoading.value = true;

      final user = await _authService.register(email, password);

      if(user != null){

        final newUser = UserModel(
            uid: user.uid,
            email: email,
            name: email.split("@")[0],
            createdAt: DateTime.now().toString(),
        );

        await _firebaseService.saveUser(newUser);

        Get.offNamed(Routes.DASHBOARD);
      }

    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }
    finally{
      isLoading.value = false;
    }

  }

  Future googleLogin() async{

    try{

      isLoading.value = true;

      final user = await _authService.signInWithGoogle();

      if(user != null){
        Get.offNamed('/dashboard');
      }

    }
    catch(e){
      Get.snackbar("Google Login failed", e.toString());
    }
    finally{
      isLoading.value = false;
    }

  }

  Future logout() async{
    await _authService.logout();
    Get.offNamed('/login');
  }

}