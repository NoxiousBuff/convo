import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hint/views/search_view.dart';
import 'calls_view.dart';
import 'groups_view.dart';

class FabView extends StatefulWidget {
  @override
  _FabViewState createState() => _FabViewState();
}

class _FabViewState extends State<FabView> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        elevation: 0.0,
        toolbarHeight: 90.0,
        backgroundColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: Color(0x4D000000),
            width: 0.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.normal),
          indicatorColor: Colors.black,
          controller: _controller,
          tabs: [
            Tab(text: 'Search'),
            Tab(text: 'Groups'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          SearchView(),
          GroupsView(),
          CallsView(),
        ],
      ),
    );
  }
}