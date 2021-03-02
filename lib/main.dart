import 'package:HelpNow/model/providerList.dart';
import 'package:HelpNow/screens/addDetailsScreen.dart';
import 'package:HelpNow/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: elementList(), child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpNow',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home:
      routes: {
        AddDetailsScreen.routeName: (ctx) => AddDetailsScreen(),
        '/': (ctx) => SplashScreen(
            seconds: 3,
            navigateAfterSeconds: HomeScreen(),
            loadingText: Text('Welcome to our app'),
            image: new Image.asset('assets/logo.png'),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.red),
      },
    ),);
  }
}
