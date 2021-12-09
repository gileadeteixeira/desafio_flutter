import 'package:flutter/material.dart';
import 'package:desafio_flutter/data_classes/content_classes/audios.dart';

class ListAudios extends StatelessWidget{
  final Audios audios;

  const ListAudios({Key? key, 
    required this.audios,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audios.getContent().length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 75,
          color: Colors.white,
          child: Center(child: Text(audios.getContent().elementAt(index)),
        ),);
      }
    );
  }
}