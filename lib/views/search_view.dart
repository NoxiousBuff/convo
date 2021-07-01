import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchTech = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0),
              child: CupertinoTextField.borderless(
                controller: searchTech,
                padding: EdgeInsets.all(8.0),
                placeholder: 'Search for someone',
                decoration: BoxDecoration(
                    color: CupertinoColors.lightBackgroundGray,
                    border:
                        Border.all(color: CupertinoColors.lightBackgroundGray),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                searchTech.clear();
              });
            },
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}
