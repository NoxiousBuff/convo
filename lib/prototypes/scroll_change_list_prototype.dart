import 'package:flutter/material.dart';

class ScrollLimitReached extends StatefulWidget {
  @override
  _ScrollLimitReachedState createState() => _ScrollLimitReachedState();
}

class _ScrollLimitReachedState extends State<ScrollLimitReached> {
  bool showElevation = false;
  late ScrollController _controller;
  String message = "";

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
        showElevation = true;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }

  _onStartScroll(ScrollMetrics metrics) {
    setState(() {
      message = "Scroll Start";
    });
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      message = "Scroll Update";
    });
  }

  _onEndScroll(ScrollMetrics metrics) {
    setState(() {
      message = "Scroll End";
    });
  }

  _onScroll(ScrollMetrics metrics) {
    setState(() {
      message = "is Scrolling";
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    setState(() {
      message = "reach the top";
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: message == "reach the top" ? 8.0 : 0.0,
        title: Text("Scroll Limit reached"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            color: Colors.green,
            child: Center(
              child: Text(message),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  return _onStartScroll(scrollNotification.metrics);
                } else if (scrollNotification is ScrollUpdateNotification) {
                  return _onUpdateScroll(scrollNotification.metrics);
                } else if (scrollNotification is ScrollEndNotification &&
                    _scrollListener()) {
                  return _onEndScroll(scrollNotification.metrics);
                } else if (scrollNotification is Scrollable) {
                  return _onScroll(scrollNotification.metrics);
                } else {
                  return showElevation;
                }
              },
              child: ListView.builder(
                controller: _controller,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(title: Text("Index : $index"));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
