import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accountprovider.dart';


class RequestHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('serviceProviderId', isEqualTo: currentUser?.uid)
            .where('status', whereIn: ['accepted', 'rejected'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return Center(
              child: Text(
                'No request history available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final Map<String, dynamic>? requestData = request.data() as Map<String, dynamic>?;

              final userName = requestData?['userName'] ?? 'Unknown User';
              final userLocation = requestData?['userLocation'] ?? 'No location provided';
              final status = requestData?['status'] ?? 'Unknown';
              final scheduledDate = requestData?['scheduledDate'] ?? '';
              final scheduledTime = requestData?['scheduledTime'] ?? '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: ListTile(
                  title: Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: $userLocation'),
                      Text('Status: ${status[0].toUpperCase()}${status.substring(1)}'),
                      if (status == 'accepted' && scheduledDate.isNotEmpty && scheduledTime.isNotEmpty)
                        Text('Scheduled: $scheduledDate at $scheduledTime'),
                    ],
                  ),
                  trailing: Icon(
                    status == 'accepted' ? Icons.check_circle : Icons.cancel,
                    color: status == 'accepted' ? Colors.green : Colors.red,
                  ),
                ),
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
              icon: Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RequestHistoryPage()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => accountprovider()));
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
