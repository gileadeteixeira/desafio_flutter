import 'package:desafio_flutter/components/viewers/viewer_audio.dart';
import 'package:flutter/material.dart';
import 'package:desafio_flutter/classes/content.dart';
import 'package:desafio_flutter/classes/list_item.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
import 'package:audio_service/audio_service.dart';
class ListAudios extends StatefulWidget{
  final Audios audios;
  final AudioHandler audioHandler;

  const ListAudios({Key? key, 
    required this.audios,
    required this.audioHandler,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListAudios> {
  late Audios audios;

  @override
  void initState() {
    super.initState();
    audios = widget.audios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Audios'),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getValueAtLocalStorage("audios"),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              dynamic arrayMaster = snapshot.data!;

              return ListView.builder(
                itemCount: audios.getContent().length,
                itemBuilder: (context, int index){
                  Map<String, dynamic> element = audios.getContent().elementAt(index);
                  dynamic value = arrayMaster.firstWhere((e) => 
                    e["url"] == element["url"]
                  )["initial_value"];
                  InitialValue initialValue = InitialValue(value: value);

                  return ListItem(
                    listItemIcon: const Icon(
                      Icons.audiotrack,
                      size: 30.0,
                      semanticLabel: 'Ícone Audio',
                    ),
                    listItemTitle: "Audio ${index+1}",
                    viewer: ViewerAudios(
                      url: element["url"],
                      title: "Audio ${index+1}",
                      initialValue: initialValue,                      
                      arrayMaster: arrayMaster,
                      element: element,
                      storageKey: "audios",
                      audioHandler: widget.audioHandler,
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