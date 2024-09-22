import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'search.dart';

class MyCustomForm extends StatefulWidget {
  MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 32, color: Colors.black),
                  controller: myController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Input your question"
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search(myController.text))
                      );
                    });
                  },
                  child: Text("submit")
              )
            ],
          ),
        )
    );
  }
}