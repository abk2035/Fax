import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fax/components/own_message_card.dart';
import 'package:fax/components/reply_message_card.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({Key? key}) : super(key: key);

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  bool sendButton = false;
  FocusNode focusNode = FocusNode();
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fax_Back.png",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            titleSpacing: 0,
            leadingWidth: 100,
            leading: InkWell(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        color: Theme.of(context).primaryColor, size: 24),
                  ),
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "chatModelname",
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "last seen today at 12:05",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call))
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Stack(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard()
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    controller: _controller,
                                    keyboardType: TextInputType.multiline,
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLines: 10,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(5),
                                      hintText: "Type a message",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          show
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!show) {
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                          } else {
                                            focusNode.requestFocus();
                                          }
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) =>
                                                      bottomSheet(),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.attach_file)),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.camera_alt),
                                          )
                                        ],
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          emojiSelect()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
        height: 278,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(
                        Icons.insert_drive_file, Colors.indigo, "Document"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(Icons.headset, Colors.orange, "Audio"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(Icons.location_pin, Colors.teal, "Location"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(Icons.person, Colors.blue, "Contact"),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return Offstage(
      offstage: !show,
      child: SizedBox(
        height: 300,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            // Do something when emoji is tapped (optional)
            _controller.text = _controller.text + emoji.emoji;
          },
          onBackspacePressed: () {
            // Do something when the user taps the backspace button (optional)
          },
          textEditingController:
              _controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
          config: Config(
            columns: 7,
            emojiSizeMax: 32 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.30
                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.ANIMALS,
            bgColor: Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ), // Needs to be const Widget
            loadingIndicator:
                const SizedBox.shrink(), // Needs to be const Widget
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
          ),
        ),
      ),
    );
  }
}
