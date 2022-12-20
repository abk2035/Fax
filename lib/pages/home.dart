import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/components/custome_card.dart';
import 'package:fax/pages/add_member_in_group.dart';
import 'package:fax/pages/chat.dart';
import 'package:fax/pages/groups.dart';
import 'package:fax/pages/profil.dart';
import 'package:fax/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String userName = "";
  String email = "";
  bool _isLoading = false;
  String groupName = "";

  late TabController _controller;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  void getCurrentUser() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        userName = map['name'];
        email = map['email'];
      });
    });
  }
  

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 3,
      vsync: this,
    );

    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAX"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              text: "Disc",
            ),
            Tab(
              text: "Groupes",
            ),
            Tab(
              text: "Status",
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateGroupPage()));
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "nouveau groupe",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(email: email, userName: userName)));
              },
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "Profil",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                            onPressed: () {
                              AuthService().logOut(context);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          )
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          ChatPage(),
          GroupPage(),
          Text("status"),
        ],
      ),
    );
  }
}
