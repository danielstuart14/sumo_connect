import 'package:flutter/material.dart';
import 'package:sumo_connect/robot.dart';

import 'bluetooth.dart';

List<Robot> robots = [Robot("Sumô 2021", "40:52:2F:47:C2:4A")];

class SyncPage extends StatefulWidget {
  const SyncPage({Key? key}) : super(key: key);

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  List<Widget> getCards() {
    List<Widget> widgets = [const SizedBox(height: 5)];
    final width = MediaQuery.of(context).size.width;

    if (robots.isNotEmpty) {
      for (Robot robot in robots) {
        final Widget button;
        if (bleHandler.connectedTo == null) {
          button = ElevatedButton(
              onPressed: () {
                bleHandler.connect(robot);
                setState(() {});
              },
              child: const Text("Conectar")
          );
        } else {
          if (bleHandler.connectedTo == robot) {
            button = ElevatedButton(
                onPressed: () {
                  bleHandler.disconnect();
                  setState(() {});
                },
                child: const Text("Desconectar")
            );
          } else {
            button = const ElevatedButton(
                onPressed: null,
                child: Text("Conectar")
            );
          }
        }

        widgets.add(
          Dismissible(
              onDismissed: (_) {
                robots.remove(robot);
                setState(() {});
              },
              key: Key(robot.address),
              child: Card(
                  child: SizedBox(
                      width: width * 0.9,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(robot.name, textScaleFactor: 1.4,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(robot.address),
                                button
                              ]
                          )
                      )
                  )
              )
          )
        );
      }
    } else {
      widgets.add(const SizedBox(height: 5));
      widgets.add(const Text("Nenhum robô adicionado!"));
    }

    return widgets;
  }

  _showDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Fechar')
              ),
            ],
          );
        }
    );
  }

  addDevice() {
    String name = "";
    String addr = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Adicionar Robô'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      addr = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Endereço MAC',
                    ),
                  ),
                ]
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Fechar')
              ),
              TextButton(
                  onPressed: () {
                    if (name == "" || addr == "") {
                      Navigator.pop(context);
                      _showDialog("Adicionar Robô", "Valor inválido!");
                    } else {
                      final index = robots.indexWhere((robot) => robot.address == addr);
                      if (index < 0) {
                        robots.add(Robot(name, addr));
                        Navigator.pop(context);
                        setState(() {});
                      } else {
                        Navigator.pop(context);
                        _showDialog("Adicionar Robô", "Endereço já adicionado!");
                      }
                    }
                  },
                  child: const Text('Adicionar')
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sincronizar"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getCards()
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addDevice,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}