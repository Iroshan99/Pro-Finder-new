import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accounts.dart';
import 'package:test8/home.dart';
import 'package:test8/notification.dart';
import 'package:test8/painter.dart';
import 'package:test8/caregiver.dart';
import 'package:test8/chef.dart';
import 'package:test8/electricion.dart';
import 'package:test8/plumber.dart';
import 'package:test8/requests.dart';
import 'package:test8/tutor.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProFinderPage(),
    );
  }
}

class ProFinderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                CategoryButton(
                  title: 'Plumber',
                  imagePath: 'assets/plumber.jpg', 
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => plumber()));
                  },
                ),
                CategoryButton(
                  title: 'Painter',
                  imagePath: 'assets/painter.png', 
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => painter()));
                  },
                ),
                CategoryButton(
                  title: 'Electrician',
                  imagePath: 'assets/Electrician.jpg', 
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => electricion()));
                  },
                ),
                CategoryButton(
                  title: 'Chef',
                  imagePath: 'assets/chef.png', 
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => chef()));
                  },
                ),
                CategoryButton(
                  title: 'Cleaner',
                  imagePath: 'assets/Cleaner.png', 
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => tutor()));
                  },
                ),
                CategoryButton(
                  title: 'Care Giver',
                  imagePath: 'assets/Caregiver.jpg',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => caregiver()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.request_page, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => requests()));
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => notification()));
              },
            ),
            IconButton(
              icon: Icon(Icons.category, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => accounts()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  CategoryButton({
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  




