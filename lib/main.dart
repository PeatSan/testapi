import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://api.fastforex.io/fetch-all?api_key=1108454ad3-753d3cf144-rjq8r1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body.toString());
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
    final dynamic results;
    final String updated;
  // final int userId;
  // // final int id;
  // // final String title;

  const Album({
      required this.updated,
    required this.results
    // required this.id,
    // required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        updated:  json['updated'],
      results: json['results'],
      // id: json['id'],
      // title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<dynamic> futureAlbum;



  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<dynamic>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("before data come");
                print(snapshot.data["results"]);
                dynamic priceData = snapshot.data["results"];
                // String base = snapshot.data["base"];
                // String updated = snapshot.data["updated"];
                // print(priceData["THB"].toString());
                return Text(priceData["THB"].toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}