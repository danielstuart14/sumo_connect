import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sumo_connect/robot.dart';

import 'dart:io';
import 'bluetooth.dart';

List<Robot> robots = [Robot("Sumô 2021", "40:52:2F:47:C2:4A")];

class BattlePage extends StatefulWidget {
  const BattlePage({Key? key}) : super(key: key);

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  File? image;
  Position? robotPos;
  Position? enemyPos;

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    List<Widget> widgets = [
        Card(
            child: SizedBox(
                width: width * 0.9,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Imagem Dojô", textScaleFactor: 1.2,),
                          ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'jpeg'],
                              );
                              if (result != null) {
                                image = File(result.files.single.path!);
                                print(result.files.single.path);
                              } else {
                                image = null;
                                enemyPos = null;
                                robotPos = null;
                              }
                              setState(() {});
                            },
                            child: Text("Selecionar"),
                          ),
                        ]
                    )
                )
            )
        )
    ];
    if (image != null) {
      widgets.add(
        Card(
          child: SizedBox(
            width: width * 0.9,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.file(image!)
            )
          )
        )
      );
    }
    if (robotPos != null) {
      widgets.add(
          Card(
              child: SizedBox(
                  width: width * 0.9,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          "Posição robô: " + robotPos!.x.toString() + ", " +
                              robotPos!.y.toString(), textScaleFactor: 1.2)
                  )
              )
          )
      );
    }
      if (enemyPos != null) {
        widgets.add(
            Card(
                child: SizedBox(
                    width: width * 0.9,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            "Posição inimigo: " + enemyPos!.x.toString() +
                                ", " + enemyPos!.y.toString(), textScaleFactor: 1.2)
                    )
                )
            )
        );
      }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Batalha"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgets
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (robotPos != null) ? () {} : null,
          child: const Icon(Icons.arrow_right),
          backgroundColor: (robotPos != null) ? Colors.red : Colors.grey,
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}