import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DistantView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          CustomScrollView(
            shrinkWrap: true,
            slivers: [
              CupertinoSliverNavigationBar(
                backgroundColor: CupertinoColors.extraLightBackgroundGray,
                largeTitle: Text('Messages'),
                border: Border.all(width: 0.0, color: Colors.transparent),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.black26, width: 0.5),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    child: ListTile(
                      title: Text('Messages'),
                      leading: Icon(CupertinoIcons.chat_bubble),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  Divider(height: 0.0),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Groups'),
                      leading: Icon(CupertinoIcons.person_2),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  Divider(height: 0.0),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Contacts'),
                      leading: Icon(CupertinoIcons.doc),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                  Divider(height: 0.0),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    child: ListTile(
                      title: Text('Calls'),
                      leading: Icon(CupertinoIcons.phone),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black26,
                        size: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
