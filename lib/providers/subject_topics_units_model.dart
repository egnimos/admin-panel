import 'package:flutter/material.dart';


class SubjectTopicsUnitsModel with ChangeNotifier {

  final String id;
  final String topicId; 
  final String title;
  final String content;
  bool isBookmark;
  IconData icon;
  

  //construct
  SubjectTopicsUnitsModel({
    @required this.id,
    @required this.topicId,
    @required this.title,
    @required this.content,
    this.isBookmark = false,
    this.icon = Icons.play_circle_filled, 
  });




}