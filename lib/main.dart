import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url = "https://api.hgbrasil.com/finance";

Future<Map> getData() async{
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

  void _realChanged(text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
  }

  void _dolarChanged(text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
  }

  void _clarAll(){
    realController.text = "";
    dolarController.text = "";
  }

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
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(
              child: Text("Carregando os dados...."),
            );
            break;
            default:
              if(snapshot.hasError){
                 return Center(
                  child: Text("Erro ao carregar os dados"),
              );
            }
            else{
              dolar = snapshot.data['results']['currencies']['USD']['buy'];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 150,
                      color: Colors.amber,
                    ),
                    TextField(
                      controller: realController,
                      onChanged: _realChanged,
                      decoration: InputDecoration(
                        labelText: "Real",
                        labelStyle: TextStyle(color: Colors.amber),
                        border: OutlineInputBorder(),
                        prefixText: "R\$"
                      ),
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false
                      ),
                    ),
                    Divider(),
                    TextField(
                      controller: dolarController,
                      onChanged: _dolarChanged,
                      decoration: InputDecoration(
                        labelText: "Dolar",
                        labelStyle: TextStyle(color: Colors.amber),
                        border: OutlineInputBorder(),
                        prefixText: "US\$"
                      ),
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false
                      ),
                    )
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

