import 'package:c_master/core/utils/import_export.dart';
import 'package:c_master/services/api_service.dart';

class TopicController extends GetxController{

  var isLoading = true.obs;
  var topicList = <TopicModel>[].obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit(){
    fetchTopics();
    super.onInit();
  }

  void fetchTopics() async{

    try{
      isLoading.value = true;
      // Simulating a delay for a mock network request
      await Future.delayed(Duration(seconds: 1));
      
      // Attempt to load from API (will fail because baseUrl is empty)
      var data = await _apiService.fetchTopics();

      topicList.value =
          data.map<TopicModel>((e) => TopicModel.fromJson(e)).toList();

    }
    catch(e){
      print("API Error, falling back to mock data: $e");
      // Fallback to local dummy data from c_topics.dart
      topicList.value = cTopics;
    }
    finally{
      isLoading.value = false;
    }

  }

}