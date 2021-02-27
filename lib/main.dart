import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/page/home.dart';
import 'package:band_names/page/status.dart';
import 'package:band_names/services/socket_services.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider (create: (_) => SocketServices())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'status',
        routes: {
          'home' : ( _ ) => HomePage(),
          'status' : ( _ ) => StatusPage()
        },
      ),
    );
  }
}