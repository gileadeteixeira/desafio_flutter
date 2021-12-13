import 'dart:async';
import 'dart:convert';
import 'package:desafio_flutter/classes/data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:localstorage/localstorage.dart';

Future<Data> fetchData() async {
  final file = await DefaultCacheManager().getSingleFile(
    "https://raw.githubusercontent.com/App2Sales/mobile-challenge/master/content.json",
    headers: {'cache-control': 'private, max-age=120'}
  );
  Map jsonResponse = json.decode(await file.readAsString());
  Data data = await fromJson(jsonResponse);
  return data;
}

Future<String> findFilePath(String url) async {
  final file = await DefaultCacheManager().getSingleFile(
    url,
    headers: {
      "Access-Control-Allow-Origin" : "*",
      "Access-Control-Allow-Headers" : "Content-Type",
    } 
  );
  return file.path;
}
String generateItemTitle(String fileUrl, String genericTitle, int index){
  RegExp regExp = RegExp(
    r"^(.*[\\\/])?(.*?)(\.[^.]*?|)$",
    caseSensitive: false,
    multiLine: false,
  );
  RegExpMatch? match = regExp.firstMatch(fileUrl);
  String? title;
  if(match != null){
    title = match.group(2);
    String firstLetter = title!.substring(0, 1);
    title = title.replaceAll("-", " ").replaceFirst(RegExp(r"[a-z]"), firstLetter.toUpperCase());
  } else {
    title = "$genericTitle ${index++}";
  }
  return title;
}

void updateLocalStorage(String arrayKey, dynamic value){
  LocalStorage(arrayKey).setItem(arrayKey, json.encode(value));
}

Future<dynamic> getValueAtLocalStorage(String arrayKey) async {
  LocalStorage storage = LocalStorage(arrayKey);
  await storage.ready;
  dynamic item = storage.getItem(arrayKey);
  dynamic value = json.decode(item);
  return value;
}

CacheManager createCache(String databaseName){
  String key = databaseName;
  CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 366),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
  return instance;
}

typedef SetParentStateCallback = void Function(dynamic value);