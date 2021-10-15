
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class UpdateUser extends StatefulWidget {
  final FireUser fireUser;
  final String property;
  const UpdateUser({Key? key, required this.fireUser, required this.property})
      : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  bool isUpdating = false;
  FirestoreApi firestoreApi = FirestoreApi();
  TextEditingController controller = TextEditingController();

  Future<void> update() {
    setState(() {
      isUpdating = true;
    });
    return firestoreApi.updateUser(
      uid: widget.fireUser.id,
      updateProperty: controller.text,
      property: widget.property,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidthPercentage(context, percentage: 0.8);
    return Scaffold(
      backgroundColor: systemBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'update your ${widget.property}',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon:const Icon(CupertinoIcons.back, color: activeBlue),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: width, maxHeight: 40),
                child: CupertinoTextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  placeholder: 'enter your ${widget.property}',
                  style: Theme.of(context).textTheme.caption,
                  placeholderStyle: Theme.of(context).textTheme.bodyText2,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: inactiveGray),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: CupertinoButton(
              color: activeBlue,
              child: isUpdating
                  ? const CircularProgressIndicator()
                  : Text(
                      'update',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: systemBackground),
                    ),
              onPressed: () async {
                await update();
                setState(() {
                  isUpdating = false;
                });
              },
            ),
            constraints: BoxConstraints(
                maxWidth: screenWidthPercentage(context, percentage: 0.6)),
          )
        ],
      ),
    );
  }
}
