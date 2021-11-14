import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'dule_viewmodel.dart';

class DuleView extends StatelessWidget {
  const DuleView({Key? key}) : super(key: key);

  static const String id = '/DuleView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DuleViewModel>.reactive(
      viewModelBuilder: () => DuleViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          flexibleSpace: InkWell(onTap:(){}),
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
                      'https://images.unsplash.com/photo-1621318165483-1cfd49a88ef5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=751&q=80',
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          title: const Text(
            'Devon',
            style: TextStyle(
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
                child: TextFormField(
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
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 24),
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
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
                  },
                  maxLength: 160,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  buildCounter: (_, {required currentLength, maxLength, required isFocused}) {
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
                  color: model.duleFocusNode.hasFocus ? AppColors.blue : AppColors.darkGrey,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon((Icons.emoji_emotions)),
                  color: AppColors.yellow,
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {},
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
