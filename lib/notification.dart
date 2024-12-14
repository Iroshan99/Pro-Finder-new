import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accounts.dart';
import 'package:test8/category.dart';
import 'package:test8/requests.dart';

class notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final messageText = message['message'];
              final timestamp = message['timestamp']?.toDate()?.toString() ?? 'Unknown time';

              return ListTile(
                title: Text(messageText),
                subtitle: Text(timestamp),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.request_page, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => requests()));
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => notification()));
              },
            ),
            IconButton(
              icon: Icon(Icons.category, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => accounts()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
