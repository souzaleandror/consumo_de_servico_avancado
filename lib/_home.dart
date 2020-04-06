import 'dart:convert';

import 'package:consumodeservicoavancado/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async {
    String url = "http://blockchain.info/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Future<List<Post>> _recuperarPostagens() async {
    List<Post> lista = List();
    //Post post = Post();
    //lista.add(post);
    String url = "https://jsonplaceholder.typicode.com";
    http.Response response = await http.get(url + "/posts");
    var dadosJson = json.decode(response.body);
    for (var post in dadosJson) {
      print("post" + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      lista.add(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<Map>(
          future: _recuperarPreco(),
          initialData: null,
          builder: (context, snapshot) {
            String resultado;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("Conexao none");
                break;
              case ConnectionState.waiting:
                resultado = "Carregando...";
                print("Conexao waiting");
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                print("Conexao done");
                if (snapshot.hasError) {
                  resultado = "Error";
                } else {
                  double valor = snapshot.data["BRL"]["buy"];
                  resultado = "O valor do bitcon ${valor.toString()}";
                }
                break;
            }
            return Center(
              child: Text(resultado),
            );
          },
        ),
        FutureBuilder<List<Post>>(
          future: _recuperarPostagens(),
          initialData: null,
          builder: (context, snap) {
            String resultado;
            switch (snap.connectionState) {
              case ConnectionState.none:
                print("Conexao none");
                break;
              case ConnectionState.waiting:
                resultado = "Carregando...";
                return Center(
                  child: CircularProgressIndicator(),
                );
                print("Conexao waiting");
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                print("Conexao done");
                if (snap.hasError) {
                  resultado = "Error";
                } else {
                  resultado = "Lista carrregour";
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      List<Post> lista = snap.data;
                      Post post = lista[index];

                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.id.toString()),
                      );
                    },
                  );
                }
                break;
            }
            return Center(
              child: Text(resultado),
            );
          },
        ),
      ],
    );
  }
}
