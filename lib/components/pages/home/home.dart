import 'package:flutter/material.dart';
import 'package:desafio_flutter/classes/data.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/components/pages/home/home_components.dart';
import 'package:desafio_flutter/components/lists/list_videos.dart';
import 'package:desafio_flutter/components/lists/list_audios.dart';
import 'package:desafio_flutter/components/lists/list_pdfs.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> extra;

  const HomePage({Key? key,
    required this.extra,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Data>(
        future: fetchData(),
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
                      builder: (_) => ListAudios(
                        audios: data.audiosUrls,
                        audioHandler: extra["audio_handler"]
                      ),
                    )
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}