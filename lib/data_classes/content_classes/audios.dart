class Audios {
  final List<String> urls = [];
  String extension = ".mp3";

  void addContent(String url){
    urls.add(url);
  }

  String getExtension(){
    return extension;
  }

  List<String> getContent(){
    return urls;
  }

}