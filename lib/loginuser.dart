import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:test8/home.dart';
import 'package:test8/signupuser.dart';
import 'package:test8/forgot_password.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/homepage': (context) => home(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
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
                context, MaterialPageRoute(builder: (context) => signupuser()));
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
              children: [
                SizedBox(height: 60),
                Text(
                  'Log In as User',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.black), // Email icon
                  ),
                  style: TextStyle(color: Colors.black),
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
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.black), // Password icon
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 6, 8, 134),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotpassword');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
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
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You are successfully logged in"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, "/homepage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Some error occurred"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc['role'];
    }
    return null;
  }

  void handleLogin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? role = await getUserRole(user.uid);
      if (role == 'user') {
        // Navigate to User Home Page
      } else if (role == 'service_provider') {
        // Navigate to Service Provider Home Page
      }
    }
  }
}

