import 'package:flutter/material.dart';
import 'package:desafio_flutter/components/pages/custom_page.dart';
import 'package:desafio_flutter/components/pages/home/home.dart';
import 'package:audio_service/audio_service.dart';
import 'package:desafio_flutter/services/audio_service.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AudioHandler>(
      future: initAudioHandler(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          AudioHandler audioHandler = snapshot.data!;
          return MaterialApp(
            title: 'Get Json App',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: CustomPage(
              title: 'Home', 
              customPage: HomePage(
                extra: {"audio_handler": audioHandler}
              )
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      }
    );
  }
}