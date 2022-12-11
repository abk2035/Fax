import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/pages/create_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Models/chat_model.dart';
import '../components/avatar_card.dart';
import '../components/contact_card.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CreateGroupPage> {
  List<Map<String, dynamic>> contacts = [];
  List<Map<String, dynamic>> memberlist = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // get users
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

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        memberlist.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onRemoveMembers(int index) {
    if (memberlist[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        memberlist.removeAt(index);
      });
    }
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

    getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Add participants",
              style: TextStyle(
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
              onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: contacts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    color: Colors.white,
                    height: memberlist.isNotEmpty ? 90 : 10,
                  );
                }
                return InkWell(
                  onTap: () {
                    bool isAlreadyExist = false;
                    for (int i = 0; i < memberlist.length; i++) {
                      if (memberlist[i]['uid'] == contacts[index - 1]['uid']) {
                        isAlreadyExist = true;
                      }
                    }

                    if (!isAlreadyExist) {
                      setState(() {
                        memberlist.add({
                          "name": contacts[index - 1]['name'],
                          "email": contacts[index - 1]['email'],
                          "uid": contacts[index - 1]['uid'],
                          "isAdmin": false,
                        });
                      });
                    }
                  },
                  child: ContactCard(
                    contact: contacts[index - 1]['name'],
                  ),
                );
              }),
          memberlist.isNotEmpty
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                          height: 70,
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: memberlist.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => onRemoveMembers(index),
                                child: AvatarCard(
                                  name: memberlist[index]['name'],
                                ),
                              );
                            },
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: memberlist.length >= 2
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => CreateGroup(
                              membersList: memberlist,
                            )));
              },
              tooltip: 'Add Members',
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            )
          : Container(),
    );
  }
}
