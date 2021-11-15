import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/auth_service.dart';
import 'package:hint/services/database_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'dule_viewmodel.dart';

class DuleView extends StatelessWidget {
  const DuleView({Key? key, required this.fireUser}) : super(key: key);

  static const String id = '/DuleView';

  final FireUser fireUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DuleViewModel>.reactive(
      viewModelBuilder: () => DuleViewModel(fireUser),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          flexibleSpace: InkWell(onTap: () {}),
          leadingWidth: 90,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                horizontalSpaceRegular,
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                horizontalDefaultMessageSpace,
                Expanded(
                  child: ClipOval(
                    child: Image.network(
                      fireUser.photoUrl!,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          title: Text(
            fireUser.username,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          verticalSpaceSmall,
          Expanded(
            flex: model.otherFlexFactor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: screenWidthPercentage(context, percentage: 80),
                alignment: Alignment.center,
                child: StreamBuilder<Event>(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('dules')
                      .child(fireUser.id)
                      .onValue,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'Connecting.......',
                          style: TextStyle(color: Colors.black38, fontSize: 24),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'We are having problem connecting with the user.',
                          style: TextStyle(color: Colors.black38, fontSize: 24),
                        ),
                      );
                    }
                    final dataSnapshot = snapshot.data!.snapshot;
                    final json = dataSnapshot.value.cast<String, dynamic>();
                    final DuleModel duleModel = DuleModel.fromJson(json);
                    model.updateOtherField(duleModel.msgTxt);
                    return TextFormField(
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      controller: model.otherTech,
                      onChanged: (value) {
                        model.updatTextFieldWidth();
                      },
                      cursorColor: AppColors.blue,
                      cursorHeight: 28,
                      cursorRadius: const Radius.circular(100),
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          hintText: 'Message Received',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 24),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    );
                  },
                ),
                decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(32)),
              ),
            ),
          ),
          verticalSpaceRegular,
          Expanded(
            flex: model.duleFlexFactor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                padding: const EdgeInsets.all(0),
                duration: const Duration(milliseconds: 200),
                width: screenWidthPercentage(context, percentage: 80),
                alignment: Alignment.center,
                child: TextFormField(
                  focusNode: model.duleFocusNode,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  onChanged: (value) {
                    model.updateWordLengthLeft(value);
                    model.updatTextFieldWidth();
                    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, value);
                  },
                  maxLength: 160,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (_,
                      {required currentLength, maxLength, required isFocused}) {
                    return const SizedBox.shrink();
                  },
                  controller: model.duleTech,
                  cursorColor: Colors.white,
                  cursorHeight: 28,
                  cursorRadius: const Radius.circular(100),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Type your message',
                      hintStyle: TextStyle(
                          color: Colors.white.withAlpha(200), fontSize: 24),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none)),
                ),
                decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(32)),
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                horizontalSpaceRegular,
                IconButton(
                  onPressed: () {
                    model.updateDuleFocus();
                  },
                  icon: const Icon((Icons.keyboard_alt_rounded)),
                  color: model.duleFocusNode.hasFocus
                      ? AppColors.blue
                      : AppColors.darkGrey,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    databaseService.addUserData(fireUser.id);
                  },
                  icon: const Icon((Icons.emoji_emotions)),
                  color: AppColors.yellow,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon((Icons.camera_rounded)),
                  color: AppColors.darkGrey,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon((Icons.photo_library_rounded)),
                  color: AppColors.darkGrey,
                  iconSize: 32,
                ),
                const Spacer(),
                Text(
                  model.wordLengthLeft,
                  style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    model.clearMessage();
                  },
                  icon: const Icon((Icons.delete)),
                  color: model.isDuleEmpty ? AppColors.darkGrey : AppColors.red,
                  iconSize: 32,
                ),
              ],
            ),
          ),
          bottomPadding(
            context,
          )
        ]),
      ),
    );
  }
}
