import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:desafio_flutter/services/services.dart';
import 'package:desafio_flutter/classes/initial_value.dart';

class ViewerPdfs extends StatefulWidget {
  final String url;
  final InitialValue initialValue;
  final List<dynamic> arrayMaster;
  final Map<String, dynamic> element;
  final String storageKey;

  const ViewerPdfs({Key? key,
    required this.url,
    required this.initialValue,
    required this.arrayMaster,
    required this.element,
    required this.storageKey,
  }) : super(key: key);

  @override
  _PDFPage createState() => _PDFPage();
}

class _PDFPage extends State<ViewerPdfs> {
  late PdfController pdfController;
  late Future<String> filePath;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    filePath = findFilePath(widget.url);
    lastPage = widget.initialValue.value ?? 1;
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: filePath,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              String path = snapshot.data!;
              pdfController = PdfController(
                document: PdfDocument.openFile(path),
                initialPage: lastPage > 1 ? lastPage : 0,
              );
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Arquivo PDF'),
                ),
                body: PdfView(
                  controller: pdfController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (page) {
                    lastPage = page;
                    widget.initialValue.updateValue(
                      page,
                      widget.storageKey,
                      widget.arrayMaster,
                      widget.element,
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                value: 1.5,
              ),
            );
          }
        )
      )
    );
  }
}