import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Connecting, Offline, Online }

class SocketServices with ChangeNotifier {
  ServerStatus _statusService = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get statusService => _statusService;

  Function get emit => _socket.emit;

  IO.Socket get socket => _socket;

  SocketServices() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io(
        'http://10.0.0.235:3001',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    this._socket.onConnect((data) {
      _statusService = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      _statusService = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload){
    //   print(payload.containsKey('mensaje') ? payload['mensaje'] : '');
    // });
  }
}
