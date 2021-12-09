import 'package:flutter/material.dart';
import 'package:desafio_flutter/data_classes/content_classes/videos.dart';

class ListVideos extends StatelessWidget{
  final Videos videos;

  const ListVideos({Key? key, 
    required this.videos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.getContent().length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 75,
          color: Colors.white,
          child: Center(child: Text(videos.getContent().elementAt(index)),
        ),);
      }
    );
  }
}