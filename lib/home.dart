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
  String url = "https://jsonplaceholder.typicode.com";

  Future<Map> _recuperarPreco() async {
    String url = "http://blockchain.info/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Future<List<Post>> _recuperarPostagens() async {
    List<Post> lista = List();
    //Post post = Post();
    //lista.add(post);

    http.Response response = await http.get(url + "/posts");
    var dadosJson = json.decode(response.body);
    for (var post in dadosJson) {
      print("post" + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      lista.add(p);
    }
    return lista;
  }

  _post() async {
    http.Response response = await http.post(url + "/posts",
        headers: {"Content-type": "application/json; charset=UTF-8"});
  }

  _put() {}

  _patch() {}

  _delete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Salvar"),
                  onPressed: _post(),
                ),
                FlatButton(
                  child: Text("Salvar"),
                  onPressed: _post(),
                ),
                FlatButton(
                  child: Text("Salvar"),
                  onPressed: _post(),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
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
            ),
          ],
        ),
      ),
    );
  }
}
