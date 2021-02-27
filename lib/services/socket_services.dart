import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Connecting, Offline, Online }

class SocketServices with ChangeNotifier {
  ServerStatus _statusService = ServerStatus.Connecting;

  get statusService => _statusService;

  SocketServices() {
    this._initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io('http://10.0.0.164:3000', IO.OptionBuilder().setTransports(['websocket']) 
      .disableAutoConnect()
      .build());
    
    socket.onConnect((data) {
      _statusService = ServerStatus.Online;
      notifyListeners();
    });
    
    socket.onDisconnect((_) {
      _statusService = ServerStatus.Offline;
      notifyListeners();
    });

    socket.on('nuevo-mensaje', (payload){
      print(payload.containsKey['mensaje'] ? payload['mensaje'] : null);
      print('entro');
    });

    socket.connect();
    print(socket.connected);
  }
}
