import 'package:flutter/material.dart';
import 'package:desafio_flutter/data_classes/content_classes/pdfs.dart';

class ListPdfs extends StatelessWidget{
  final Pdfs pdfs;

  const ListPdfs({Key? key, 
    required this.pdfs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pdfs.getContent().length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 75,
          color: Colors.white,
          child: Center(child: Text(pdfs.getContent().elementAt(index)),
        ),);
      }
    );
  }
}