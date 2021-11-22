import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/utilities/textfield.dart';
import 'media/message/message_bubble.dart';

class ChatView extends StatefulWidget {
  final String? receiverPhotoUrl;
  final String? receiverUserName;
  final String? receiverUid;
  final String? conversationId;
  final Color? randomColor;
  const ChatView({
    Key? key,
    this.receiverPhotoUrl,
    this.receiverUserName,
    this.receiverUid,
    this.conversationId,
    this.randomColor,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageTech = TextEditingController();
  ScrollController scrollController = ScrollController();
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection('Conversation');
  final focusNode = FocusNode();

  Widget buildChatView() {
    return StreamBuilder<QuerySnapshot>(
      stream: conversationCollection
          .doc(widget.conversationId)
          .collection('Chat')
          .orderBy(
            'timestamp',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            title: Text(
              'Something Bad Happened',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Please try again later.',
              textAlign: TextAlign.center,
            ),
            actions: [
              CupertinoButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }

        final messages = snapshot.data!.docs;

        return messages.isNotEmpty
            ? CupertinoScrollbar(
                child: ListView.builder(
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      context: context,
                      messageData: Message.fromFirestore(
                        snapshot.data!.docs[index],
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Container(
                  child: Text(
                    'Nothing Is Here',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    focusNode.unfocus();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MediaQuery.of(context).viewInsets.bottom == 0
            ? focusNode.unfocus()
            : Text('');
      },
      dragStartBehavior: DragStartBehavior.start,
      onVerticalDragStart: (drag) {
        MediaQuery.of(context).viewInsets.bottom == 0
            ? focusNode.unfocus()
            : Text('');
      },
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(28, 28, 30, 1),
        // backgroundColor: Color(0xFF121212),
        backgroundColor: CupertinoColors.white,
        appBar: AppBar(
          elevation: 0.0,
          //I could also use Cupertino Back Button
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    widget.receiverPhotoUrl ?? 'images/img2.jpg'),
              ),
              SizedBox(height: 5),
              Text(
                widget.receiverUserName ?? 'Samantha',
                style: GoogleFonts.openSans(
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                    color: Colors.black,),
              ),
            ],
          ),
          toolbarHeight: 70.0,
          centerTitle: true,
          backgroundColor: widget.randomColor!.withAlpha(30),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color.alphaBlend(
              widget.randomColor!.withAlpha(20),
              Colors.white,
            ),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(child: buildChatView()),
              HintTextField(
                focusNode: focusNode,
                receiverUid: widget.receiverUid,
                randomColor: widget.randomColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
