import 'dart:convert';

import 'package:dictionary_app/dictionary_model.dart';
import 'package:http/http.dart' as http;

class ApiServices{
  static String baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  static Future<DictionaryModel?> fetchData(String word) async{
    Uri url = Uri.parse('${baseUrl}${word}');
    final res = await http.get(url);
    try {
      if(res.statusCode == 200){
        final data = json.decode(res.body);
        print(word);
        print(data[0]);
        return DictionaryModel.fromJson(data[0]);
      }
      else{
        throw Exception("Failure to load meaning");
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}