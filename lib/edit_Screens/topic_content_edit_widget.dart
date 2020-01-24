import 'package:flutter/material.dart';


class TopicContentEditWidget extends StatefulWidget {
  const TopicContentEditWidget({Key key}) : super(key: key);

  @override
  _TopicContentEditWidgetState createState() => _TopicContentEditWidgetState();
}

class _TopicContentEditWidgetState extends State<TopicContentEditWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Topic Edit',
        ),
      ),

      body: Container(
        child: Center(
          child: Text(
            'This is the topic content edit screen'
          ),
        ),
      ),
    );
  }
}