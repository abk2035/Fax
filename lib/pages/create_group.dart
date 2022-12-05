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
  List<ChatModel> contacts = [
    ChatModel(name: "Dev Stack", status: "A full stack developer"),
    ChatModel(name: "Balram", status: "Flutter Developer..........."),
    ChatModel(name: "Saket", status: "Web developer..."),
    ChatModel(name: "Bhanu Dev", status: "App developer...."),
    ChatModel(name: "Collins", status: "Raect developer.."),
    ChatModel(name: "Kishor", status: "Full Stack Web"),
    ChatModel(name: "Testing1", status: "Example work"),
    ChatModel(name: "Testing2", status: "Sharing is caring"),
    ChatModel(name: "Divyanshu", status: "....."),
    ChatModel(
      name: "Helper",
      status: "Love you Mom Dad",
    ),
    ChatModel(name: "Tester", status: "I find the bugs"),
    ChatModel(name: "Kishor", status: "Full Stack Web"),
    ChatModel(name: "Testing1", status: "Example work"),
    ChatModel(name: "Testing2", status: "Sharing is caring"),
  ];

  List<ChatModel> groupmember = [];

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
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    color: Colors.white,
                    height: groupmember.isNotEmpty ? 90 : 10,
                  );
                }
                return InkWell(
                  onTap: () {
                    if (contacts[index].select == false) {
                      setState(() {
                        contacts[index].select = true;
                        groupmember.add(contacts[index]);
                      });
                    } else {
                      setState(() {
                        groupmember.remove(contacts[index]);
                        contacts[index].select = false;
                      });
                    }
                  },
                  child: ContactCard(
                    contact: contacts[index],
                  ),
                );
              }),
          groupmember.isNotEmpty
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        color: Colors.white,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            if (contacts[index].select == true) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    groupmember.remove(contacts[index]);
                                    contacts[index].select = false;
                                  });
                                },
                                child: AvatarCard(
                                  chatModel: contacts[index],
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
