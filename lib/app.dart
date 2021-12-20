import 'package:flutter/material.dart';
import 'package:desafio_flutter/components/pages/custom_page.dart';
import 'package:desafio_flutter/components/pages/home/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Json App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const CustomPage(title: 'Home', customPage: HomePage()),
    );
  }
}