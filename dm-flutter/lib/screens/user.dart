import 'package:flutter/material.dart';
import 'package:dmproject/domain/services/login.dart';
import 'package:dmproject/domain/services/user.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}
class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    fetchUser();
  }
  Future<void> fetchUser() async {
    try {
      final data = await ApiService.getUser();
      setState(() {
        userData = data;
      });
    } catch (e) {
      print('Error: $e');
      Navigator.pushReplacementNamed(context, '/');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ApiServiceAuth.logout().then((data) {
                Navigator.pushReplacementNamed(context, '/');
              });
            },
          ),
        ],
      ),
      body: userData != null
          ? Center(
        child: Container(
          width: 300.0,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userData!['name']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      'Username: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userData!['username']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      'Income: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userData!['renda']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}