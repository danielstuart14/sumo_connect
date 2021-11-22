import 'package:flutter/material.dart';
import 'package:sumo_connect/strategy.dart';

import 'bluetooth.dart';

List<Strategy> strategies = [
  Strategy(startStrategy.straight, patrolStrategy.straight, attackStrategy.forward),
  Strategy(startStrategy.zigzag, patrolStrategy.tornado, attackStrategy.kick)
];

class StrategiesPage extends StatefulWidget {
  const StrategiesPage({Key? key}) : super(key: key);

  @override
  State<StrategiesPage> createState() => _StrategiesPageState();
}

class _StrategiesPageState extends State<StrategiesPage> {
  List<Widget> getCards() {
    List<Widget> widgets = [const SizedBox(height: 5)];
    final width = MediaQuery.of(context).size.width;

    if (strategies.isNotEmpty) {
      for (Strategy strategy in strategies) {
        final Widget button;
        if (bleHandler.connectedTo!.strategy == null) {
          button = ElevatedButton(
              onPressed: () {
                bleHandler.setStrategy(strategy);
                setState(() {});
              },
              child: const Text("Ativar")
          );
        } else {
          if (bleHandler.connectedTo!.strategy == strategy) {
            button = ElevatedButton(
                onPressed: () {
                  bleHandler.setStrategy(null);
                  setState(() {});
                },
                child: const Text("Desativar")
            );
          } else {
            button = const ElevatedButton(
                onPressed: null,
                child: Text("Ativar")
            );
          }
        }

        widgets.add(
            Dismissible(
                onDismissed: (_) {
                  strategies.remove(strategy);
                  setState(() {});
                },
                key: Key(strategy.hashCode.toString()),
                child: Card(
                    child: SizedBox(
                        width: width * 0.9,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Inicial: " + strategy.start.toString().split(".")[1]),
                                  Text("Patrulha: " + strategy.patrol.toString().split(".")[1]),
                                  Text("Ataque: " + strategy.attack.toString().split(".")[1]),
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
      widgets.add(const Text("Nenhuma estratégia adicionada!"));
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
    startStrategy start = startStrategy.straight;
    patrolStrategy patrol = patrolStrategy.straight;
    attackStrategy attack = attackStrategy.forward;
    showDialog(
        context: context,
        builder: (newContext) {
          return AlertDialog(
            title: const Text('Adicionar Robô'),
            content: StatefulBuilder(
            builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<startStrategy>(
                      value: start,
                      onChanged: (startStrategy? newValue) {
                        setState(() {
                          if (newValue != null) {
                            start = newValue;
                          }
                        });
                      },
                      items: startStrategy.values.map((startStrategy val) {
                        return DropdownMenuItem<startStrategy>(
                            value: val,
                            child: Text(val.toString()));
                      }).toList()),
                    DropdownButton<patrolStrategy>(
                        value: patrol,
                        onChanged: (patrolStrategy? newValue) {
                          setState(() {
                            if (newValue != null) {
                              patrol = newValue;
                            }
                          });
                        },
                        items: patrolStrategy.values.map((patrolStrategy val) {
                          return DropdownMenuItem<patrolStrategy>(
                              value: val,
                              child: Text(val.toString()));
                        }).toList()),
                    DropdownButton<attackStrategy>(
                        value: attack,
                        onChanged: (attackStrategy? newValue) {
                          setState(() {
                            if (newValue != null) {
                              attack = newValue;
                            }
                          });
                        },
                        items: attackStrategy.values.map((attackStrategy val) {
                          return DropdownMenuItem<attackStrategy>(
                              value: val,
                              child: Text(val.toString()));
                        }).toList())
                  ]
              );
          }),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(newContext);
                  },
                  child: const Text('Fechar')
              ),
              TextButton(
                  onPressed: () {
                    strategies.add(Strategy(start, patrol, attack));
                    Navigator.pop(newContext);
                    setState(() {});
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