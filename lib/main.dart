import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://docs.flutter.dev/get-started/codelab

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pointeuse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pointeuse UT1'),
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
  Future<String>? _futurePointage;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SizedBox(child: buildColumn()));
  }

  Column buildColumn() {
    List<Widget> children;
    if (_futurePointage == null) {
      children = [buildButton()];
    } else {
      children = [buildFutureBuilder(), buildButton()];
    }
    return Column(children: children);
  }

  FloatingActionButton buildButton() {
    return FloatingActionButton.large(
        backgroundColor: Colors.green,
        child: const Icon(Icons.punch_clock_outlined),
        onPressed: () {
          setState(() {
            _futurePointage = pointe();
          });
        });
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

  Future<String> pointe() async {
    final uri = Uri.parse(
        'https://filou.iut-rodez.fr/pointe/jbousqui/1703/wp5rwp7Cp8KewpvCp8Kt');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('échec accès http à Filou');
    }
  }
}
