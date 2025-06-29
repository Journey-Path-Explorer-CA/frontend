import 'package:flutter/material.dart';
import 'package:frontend/views/AStar.dart';
import 'package:frontend/views/BellmanFord.dart';
import 'package:frontend/views/ComparisonScreen.dart';
import 'package:frontend/views/Dijkstra.dart';
import 'package:frontend/views/Home.dart';
import 'package:frontend/views/Login.dart';
import 'package:frontend/views/viewmodels/astarviewmodel.dart';
import 'package:frontend/views/viewmodels/bellmanfordviewmodel.dart';
import 'package:frontend/views/viewmodels/dijkstraviewmodel.dart';
import 'package:frontend/views/viewmodels/homeviewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => DijkstraViewModel()),
        ChangeNotifierProvider(create: (_) => AStarViewModel()),
        ChangeNotifierProvider(create: (_) => BellmanFordViewModel())
      ],
      child: MaterialApp(
        routes: {
          '/login': (context) => Login(),
          '/home': (context) => Home(),
          '/dijkstra': (context) => Dijsktra(),
          '/a-star': (context) => AStar(),
          '/bellman-ford': (context) => BellmanFord(),
          '/compare': (context) => ComparisonScreen()
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Login(),
      )
    );
  }
}
