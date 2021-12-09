class Pdfs {
  final List<String> urls = [];
  String extension = ".pdf";

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