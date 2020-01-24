import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//models Files
import '../models/http_exception.dart';
//providers Files
import '../providers/subject_topics.dart';



class SubjectTopicsProvider with ChangeNotifier {


  List<SubjectTopics> _topicQuiz = [];


  List<SubjectTopics> get topicsQuizs {

    return [..._topicQuiz];

  }

  //find the topics on Id
  SubjectTopics findById(String id) {
    return topicsQuizs.firstWhere((top) => top.id == id);
  }


  //fetch the courses topics
  Future<void> fetchAndSetTopics() async {

    const url = 'https://tutlify-admin-panel.firebaseio.com/topicQuiz.json';

    try {

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<SubjectTopics> loadedData = [];

      CourseType type;

      extractedData.forEach((topicId, topicData) {

        if (topicData['type'] == 'Topics') {
          type = CourseType.Topics;
        }else if(topicData['type'] == 'Quiz') {
          type = CourseType.Quiz;
        }else {
          print('...');
        }

        loadedData.add(
          SubjectTopics(
            id: topicId,
            title: topicData['title'],
            subId: topicData['subId'],
            type: type
          )
        );

      });

      _topicQuiz = loadedData;
      notifyListeners();
      
    } catch (error) {

      print(error);
      throw error;
    }

  }


  //add the topics of the course
  Future<void> addTopics(SubjectTopics subjectTopics) async {

    String type;

    if (subjectTopics.type == CourseType.Topics) {
      type = 'Topics';
    }else if (subjectTopics.type == CourseType.Quiz) {
      type = 'Quiz';
    }else {
      print('...');
    }

    const url = 'https://tutlify-admin-panel.firebaseio.com/topicQuiz.json';

    try {

      final response = await http.post(
        url,
        body: json.encode({
          'subId': subjectTopics.subId,
          'title': subjectTopics.title,
          'type': type,
        }),
      );

      print(json.decode(response.body)['name']);
      print(subjectTopics.subId);

      final newTopics = SubjectTopics(
        title: subjectTopics.title,
        type: subjectTopics.type,
        subId: subjectTopics.subId,
        id: json.decode(response.body)['name'],
      );

      _topicQuiz.add(newTopics);

      notifyListeners();
      
      
    } catch (error) {

      print(error);
      throw error;
    }
  }


  //update topics 
  Future<void> updateTopics(String id, SubjectTopics subjectTopics) async {

    final topicIndex = _topicQuiz.indexWhere((top) => top.id == id);
    
    if (topicIndex >= 0) {

      String type;

      if (subjectTopics.type == CourseType.Topics) {
        type = 'Topics';
      }else if (subjectTopics.type == CourseType.Quiz) {
        type = 'Quiz';
      }else {
        print('...');
      }

      final url = 'https://tutlify-admin-panel.firebaseio.com/topicQuiz/$id.json';

      try {

        await http.patch(url, body: json.encode({

          'subId': subjectTopics.subId,
          'title': subjectTopics.title,
          'type': type,

        }));

        _topicQuiz[topicIndex] = subjectTopics;
        notifyListeners();

      } catch (error) {

        print(error);
        throw error;

      }
      
    }else {

      print('......e');

    }
  }


  //delete topics
  Future<void> deleteTopics(String id) async {

    final url = 'https://tutlify-admin-panel.firebaseio.com/topicQuiz/$id.json';
    final existingTopicIndex = _topicQuiz.indexWhere((top) => top.id == id);
    var existingTopics = _topicQuiz[existingTopicIndex];

    _topicQuiz.removeAt(existingTopicIndex);
    notifyListeners();

    final response = await http.delete(url);
    
    if (response.statusCode >= 400) {

      _topicQuiz.insert(existingTopicIndex, existingTopics);
      notifyListeners();
      throw HttpException('could not delete the topic');
      
    }
    existingTopics = null;

  }

}