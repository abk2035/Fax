import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/components/custome_card.dart';
import 'package:fax/pages/select_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List chats = [];
  List<Map<String, dynamic>> contacts = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get users collection
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> contacts = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    Map<String, dynamic> user;

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((element) {
      user = element as Map<String, dynamic>;
      print(user['name']);
      contacts.add(user);
    });
    return contacts;
  }

  Future getavalaibleChats() async {
    await _firestore
        .collection("chatroom")
        .where("uid", isLessThanOrEqualTo: _auth.currentUser!.displayName)
        .get()
        .then((value) {
      setState(() {
        chats = value.docs.map((doc) => doc.data()).toList();
      });
      print(chats);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers().then((value) {
      setState(() {
        contacts = value
            .where((element) => element['uid'] != _auth.currentUser!.uid)
            .toList();
      });
    });

    getavalaibleChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => const SelectContactPage()));
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          bool iscurrent = false;
          chats.forEach((chat) {
            // if (chat["uid"].contains(contacts[index]['name'])) {
            //   iscurrent = true;
            // }
          });
          if (iscurrent) {
            return InkWell(
              onTap: () {},
              child: CustomCard(
                title: contacts[index]['name'],
                isGroup: false,
              ),
            );
          }
        },
      ),
    );
  }
}
