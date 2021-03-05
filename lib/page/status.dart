import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_services.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final serviceSocket = Provider.of<SocketServices>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('serverStatus: ${serviceSocket.statusService}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => serviceSocket.socket.emit('emitir-mensaje', {'nombre':'Flutter', 'mensaje': 'Desde Flutter'}),
        child: Icon(Icons.message),
      ),
    );
  }
}
