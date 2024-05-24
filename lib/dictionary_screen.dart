import 'package:dictionary_app/dictionary_model.dart';
import 'package:dictionary_app/services.dart';
import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {

  DictionaryModel? data;
  bool isLoading = false;
  String noDataFound = " Now You Can Search ";
  
  searchContaint(String word) async{
    setState(() {
      isLoading = true;
    });
    try {
      data = await ApiServices.fetchData(word);
      setState(() {
        noDataFound = "Sorry, Meaning can't found";
      });
    } catch (e) {
      data = null;
      setState(() {
        noDataFound = "Sorry, Meaning can't found";
      });
    } finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("शब्‍दकोश",style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SearchBar(
              hintText: "Search the word here....",
              onSubmitted: (value) {
                searchContaint(value);
              },
            ),
            SizedBox(height: 10,),
            if(isLoading) LinearProgressIndicator()
            else if(data != null) Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    data!.word,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue,
                      
                    ),
                  ),
                  Text(
                    data!.phonetics.isNotEmpty 
                    ? data!.phonetics[0].text ??""
                    :""
                  ),
                  SizedBox(height: 15,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data!.meanings.length,
                      itemBuilder: (context,index){
                        return showMeaning(data!.meanings[index]);
                      }
                    )
                  )

                ],
              )
            )
            else Center(
              child: Text(
                noDataFound,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  showMeaning(Meaning meaning){
    String wordDefinition = "";
    for(var ele in meaning!.definitions){
      // print(wordDefinition);
      int index = meaning.definitions.indexOf(ele);
      wordDefinition += "\n${index+1}.${ele.definition}\n";
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meaning!.partOfSpeech,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Definition : ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                wordDefinition,
                style: TextStyle(
                  fontSize: 16,
                  height: 1,
                ),
              ),
            ),

            wordRelation("Synonyms", meaning.synonyms),
            wordRelation("Antonyms", meaning.antonyms),

          ],
        ),
      ), 
    );
  }

  wordRelation(String title, List<String>? setList){
    if(setList?.isNotEmpty ?? false){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title : ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              setList!.toSet().toString()
              .replaceAll("{", "").replaceAll("}", ""),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      );
    }
    else{
      return SizedBox();
    }
  }

}