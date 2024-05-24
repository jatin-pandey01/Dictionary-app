import 'package:dictionary_app/dictionary_model.dart';
import 'package:http/http.dart' as http;

class ApiServices{
  String baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  Future<DictionaryModel> fetchData(String word) async{
    Uri url = Uri.parse('${baseUrl}${word}');
    final res = await http.get(url);
    try {
      
    } catch (e) {
      
    }
  }
}