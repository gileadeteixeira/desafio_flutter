class Content {
  List<dynamic> list;
  final String extension;

  Content({
    required this.extension,
    required this.list,
  });

  void addContent(Map<String, dynamic> content){
    list.add(content);
  }

  String getExtension(){
    return extension;
  }

  List<dynamic> getContent(){
    return list;
  }
}

class Videos extends Content{
  Videos(List<dynamic> list) : super(extension: ".m3u8", list: list);
}
class Audios extends Content{
  Audios(List<dynamic> list) : super(extension: ".mp3", list: list);
}
class Pdfs extends Content{
  Pdfs(List<dynamic> list) : super(extension: ".pdf", list: list);
}