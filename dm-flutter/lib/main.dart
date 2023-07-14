import 'package:flutter/material.dart';
import 'package:dmproject/screens//login.dart';
import 'package:dmproject/screens/user.dart';
import 'package:dmproject/screens/card.dart';
import 'package:dmproject/screens/analysis.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/user': (context) => UserScreen(),
        '/card': (context) => ScreenCard(),
        '/analysis': (context) => AnaliseScreen(),
      },
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/user');
            },
          ),
          IconButton(
            icon: Icon(Icons.credit_card),
            onPressed: () {
              Navigator.pushNamed(context, '/card');
            },
          ),
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, '/analysis');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}