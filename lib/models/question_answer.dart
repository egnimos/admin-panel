import 'package:flutter/material.dart';


class QuestionAnswer {

  final String id;
  final String qcId; //quiz Id
  final String question;
  final Map<String , String> options;
  final String answer;
  

  //construct
  QuestionAnswer({
    @required this.id,
    @required this.qcId,
    @required this.question,
    this.options = const{
      'a': '',
      'b': '',
      'c': '',
      'd': '',
    },
    @required this.answer,
  });
  
}
 
