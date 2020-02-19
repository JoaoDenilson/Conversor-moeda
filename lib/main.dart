import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url = "https://api.hgbrasil.com/finance";

Future<Map> getData() async {
  var response = await http.get(url);
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var realController = TextEditingController();
  var dolarController = TextEditingController();
  var dolar = 0.0;

  void _clarAll(){
    realController.text = "";
    dolarController.text = "";
  }

  void _realChanged(text){
    double real = double.parse(text);
    dolarController.text = (real/this.dolar).toStringAsFixed(2);
  }

  void _dolarChanged(text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clarAll,
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando os dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20.0
                  ),
                )
              );
              break;
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Erro ao carregar dados!",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20.0
                    ),
                  )
                );
              }else{
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber
                      ),
                      buildTextField(
                        "Real", "R\$", realController, _realChanged
                      ),
                      Divider(),
                      buildTextField(
                        "Dolar", "US\$", dolarController, _dolarChanged
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    controller: controller,
    onChanged: f,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0
    ),
    keyboardType: TextInputType.numberWithOptions(
      decimal: true, signed: false
    ),
  );
}
