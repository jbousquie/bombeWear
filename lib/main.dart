import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: WatchShape(
                builder: (BuildContext context, WearShape shape, Widget? child) {
                  return Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Shape: ${shape == WearShape.round ? 'round' : 'square'}',
                      ),
                      child!
                    ],
                  );
              },
                child:  AmbientMode(
                  builder: (BuildContext context, WearMode mode, Widget? child) {
                    return Text(
                      'Mode: ${mode == WearMode.active ? 'Active' : 'Ambient'}',
                    );
                  }
                ),
            )
        )
      )
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
  final myController = TextEditingController();
  Future<String>? _futurePointage;
  String _urlText = '';
  bool _answered = true;

  @override
  void initState() {
    super.initState();
    _getURL();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: buildContent()),
      floatingActionButton: buildButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  FloatingActionButton buildButton() {
    return FloatingActionButton.large(
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
      _getURL();
      myController.text = _urlText;
      return TextField(
        controller: myController,
        keyboardType: TextInputType.url,
        autofocus: true,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            isDense: true,
            labelText: "URL Filou",
            hintText: "Coller ici l'URL générée dans Filou"),
        onSubmitted: (text) {
          updateURL(text);
        },
      );
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
                style: const TextStyle(fontSize: 24));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}',
                style: const TextStyle(fontSize: 24));
          }
          return const CircularProgressIndicator();
        });
  }

  Future<void> updateURL(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('urltext', text);
    setState(() {
      _urlText = text;
    });
  }

  Future<void> _getURL() async {
    final prefs = await SharedPreferences.getInstance();
    _urlText = prefs.getString('urltext') ?? '';
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
