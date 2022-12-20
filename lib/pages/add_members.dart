import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/pages/create_group.dart';
import 'package:fax/pages/group_chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/avatar_card.dart';
import '../components/contact_card.dart';

class AddMembersPage extends StatefulWidget {
  final String name, groupChatId;
  final List membersList;
  const AddMembersPage(
      {Key? key,
      required this.name,
      required this.membersList,
      required this.groupChatId})
      : super(key: key);

  @override
  State<AddMembersPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddMembersPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> contacts = [];
  List<Map<String, dynamic>> memberlist = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

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

    setState(() {
      users = contacts.toList();
    });
    widget.membersList.forEach((item) {
      users.forEach((element) {
        if (element['uid'].contains(item['uid'])) {
          contacts.remove(element);
        }
        ;
      });
    });
    print(contacts);
    return contacts;
  }

  void onRemoveMembers(int index) {
    if (memberlist[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        memberlist.removeAt(index);
      });
    }
  }

  void onAddMembers() async {
    memberlist;

    List<Map<String, dynamic>> memberlists = [];

    memberlist.forEach((item) => memberlists.add(item));
    widget.membersList.forEach((item) => memberlists.add(item));

    await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": memberlists,
    });

    for (int i = 0; i < memberlist.length; i++) {
      String? uid = memberlist[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupChatId)
          .set({
        "name": widget.name,
        "id": widget.groupChatId,
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
      body: _isLoading
          ? Container(
              height: size.height / 12,
              width: size.height / 12,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Stack(
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
                            if (memberlist[i]['uid'] ==
                                contacts[index - 1]['uid']) {
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
      floatingActionButton: memberlist.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                onAddMembers();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupChatRoom(
                            groupChatId: widget.groupChatId,
                            groupName: widget.name)),
                    (root) => false);
              },
              tooltip: 'Add Members',
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          : Container(),
    );
  }
}
