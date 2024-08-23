import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:test8/homeprovider.dart';
import 'package:test8/signupprovider.dart';
import 'package:test8/forgot_password.dart';

class loginprovider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/homepage': (context) => homeprovider(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'ProFinder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => signupprovider()));
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 100),
                Text(
                  'Log In as Service Provider',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Color.fromARGB(44, 168, 170, 58),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Color.fromARGB(44, 168, 170, 58),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 200, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: () => _signIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 6, 8, 134),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotpassword');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndpassword(email, password);

    if (user != null) {
      print("Successfully logged in");
      Navigator.pushNamed(context, "/homepage");
    } else {
      print("Some error occurred");
    }
  }
}
