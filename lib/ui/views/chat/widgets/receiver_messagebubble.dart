import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class ReceiveMessageBubble extends StatefulWidget {
  final Stream<DatabaseEvent> stream;
  const ReceiveMessageBubble({Key? key, required this.stream})
      : super(key: key);

  @override
  State<ReceiveMessageBubble> createState() => _ReceiveMessageBubbleState();
}

class _ReceiveMessageBubbleState extends State<ReceiveMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return shrinkBox;
        }
        if (!snapshot.hasData) {
          return shrinkBox;
        } else {
          final data = snapshot.data;

          if (data != null) {
            final json = data.snapshot.value;
            const padding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);
            final DuleModel duleModel = DuleModel.fromJson(json);
            var maxWidth = screenWidthPercentage(context, percentage: 0.8);
            return duleModel.msgTxt.isEmpty
                ? shrinkBox
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: padding,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: Text(
                              duleModel.msgTxt,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
          } else {
            return shrinkBox;
          }
        }
      },
    );
  }
}
