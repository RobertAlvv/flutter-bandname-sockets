import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Cowboys', votes: 1),
    Band(id: '3', name: 'Good Mean', votes: 2),
    Band(id: '4', name: 'Day', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Band Names",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTitle(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: _addBand,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band) => Dismissible(
        direction: DismissDirection.startToEnd,
        key: Key(band.id),
        onDismissed: (_) {
          print(band.id);
        },
        background: Container(
          padding: EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("Deleted Band", style: TextStyle(color: Colors.white)),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(band.name.substring(0, 2)),
          ),
          title: Text(band.name),
          trailing: Text(
            "${band.votes}",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );

  _addBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Add New Band"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                    elevation: 5,
                    child: Text("Add"),
                    onPressed: () {
                      _addBandToList(textController.text);
                    })
              ],
            );
          });
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("Add New Band"),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Add"),
                  onPressed: () => _addBandToList(textController.text)),
              CupertinoDialogAction(
                  isDestructiveAction: false,
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context)),
            ],
          );
        });
  }

  _addBandToList(String band) {
    if (band.length > 0) {
      this.bands.add(
            Band(id: DateTime.now().toString(), name: band, votes: 0),
          );
      setState(() {});
      Navigator.pop(context);
    }
  }
}
