import 'dart:async';
import 'package:flutter/material.dart';
import 'package:desafio_flutter/classes/data.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/components/lists/list_videos.dart';
import 'package:desafio_flutter/components/lists/list_audios.dart';
import 'package:desafio_flutter/components/lists/list_pdfs.dart';

class HomeButton extends StatelessWidget{
  final String text;
  final void Function() onPressed;

  const HomeButton({Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 25.0, color: Colors.black)
        ),
      ),
    );
  }
}
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Json App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Home'),
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
    futureData = fetchData();
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HomeButton(
                    text: "Abrir Lista de Vídeos",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => ListVideos(videos: data.videosUrls),
                      )
                    ),
                  ),
                  HomeButton(
                    text: "Abrir Lista de PDFs",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => ListPdfs(pdfs: data.pdfsUrls),
                      )
                    ),
                  ),
                  HomeButton(
                    text: "Abrir Lista de Audios",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => ListAudios(audios: data.audiosUrls),
                      )
                    ),
                  )
                ],
              );
              // return ListVideos(videos: data.videosUrls);
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
