import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Pointeuse UT1')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _k = '/1703/';
  final myController = TextEditingController();
  Future<String>? _futurePointage;
  final String _usr = 'jbousqui';
  late String _urlText;
  final String _host = 'https://filou.iut-rodez.fr/pointe/';
  bool _answered = true;

  @override
  void initState() {
    super.initState();
    const String cd = 'wp5rwp7Cp8KewpvCp8Kt';
    _urlText = '$_host$_usr$_k$cd';
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return
      Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: WatchShape(
                builder: (BuildContext context, WearShape shape, Widget? child) {
                  return buildContent();
                }),
              ),
        floatingActionButton: buildButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

  FloatingActionButton buildButton() {
    return FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.punch_clock_outlined),
        onPressed: () {
          setState(() {
            _answered = false;
            _futurePointage = pointe();
          });
        });
  }

  Widget buildContent() {
    if (_futurePointage == null) {
      return const Text('Badger',
          style: TextStyle(fontSize: 24));
    } else {
      return buildFutureBuilder();
    }
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder<String>(
        future: _futurePointage,
        builder: (context, snapshot) {
          if (snapshot.hasData && _answered) {
            return Text('${snapshot.data}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18));
          }
          return const CircularProgressIndicator();
        });
  }


  Future<String> pointe() async {
    final uri = Uri.parse(_urlText);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      _answered = true;
      return response.body;
    } else {
      throw Exception('échec accès http à Filou');
    }
  }
}
