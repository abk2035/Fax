import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/components/button_card.dart';
import 'package:fax/pages/add_member_in_group.dart';
import 'package:fax/pages/individual_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/contact_card.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({Key? key}) : super(key: key);

  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  List<Map<String, dynamic>> contacts = [];
  Map<String, dynamic>? userMap;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

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

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers().then((value) => {
          setState(() {
            contacts = value
                .where((element) => element['uid'] != _auth.currentUser!.uid)
                .toList();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Contacts",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${contacts.length} contacts",
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.search,
                size: 26,
              ),
              onPressed: () {})
        ],
      ),
      body: ListView.builder(
          itemCount: contacts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const CreateGroupPage()),
                    );
                  },
                  child:
                      const ButtonCard(name: "New Group", icon: Icons.group));
            } else if (index == 1) {
              return const ButtonCard(
                  name: "New contact", icon: Icons.person_add);
            }
            return InkWell(
              onTap: () {
                setState(() {
                  userMap = contacts[index - 2];
                });
                String roomId = chatRoomId(
                    _auth.currentUser!.displayName!, userMap!['name']);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IndividualPage(
                      chatRoomId: roomId,
                      userMap: userMap!,
                    ),
                  ),
                );
              },
              child: ContactCard(
                contact: contacts[index - 2]['name'],
              ),
            );
          }),
    );
  }
}
