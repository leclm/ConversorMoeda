import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // possibilita converter a API para json
import 'package:http/http.dart' as http; // essa biblioteca permite fazer as requisições
import 'dart:async'; // permite que fazer requisições e nao ter que ficar esperando, é uma requisição assíncrona, não trava o programa enquando esperamos a resposta do servidor

const request = "https://api.hgbrasil.com/finance/?format=json&key=15ddc7a0&symbol=bidi4";
 
Future<Map> getData() async {
  http.Response response = await http.get(request); // solicita atraves do metodo get para o servidor e armazena a resposta em "response", como os dados nao são retornados na hora, ele espera os dados chegaram (await) e por isso criamos a função como sendo async
  return json.decode(response.body);
}

void main() async {
  //print(await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final ieneController = TextEditingController();

  double dolarAPI;
  double euroAPI;
  double pesoAPI;
  double ieneAPI;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoController.text = "";
    ieneController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real/dolarAPI).toStringAsFixed(4);
    euroController.text = (real/euroAPI).toStringAsFixed(4);
    pesoController.text = (real/pesoAPI).toStringAsFixed(4);
    ieneController.text = (real/ieneAPI).toStringAsFixed(4);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (this.dolarAPI * dolar).toStringAsFixed(4);
    euroController.text = ((this.dolarAPI * dolar) / euroAPI).toStringAsFixed(4);
    pesoController.text = ((this.dolarAPI * dolar) / pesoAPI).toStringAsFixed(4);
    ieneController.text = ((this.dolarAPI * dolar) / ieneAPI).toStringAsFixed(4);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    
    double euro = double.parse(text);
    realController.text = (euro * this.euroAPI).toStringAsFixed(4);
    dolarController.text = ((euro * this.euroAPI) / dolarAPI).toStringAsFixed(4);
    pesoController.text = ((euro * this.euroAPI) / pesoAPI).toStringAsFixed(4);
    ieneController.text = ((euro * this.euroAPI) / ieneAPI).toStringAsFixed(4);
  }

  void _pesoChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    
    double peso = double.parse(text);
    realController.text = (peso * this.pesoAPI).toStringAsFixed(4);
    dolarController.text = ((peso * this.pesoAPI) / dolarAPI).toStringAsFixed(4);
    euroController.text = ((peso * this.pesoAPI) / euroAPI).toStringAsFixed(4);
    ieneController.text = ((peso * this.pesoAPI) / ieneAPI).toStringAsFixed(4);
  }

  void _ieneChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    
    double iene = double.parse(text);
    realController.text = (iene * this.ieneAPI).toStringAsFixed(4);
    dolarController.text = ((iene * this.ieneAPI) / dolarAPI).toStringAsFixed(4);
    euroController.text = ((iene * this.ieneAPI) / euroAPI).toStringAsFixed(4);
    pesoController.text = ((iene * this.ieneAPI) / pesoAPI).toStringAsFixed(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Currency Converter"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(// permite que eu crie uma tela de carregando enqaunto os dados nao vem do servidor. Coloco o tipo do FutureBuilder entre < >, nesse caso é do tipo Map = JSON
        future: getData(), // preciso passar que futuro eu quero que ele construa, nesse caso sao os dados retornados na funcao getData = os dados da API
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Loading Data",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
            default:
              if(snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error on Loading Data",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolarAPI = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euroAPI = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                pesoAPI = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                ieneAPI = snapshot.data["results"]["currencies"]["JPY"]["buy"];

                return SingleChildScrollView( // esse elemento permite que eu tenho uma tela que faça scroll, se por exemplo eu abrir o teclado e precisar arrastar a tela pra enxergar outro campo, é esse elemento que permite isso
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // stretch alarga todos os elementos da coluna para ocupar todo o espaço horizontal, incluindo os inputs
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          size: 120,
                          color: Colors.amber,
                        ),
                        SizedBox(height: 32.0), //poderia usar tbm o Divider(),
                        buildTextField("Real", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólar", "\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euro", "Є", euroController, _euroChanged),
                        Divider(),
                        buildTextField("Iene", "¥", ieneController, _ieneChanged),
                        Divider(),
                        buildTextField("Peso Argentino", "\$", pesoController, _pesoChanged),
                      ],
                    ),
                  )
                );
              }
          }
        },
      ) 
    );
  }
}

// cria uma função que retorna um Widget e recebe como parâmetro duas strings
Widget buildTextField(String moeda, String prefix, TextEditingController moedaController, Function moedaChanged) {
  return TextField(
    controller: moedaController,
    decoration: InputDecoration(
      labelText: moeda,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix + " ",
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true), // poderia usar somente "keyboardType: TextInputType.number", mas aí em iOS nao funciona o decimal. Usando o que está atualmente permitimos a digitação de número decimais em iOS também.
    style: TextStyle(
      color: Colors.amber,
      fontSize: 24
    ),
    onChanged: moedaChanged,
  );
}

