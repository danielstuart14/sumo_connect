import 'package:flutter/material.dart';
import 'package:sumo_connect/robot.dart';

import 'bluetooth.dart';

class CommandsPage extends StatefulWidget {
  const CommandsPage({Key? key}) : super(key: key);

  @override
  State<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {
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
    final height = MediaQuery.of(context).size.height;

    List<Widget> widgets = [
      const SizedBox(
        height: 10
      ),
      Card(
          child: SizedBox(
              width: width * 0.9,
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Estado atual: " + bleHandler.connectedTo!.status.toString().split(".")[1], textScaleFactor: 1.5)
              )
          )
      ),
      Card(
          child: SizedBox(
              width: width * 0.9,
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Coordenadas: " + bleHandler.connectedTo!.robotPos!.x.toString() + ", " + bleHandler.connectedTo!.robotPos!.y.toString(), textScaleFactor: 1.5)
              )
          )
      ),
      SizedBox(height: height*0.1),
      SizedBox(
        width: width * 0.9,
        height: height * 0.1,
        child: ElevatedButton(
          onPressed: () {
            if (bleHandler.connectedTo!.status != RobotStatus.executing) {
              bleHandler.setStatus(RobotStatus.executing);
              setState(() {});
            } else {
              _showDialog("Comandos", "Robô já se encontra em execução!");
            }
          },
          child: const Text("Iniciar", textScaleFactor: 1.5),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: width * 0.9,
        height: height * 0.1,
        child: ElevatedButton(
          onPressed: () {
            if (bleHandler.connectedTo!.status == RobotStatus.idle) {
              bleHandler.setStatus(RobotStatus.waiting);
              setState(() {});
            } else {
              _showDialog("Comandos", "Robô não se encontra em idle!");
            }
          },
          child: const Text("Aguardar", textScaleFactor: 1.5),
        )
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: width * 0.9,
        height: height * 0.1,
        child: ElevatedButton(
          onPressed: () {
            if (bleHandler.connectedTo!.status != RobotStatus.idle) {
              bleHandler.setStatus(RobotStatus.idle);
              setState(() {});
            } else {
              _showDialog("Comandos", "Robô já se encontra em idle!");
            }
          },
          child: const Text("Parar", textScaleFactor: 1.5),
        )
      )
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text("Comandos"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgets
          ),
        ),
    );
  }
}