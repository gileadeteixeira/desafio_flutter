class Videos {
  final List<String> urls = [];
  String extension = ".m3u8";

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