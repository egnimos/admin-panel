import 'package:flutter/material.dart';

enum SubjectType {
  ProgrammingLanguage,
  FrameWork,
  CoreConcepts,
}

class SubjectModel {

  final String id;
  // final String streamId;
  final String title;
  final String imageUrl;
  final SubjectType type;
  final int color;
  final String content;

  //construct
  SubjectModel({
   @required this.id,
   @required this.title,
   @required this.imageUrl,
   @required this.type,
   @required this.color,
   @required this.content,
  });
  
}