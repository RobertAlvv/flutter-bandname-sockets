import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.on('active-bands', (_handActiveBands));

    super.initState();
  }

  void _handActiveBands(dynamic payload) {
    bands = (payload as List)
        .map(
          (band) => Band.fromMap(band),
        )
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Band Names",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: socketServices.statusService == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTitle(bands[i]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: _addBand,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (_) => socketServices.emit("delete-band", {'id': band.id}),
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
        onTap: () => socketServices.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  _addBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Add New Band"),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    elevation: 5,
                    child: Text("Add"),
                    onPressed: () => _addBandToList(textController.text),
                  )
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
            ));
  }

  _addBandToList(String band) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    if (band.length > 0) {
      socketServices.emit('add-band', {'name': band});
      setState(() {});
      Navigator.pop(context);
    }
  }

  Widget _showGraph() {
    Map<String, double> dataMap = Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}
