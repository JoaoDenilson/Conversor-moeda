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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              print("Refresh");
            },
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
              print(snapshot.data['results']['currencies']['USD']['buy']);
              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 150,
                      color: Colors.purple,
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