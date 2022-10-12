import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://docs.flutter.dev/get-started/codelab

void main() {
  runApp(const MyApp());
}

Future<String> pointe() async {
  final uri = Uri.parse('https://filou.iut-rodez.fr/');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('échec accès http à Filou');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pointeuse',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pointeuse UT1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String>? _futurePointage;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(width: 400, height: 200, child: buildButton()));
  }

  Column buildButton() {
    return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder()),
              onPressed: () {
                setState(() {
                  _futurePointage = pointe();
                });
              },
              child: const Text("POINTE !",
                  style: TextStyle(color: Colors.white))),
          buildFutureBuilder()
        ]);
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder<String>(
        future: _futurePointage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('${snapshot.data}');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
