import 'package:flutter/material.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/initial_value.dart';

class ListItem extends StatefulWidget{
  final List<dynamic> arrayMaster;
  final Map<String, dynamic> element;  
  final InitialValue initialValue;
  final String storageKey;
  final Icon listItemIcon;
  final String listItemTitle;
  final dynamic viewer;
  

  const ListItem({Key? key, 
    required this.arrayMaster,
    required this.element,
    required this.initialValue,
    required this.storageKey,
    required this.listItemIcon,
    required this.listItemTitle,
    required this.viewer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListItem> {
  late ListItem item;

  @override
  void initState() {
    super.initState();
    item = widget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Container(
          height: 75,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                item.listItemIcon,
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Text(
                    item.listItemTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        dynamic result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => item.viewer
          )
        );
        setState(() {
          item.initialValue.setValue(result);//atualiza o valor em execução
          item.arrayMaster.firstWhere((e) => 
            e["url"] == item.element["url"]
          )["initialValue"] = item.initialValue.value;//atualiza o valor no array pai
          updateLocalStorage(item.storageKey, item.arrayMaster);//re-salva o array pai no localStorage
        });
      }
    );
  }
}