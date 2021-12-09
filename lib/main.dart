import 'dart:async';
import 'package:flutter/material.dart';
import 'package:desafio_flutter/data_classes/data.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/components/list_videos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Data> futureData;
  @override
  void initState() {
    super.initState();
    futureData = Services().fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Data>(
          future: futureData,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              Data data = snapshot.data!;
              return ListVideos(videos: data.videosUrls);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      )
    );
  }
}
