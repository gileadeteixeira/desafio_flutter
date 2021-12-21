import 'dart:convert';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/content.dart';
import 'package:localstorage/localstorage.dart';
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
      r"\.\w{3,}($|\?)", //https:\\url\arquivo.extensao -> .extensao
      caseSensitive: false,
      multiLine: false,
    );
    RegExpMatch? match = regExp.firstMatch(url);
    String? findedExtension;    
    bool result;
    dynamic listRef;
    if(match != null){
      findedExtension = match.group(0);//arquivo.pdf -> extensão encontrada = .pdf
      result = findedExtension == list["extension"] ? true : false;//a extensão encontrada é igual a da extensão padrão da lista solicitada? ex: a lista espera um .pdf, a url tem .mp3, então o resultado é falso.
      listRef = result ? list["list_ref"] : getList(null, findedExtension)["list_ref"];//se o resultado for falso, encontre a referencia para a lista verdadeira relativa à extensão encontrada
    } else {
      findedExtension = null;
      result = false;
      listRef = null;
    }
    return {
      "result": result,
      "key": key,
      "url": url,
      "required_extension": list["extension"],//ex: a lista de pdfs requer um .pdf
      "finded_extension": findedExtension,//ex: mas foi encontrado um .mp3
      "list_ref": listRef,//ex: portanto, a verdadeira lista é essa
    };//required e finded podem ser iguais, e serão iguais se nenhum erro ocorrer. essa função apenas previne possíveis erros anteriores ao tratamento (a requisição ja trouxe o dado errado, por exemplo);
  }

  Map<String, dynamic> getList(String? key, String? extension){
    //função para retornar a lista de referencia da classe (pdf, audio, etc.)
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
        {//qual a extensão dessa lista de referência?
          "list_ref": contentClasses[key],
          "extension": contentClasses[key].getExtension(),
        }
      :
        {//qual a lista de referencia dessa extensão?
          "list_ref": getListRef(extension),
          "extension": extension,
        };
  }

  void addOnArray(String key, dynamic value){
    Map<String, dynamic> verification = checkExtension(key, value, getList(key, null));
    verification["list_ref"].addContent({"url": value, "initial_value": ""});
  }

  void addByMap(Map<dynamic, dynamic> map, String key){
    for (var entry in map.entries) {
      addOnArray(key, entry.value);
    }
  }

}

Future<Data> fromJson(Map<dynamic, dynamic> remoteJson) async {
  var data = Data(
    videosUrls: Videos([]),
    audiosUrls: Audios([]),
    pdfsUrls: Pdfs([]),
  );
  remoteJson.forEach((key, value){
    if (value is String) {//se o dado vier como:  "chave":"valor" adiciona direto
      data.addOnArray(key, value);
    } else if(value is List){//se o dado vier como:  "chave":["valor"] transforma o array em map e adiciona por map
      var listMap = value.asMap();
      data.addByMap(listMap, key);
    } else if(value is Map){//se o dado vier como: "chave":{"chave":"valor"} adiciona por map
      data.addByMap(value, key);
    }
  });
  Map<String, dynamic> contentClasses = data.getAllContentClasses();
  dynamic cached;
  for (var entry in contentClasses.entries) {//salvar dados no localStorage
    String key = "${entry.key}s";//audio -> audios
    LocalStorage storage = LocalStorage(key);
    await storage.ready;
    //await storage.clear(); //consertar erro ao salvar dado errado em localStorage
    cached = storage.getItem(key);
    if(cached == null){//só adicione se o localStorage ainda não tiver nada
      await storage.setItem(key, json.encode([]));
      List<dynamic> array = contentClasses[entry.key].getContent();
      for (var element in array) {
        List<dynamic> newArray = json.decode(storage.getItem(key));
        newArray.add(element);
        await storage.setItem(key, json.encode(newArray));         
      }
    }
  }
  return Data(
    videosUrls: Videos(await getValueAtLocalStorage("videos")),//os valores foram salvos no localStorage, agora é so pegar e utilizar no app
    audiosUrls: Audios(await getValueAtLocalStorage("audios")),
    pdfsUrls: Pdfs(await getValueAtLocalStorage("pdfs")),
  );
}