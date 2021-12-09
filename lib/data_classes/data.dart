import 'package:desafio_flutter/data_classes/content_classes/videos.dart';
import 'package:desafio_flutter/data_classes/content_classes/audios.dart';
import 'package:desafio_flutter/data_classes/content_classes/pdfs.dart';

class Data {
  late final Videos videosUrls;
  late final Audios audiosUrls;
  late final Pdfs pdfsUrls;

  Map<String, dynamic> getAllContentClasses(){
    return {
      "video": videosUrls,
      "audio": audiosUrls,
      "pdf": pdfsUrls,
    };
  }

  Data({
    required this.videosUrls,
    required this.audiosUrls,
    required this.pdfsUrls,
  });

  Map<String, dynamic> checkExtension(String key, String url, Map<String, dynamic> list){
    RegExp regExp = RegExp(
      r"\.\w{3,}($|\?)",
      caseSensitive: false,
      multiLine: false,
    );
    RegExpMatch? match = regExp.firstMatch(url);
    String? findedExtension;    
    bool result;
    dynamic listRef;
    if(match != null){
      findedExtension = match.group(0);
      result = findedExtension == list["extension"] ? true : false;
      listRef = result ? list["listRef"] : getList(null, findedExtension)["listRef"];
    } else {
      findedExtension = null;
      result = false;
      listRef = null;
    }
    return {
      "result": result,
      "key": key,
      "url": url,
      "requiredExtension": list["extension"],
      "findedExtension": findedExtension,
      "listRef": listRef,
    };
  }

  Map<String, dynamic> getList(String? key, String? extension){
    Map<String, dynamic> contentClasses = getAllContentClasses();
    dynamic getListRef(String extns){
      for (var entry in contentClasses.entries) {
        if (entry.value.getExtension() == extns) {
          return entry.value;
        }
      }
    }
    return extension == null
      ?
        {
          "listRef": contentClasses[key],
          "extension": contentClasses[key].getExtension(),
        }
      :
        {
          "listRef": getListRef(extension),
          "extension": extension,
        };
  }

  void addOnArray(String key, dynamic value){
    Map<String, dynamic> verification = checkExtension(key, value, getList(key, null));
    verification["listRef"].addContent(value);
  }

  void addByMap(Map<dynamic, dynamic> map, String key){
    for (var entry in map.entries) {
      addOnArray(key, entry.value);
    }
  }

  factory Data.fromJson(Map<dynamic, dynamic> json){
    var data = Data(
      videosUrls: Videos(),
      audiosUrls: Audios(),
      pdfsUrls: Pdfs(),
    );
    json.forEach((key, value){
      if (value is String) {
        data.addOnArray(key, value);
      } else if(value is List){
        var listMap = value.asMap();
        data.addByMap(listMap, key);
      } else if(value is Map){
        data.addByMap(value, key);
      }
    });
    Map<String, dynamic> contentClasses = data.getAllContentClasses();
    return Data(
      videosUrls: contentClasses["video"],
      audiosUrls: contentClasses["audio"],
      pdfsUrls: contentClasses["pdf"],
    );
  }
}