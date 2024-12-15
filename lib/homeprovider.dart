import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/chat_screen.dart';
import 'package:test8/homeprovider.dart';
import 'package:test8/accountprovider.dart';
import 'package:test8/loginprovider.dart';
import 'package:test8/notification.dart';
import 'package:test8/RequestHistoryPage.dart'; // Import the new RequestHistoryPage

class homeprovider extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<homeprovider> {
  User? currentUser;
  String profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchProfilePic();
  }

  Future<void> fetchProfilePic() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('service_providers')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('profilePicUrl')) {
          setState(() {
            profilePicUrl = data['profilePicUrl'];
          });
          print('Profile picture URL fetched: $profilePicUrl');
        } else {
          print('Profile picture URL not found in Firestore.');
        }
      } else {
        print('User document does not exist.');
      }
    } else {
      print('No current user found.');
    }
  }

  Future<String> fetchUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('service_providers')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return userDoc['name'] ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  Future<void> sendMessage(String userId, String message) async {
    String userName = await fetchUserName(currentUser?.uid ?? 'Unknown ID');
    FirebaseFirestore.instance.collection('messages').add({
      'userId': userId,
      'userName': userName, // Store the user's name
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> scheduleService(String requestId, String userId, String userName, BuildContext context) async {
    String userName = await fetchUserName(currentUser?.uid ?? 'Unknown ID');
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Schedule Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (e.g., 2024-12-25)'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time (e.g., 10:00 AM - 12:00 PM)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String scheduledDate = dateController.text;
                String scheduledTime = timeController.text;

                FirebaseFirestore.instance.collection('requests').doc(requestId).update({
                  'status': 'accepted',
                  'scheduledDate': scheduledDate,
                  'scheduledTime': scheduledTime,
                });

                FirebaseFirestore.instance.collection('messages').add({
                  'userId': userId,
                  'userName': userName,
                  'message':
                      'Your service has been scheduled for $scheduledDate at $scheduledTime. by $userName',
                  'timestamp': FieldValue.serverTimestamp(),
                });

                setState(() {}); // Refresh UI after scheduling
                Navigator.of(context).pop();
              },
              child: Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  void updateRequestStatus(String requestId, String status, BuildContext context) {
    FirebaseFirestore.instance.collection('requests').doc(requestId).update({
      'status': status,
    });
    setState(() {}); // Refresh UI to remove the request from the page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Requests'),
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
            onTap: () => _confirmLogout(context),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: profilePicUrl.isNotEmpty
                  ? NetworkImage(profilePicUrl)
                  : AssetImage('assets/default_profile.JPG') as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Failed to load profile picture: $exception');
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('serviceProviderId', isEqualTo: currentUser?.uid)
            .where('status', isEqualTo: 'pending') // Show only pending requests
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestId = request.id;
              final userId = request['userId'];
              final userName = request['userName'];
              final Map<String, dynamic>? requestData = request.data() as Map<String, dynamic>?;
              final userLocation = requestData?['userLocation'] ?? 'Location Not Available';
              return ListTile(
                title: Text(userName),
                subtitle: Text(userLocation),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => scheduleService(requestId, userId, userName, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => updateRequestStatus(requestId, 'rejected', context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Reject'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestHistoryPage()));
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
                    MaterialPageRoute(builder: (context) => accountprovider()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginprovider()),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }
}
