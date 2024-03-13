import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String translated = 'Translation';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.translate),
          title: const Text('Translation'),
        ),
        body: Card(
          margin: const EdgeInsets.all(12),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('English (US)'),
              const SizedBox(height: 8),
              TextField(
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter text',
                ),
                onChanged: (text) async{
                  const apikey = '';
                  const to = 'es';
                  final url = Uri.parse(
                    'https://translation.googleapis.com/language/translate/v2?q=$text&target=$to&key=$apikey',
                  );
                  final response = await http.post(url);

                  if(response.statusCode==200){
                    final body = json.decode(response.body);
                    final translations = body['data']['translations'] as List;

                    final translation = HtmlUnescape().convert(
                      translations.first['translatedText'],
                    );

                    /*final traslation = await text.translate(
                      from: 'en', //English
                      to: 'es', //spanish
                    );*/
                    setState(() {
                      translated = translation;
                    });
                  }
                },
              ),
              const Divider(height: 32),
              Text(
                translated,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
