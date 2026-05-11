import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = '';

  Future<List<dynamic>> fetchTopics() async{

    final response = await http.get(Uri.parse(baseUrl));

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Failed to load topics");
    }

  }

}