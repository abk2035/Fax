import 'package:flutter/material.dart';

class ReplyGroupMessageCard extends StatelessWidget {
  const ReplyGroupMessageCard(
      {Key? key, required this.message, required this.time, required this.name})
      : super(key: key);
  final String message;
  final String time;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children: [
              Positioned(left: 0, bottom: 0, child: Text(name)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 30,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
