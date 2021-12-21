import 'package:flutter/material.dart';
import 'package:desafio_flutter/classes/content.dart';
import 'package:desafio_flutter/components/viewers/viewer_pdfs.dart';
import 'package:desafio_flutter/classes/list_item.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
class ListPdfs extends StatefulWidget{
  final Pdfs pdfs;

  const ListPdfs({Key? key, 
    required this.pdfs,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListPdfs> {
  late Pdfs pdfs;

  @override
  void initState() {
    super.initState();
    pdfs = widget.pdfs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de PDFs'),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getValueAtLocalStorage("pdfs"),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              dynamic arrayMaster = snapshot.data!;

              return ListView.builder(
                itemCount: pdfs.getContent().length,
                itemBuilder: (context, int index){
                  Map<String, dynamic> element = pdfs.getContent().elementAt(index);
                  dynamic matchElement = arrayMaster.firstWhere((e) => 
                    e["url"] == element["url"]
                  );
                  dynamic value = matchElement["initial_value"] == "" ? 1 : matchElement["initial_value"];
                  InitialValue initialValue = InitialValue(value: value);

                  return ListItem(
                    listItemIcon: const Icon(
                      Icons.menu_book,
                      size: 30.0,
                      semanticLabel: 'Ícone PDF',
                    ),
                    listItemTitle: generateItemTitle(
                      element["url"],
                      "PDF",
                      index,
                    ),                                        
                    viewer: ViewerPdfs(
                      url: element["url"],
                      initialValue: initialValue,
                      arrayMaster: arrayMaster,
                      element: element,
                      storageKey: "pdfs",
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