import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drug Research App')),
        body: Material(
          child:DrugResearchForm(),
        )
      ),
    );
  }
}

class DrugResearchForm extends StatefulWidget {
  @override
  _DrugResearchFormState createState() => _DrugResearchFormState();
}

class _DrugResearchFormState extends State<DrugResearchForm> {
  final _controller = TextEditingController();

  void makePostRequest(String drugName) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v1/drug-research'));
    request.body = json.encode({"drugName": drugName});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField( // TextField를 직접 추가
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter drug name'),
          ),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () {
              makePostRequest(_controller.text);
            },
          ),
        ],
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter drug name'),
          ),
    ),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () {
              makePostRequest(_controller.text);
            },
          ),
        ],
      ),
    );
  }

   */
}
