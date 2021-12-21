import 'package:flutter/material.dart';
import 'package:desafio_flutter/classes/content.dart';
import 'package:desafio_flutter/components/viewers/viewer_videos.dart';
import 'package:desafio_flutter/classes/list_item.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
class ListVideos extends StatefulWidget{
  final Videos videos;

  const ListVideos({Key? key, 
    required this.videos,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListVideos> {
  late Videos videos;

  @override
  void initState() {
    super.initState();
    videos = widget.videos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Vídeos'),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getValueAtLocalStorage("videos"),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              dynamic arrayMaster = snapshot.data!;

              return ListView.builder(
                itemCount: videos.getContent().length,
                itemBuilder: (context, int index){
                  Map<String, dynamic> element = videos.getContent().elementAt(index);
                  dynamic value = arrayMaster.firstWhere((e) =>
                    e["url"] == element["url"]
                  )["initial_value"];
                  InitialValue initialValue = InitialValue(value: value);

                  return ListItem(                   
                    listItemIcon: const Icon(
                      Icons.ondemand_video,
                      size: 30.0,
                      semanticLabel: 'Ícone Video',
                    ),
                    listItemTitle: "Vídeo ${index+1}",
                    viewer: ViewerVideos(
                      url: element["url"],
                      title: "Vídeo ${index+1}",
                      initialValue: initialValue,
                      arrayMaster: arrayMaster,
                      element: element,
                      storageKey: "videos",
                    ),
                  );
                }
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }
        )
      )
      
    );
  }
}