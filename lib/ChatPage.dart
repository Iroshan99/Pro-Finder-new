import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String selectedRecipientId = '';
  String selectedRecipientName = '';
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    try {
      // Load users from users collection
      QuerySnapshot userSnapshots = await FirebaseFirestore.instance.collection('users').get();
      for (var doc in userSnapshots.docs) {
        users.add({
          'name': doc['name'],
          'id': doc.id,
          'photoURL': doc['photoURL'],
        });
      }
      // Load service providers from service_providers collection
      QuerySnapshot serviceProviderSnapshots = await FirebaseFirestore.instance.collection('service_providers').get();
      for (var doc in serviceProviderSnapshots.docs) {
        users.add({
          'name': doc['name'],
          'id': doc.id,
          'photoURL': doc['photoURL'],
        });
      }
      setState(() {});
    } catch (e) {
      print("Failed to load users: $e");
    }
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty && selectedRecipientId.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'senderId': currentUser?.uid,
        'receiverId': selectedRecipientId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  void _onChatHeadTap(String recipientId, String recipientName) {
    setState(() {
      selectedRecipientId = recipientId;
      selectedRecipientName = recipientName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: users.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ChatHead(
                        name: users[index]['name'],
                        photoURL: users[index]['photoURL'],
                        onTap: () => _onChatHeadTap(users[index]['id'], users[index]['name']),
                      );
                    },
                  ),
          ),
          Expanded(
            child: selectedRecipientId.isEmpty
                ? Center(child: Text('Select a recipient to start chatting'))
                : MessagesList(currentUser!.uid, selectedRecipientId, selectedRecipientName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatHead extends StatelessWidget { 
  final String name;
  final String? photoURL;
  final VoidCallback onTap;

  ChatHead({required this.name, required this.photoURL, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: photoURL != null
                  ? NetworkImage(photoURL!)
                  : AssetImage('assets/default_profile.JPG') as ImageProvider,
            ),
            SizedBox(height: 5),
            Text(name, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  final String currentUserId;
  final String recipientId;
  final String recipientName;

  MessagesList(this.currentUserId, this.recipientId, this.recipientName);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('senderId', whereIn: [currentUserId, recipientId])
          .where('receiverId', whereIn: [currentUserId, recipientId])
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var messages = snapshot.data!.docs;

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            bool isSentByCurrentUser = message['senderId'] == currentUserId;
            return ListTile(
              title: Align(
                alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: isSentByCurrentUser ? Colors.blue[100] : Colors.grey[300],
                  child: Text(message['message']),
                ),
              ),
              subtitle: Align(
                alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(isSentByCurrentUser ? 'You' : recipientName),
              ),
            );
          },
        );
      },
    );
  }
}
