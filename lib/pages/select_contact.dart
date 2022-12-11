import 'package:fax/components/button_card.dart';
import 'package:fax/pages/add_member_in_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Models/chat_model.dart';
import '../components/contact_card.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({Key? key}) : super(key: key);

  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  List<UserModel> contacts = [
    UserModel(name: "Dev Stack", bio: "A full stack developer"),
    UserModel(name: "Balram", bio: "Flutter Developer..........."),
    UserModel(name: "Saket", bio: "Web developer..."),
    UserModel(name: "Bhanu Dev", bio: "App developer...."),
    UserModel(name: "Collins", bio: "Raect developer.."),
    UserModel(name: "Kishor", bio: "Full Stack Web"),
    UserModel(name: "Testing1", bio: "Example work"),
    UserModel(name: "Testing2", bio: "Sharing is caring"),
    UserModel(name: "Divyanshu", bio: "....."),
    UserModel(name: "Helper", bio: "Love you Mom Dad"),
    UserModel(name: "Tester", bio: "I find the bugs"),
  ];
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
              "Select Contact",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "256 contacts",
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

            // return ContactCard(
            //   contact: contacts[index - 2],
            // );
          }),
    );
  }
}
