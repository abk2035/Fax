import 'package:fax/pages/individual_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const IndividualPage()));
      }),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.groups,
                  color: Colors.white,
                  size: 36,
                )),
            title: const Text(
              "Fax group",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Text("11:56"),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "currentMessage",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
