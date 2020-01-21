import 'package:flutter/material.dart';

import '../providers/subject_topics.dart';
import '../dummy/dummy_material_program_topics.dart';


class SubjectTopicsProvider with ChangeNotifier {

  List<SubjectTopics> _topics = dummyMaterialSubjectTopics;
  List<SubjectTopics> _quiz = dummyMaterialSubjectQuiz;


  List<SubjectTopics> get topicsQuizs {
    // return [..._topics];
    List<dynamic> _quizTopics = [];

    for (var i = 0; i < _quiz.length; i++) {
      _quizTopics.add(_topics[i]);
      _quizTopics.add(_quiz[i]);
    }

    return [..._quizTopics];

  }

  // //gives the list of bookmarks topics
  // List<SubjectTopics> get showBookmarks {
  //   return _topics.where((fav) => fav.isBookmark).toList();
  // }

}