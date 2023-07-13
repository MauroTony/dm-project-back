import 'package:flutter/material.dart';
import 'package:dmproject/domain/services/user.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rendaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _rendaController,
                decoration: InputDecoration(labelText: 'Income'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _register(context);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _register(BuildContext context) async {
    // Convert the income to a double
    double renda = double.parse(_rendaController.text);
    // Perform API request using the data from the text fields
    bool result = await ApiService.register(
      _nameController.text,
      _loginController.text,
      _passwordController.text,
      _rendaController.text,
    );
    // Show a success message or handle errors accordingly
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(result ? 'Registration Successful' : 'Registration Failed'),
          content: Text(result
              ? 'Congratulations! You have been successfully registered.'
              : 'Oops! Something went wrong. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (result) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}