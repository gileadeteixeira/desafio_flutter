import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  final String title;
  final Widget customPage;

  const CustomPage({Key? key,
    required this.title,
    required this.customPage
  }) : super(key: key);

  @override
  State<CustomPage> createState() => _PageState();
}

class _PageState extends State<CustomPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.customPage
    );
  }
}