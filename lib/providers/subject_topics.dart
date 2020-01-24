import 'package:flutter/material.dart';


enum CourseType {
  Quiz,
  Topics,
}


class SubjectTopics with ChangeNotifier{

  final String id;
  final String subId;
  final String title;
  final CourseType type;
  // bool isBookmark;
  
  //construct
  SubjectTopics({
  @required this.id,
  @required this.subId,
  @required this.title,
  @required this.type,
    // this.isBookmark = false,
  });

}