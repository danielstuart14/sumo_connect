import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sumo_connect/robot.dart';

import 'package:dio/dio.dart';

import 'bluetooth.dart';
import 'commands.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({Key? key}) : super(key: key);

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  Uint8List? image;
  Position? robotPos;
  Position? enemyPos;
  bool loading = false;

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
                          const Text("Imagem Dojô", textScaleFactor: 1.2,),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {loading = true;});
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'jpeg'],
                              );
                              if (result != null) {
                                print(result.files.single.path);
                                FormData formData = FormData();
                                formData.files.addAll([
                                  MapEntry('file',
                                    await MultipartFile.fromFile(result.files.single.path!, filename: result.files.single.name),
                                  ),
                                ]);

                                try {
                                  final response = await Dio().post(
                                      "http://168.138.124.65/upload_picture",
                                      data: formData,  options: Options(responseType: ResponseType.bytes));
                                  image = response.data;
                                  final tPos = response.headers["team_pos"]![0].split(",");
                                  final ePos = response.headers["enemy_pos"]![0].split(",");

                                  robotPos = Position(double.parse(tPos[0].substring(1)), double.parse(tPos[1].substring(0, tPos[1].length - 1)));
                                  enemyPos = Position(double.parse(ePos[0].substring(1)), double.parse(ePos[1].substring(0, ePos[1].length - 1)));
                                } catch (e) {
                                  image = null;
                                  enemyPos = null;
                                  robotPos = null;
                                  print(e);
                                  _showDialog("Batalha", "Erro durante processamento da imagem!");
                                }
                              } else {
                                image = null;
                                enemyPos = null;
                                robotPos = null;
                              }
                              setState(() {loading = false;});
                            },
                            child: const Text("Selecionar"),
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
                child: Image.memory(image!)
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
          child: (loading) ? const CircularProgressIndicator() : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgets
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (bleHandler.connectedTo != null && robotPos != null) ? () {
            bleHandler.connectedTo!.robotPos = robotPos;
            bleHandler.connectedTo!.enemyPos = enemyPos;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CommandsPage()),
            ).then((_) {
              setState(() {});
            });
          } : null,
          child: const Icon(Icons.arrow_right),
          backgroundColor: (robotPos != null) ? Colors.red : Colors.grey,
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}