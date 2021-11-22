import 'package:flutter/material.dart';
import 'package:sumo_connect/strategies.dart';
import 'package:sumo_connect/sync.dart';

import 'battle.dart';
import 'bluetooth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, Map<String, dynamic>> cards;

  _MyHomePageState() {
    cards = {
      "Sincronizar": {
        "description": "Para iniciar, sincronize seu robô",
        "function": () {openPage(const SyncPage());},
        "active": () => true
      },
      "Estratégias": {
        "description": "Cadastre uma nova estratégia para seu robô",
        "function": () {openPage(const StrategiesPage());},
        "active": () => (bleHandler.connectedTo != null)
      },
      "Batalha": {
        "description": "Reconhecimento da arena e inicialização da batalha",
        "function": () {openPage(const BattlePage());},
        "active": () => (bleHandler.connectedTo != null && bleHandler.connectedTo!.strategy != null)
      }
    };
  }

  openPage(StatefulWidget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      setState(() {});
    });
  }

  List<Widget> getCards() {
    List<Widget> widgets = [const SizedBox(height: 5)];
    final width = MediaQuery.of(context).size.width;

    for (String name in cards.keys) {
      widgets.add(
        Card(
          child: SizedBox(
            width: width*0.9,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, textScaleFactor: 1.4, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(cards[name]!["description"]),
                  ElevatedButton(
                    onPressed: (cards[name]!["active"]()) ? cards[name]!["function"] : null,
                    child: const Icon(Icons.arrow_forward)
                  )
                ]
              )
            )
          )
        )
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getCards()
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}