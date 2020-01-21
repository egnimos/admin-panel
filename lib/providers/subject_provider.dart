import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/subject_model.dart';
import '../models/http_exception.dart';
// import '../dummy/dummy_material_programming_language.dart';


class SubjectProvider with ChangeNotifier {

  // final String type;

  List<SubjectModel> _subjects = [];
  List<SubjectModel> _frameworks = [];
  List<SubjectModel> _coreConcepts = [];

  List<SubjectModel> _halfList = [];

  // var count = _coreConcepts.length + _subjects.length + _frameworks.length;

  // var count = coreConcepts.length;

  // SubjectProvider();

  List<SubjectModel> get subjects {
    return [..._subjects];
  }

  List<SubjectModel> get frameworks {
    return [..._frameworks];
  }

  List<SubjectModel> get coreConcepts {
    return [..._coreConcepts];
  }

  List<SubjectModel> get halfList {
    return [..._halfList];
  }

  SubjectModel findById(String id) {
    return halfList.firstWhere((sub) => sub.id == id);
  }

  //fecth data from the database
  Future<void> fetchAndSetProducts() async {

    const url = 'https://tutlify-admin-panel.firebaseio.com/courses.json';

    try {

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<SubjectModel> loadedData = [];
      SubjectType type;

      extractedData.forEach((courseId, courseData) {

        if (courseData['type'] == 'Programming Language') {
           type = SubjectType.ProgrammingLanguage;
        }else if (courseData['type'] == 'Framework') {
           type = SubjectType.FrameWork;
        }else if(courseData['type'] == 'CoreConcept') {
           type = SubjectType.CoreConcepts;
        }else {
           print('...');
        }

        loadedData.add(
          SubjectModel(
            id: courseId,
            title: courseData['title'],
            imageUrl: courseData['imageUrl'],
            content: courseData['content'],
            type: type,
            color: int.parse(courseData['color'].toString()),
          ));
      });

      _halfList = loadedData;

      // for (var i = 0; i < loadedData.length; i++) {

      //   // String type = loadedData[i].type;
        
      // if (loadedData[i].type == SubjectType.ProgrammingLanguage) {
      //   _subjects = loadedData;
      // }else if(loadedData[i].type == SubjectType.FrameWork) {
      //   _frameworks = loadedData;
      // }else if(loadedData[i].type == SubjectType.CoreConcepts) {
      //   _coreConcepts = loadedData;
      // }else {
      //   print('...');
      // }
      
      // }

      notifyListeners();

    } catch (error) {

      print(error);

      throw (error);

    }
  }

  //add the course in the given type of list
  Future<void> addCourses(SubjectModel subject) async {

    final String color = subject.color.toString();

     String type;

    if (subject.type == SubjectType.ProgrammingLanguage) {
        type = 'Programming Language';
    }else if (subject.type == SubjectType.FrameWork) {
        type = 'Framework';
    }else if(subject.type == SubjectType.CoreConcepts) {
        type = 'CoreConcept';
    }else {
      print('enter the valid input');
    }

    const url = 'https://tutlify-admin-panel.firebaseio.com/courses.json';

    try {

      final response = await http.post(
      url,
      body: json.encode({
        'title': subject.title,
        'content': subject.content,
        'color': color,
        'imageUrl': subject.imageUrl,
        'type': type,
      }),
    );

    print(json.decode(response.body)['name']);

       final newCourse = SubjectModel(
      title: subject.title,
      content: subject.content,
      color: subject.color,
      imageUrl: subject.imageUrl,
      type: subject.type,
      id: json.decode(response.body)['name'],
    );

    // if (subject.type == SubjectType.ProgrammingLanguage) {
    //   _subjects.add(newCourse);
    // }else if (subject.type == SubjectType.FrameWork) {
    //   _frameworks.add(newCourse);
    // }else if(subject.type == SubjectType.CoreConcepts) {
    //   _coreConcepts.add(newCourse);
    // }else {
    //   print('enter the valid input');
    // }

    _halfList.add(newCourse);

    notifyListeners();
 
      
    } catch (error) {

      print(error);

      throw error;
    }

  }


  //update the Course
  Future<void> updateCourses(String id, SubjectModel subject) async {

    final courseIndex = halfList.indexWhere((course) => course.id == id);

    if (courseIndex >= 0) {

         final String color = subject.color.toString();

         String type;

          if (subject.type == SubjectType.ProgrammingLanguage) {
              type = 'Programming Language';
          }else if (subject.type == SubjectType.FrameWork) {
              type = 'Framework';
          }else if(subject.type == SubjectType.CoreConcepts) {
              type = 'CoreConcept';
          }else {
            print('enter the valid input');
          }

      final url = 'https://tutlify-admin-panel.firebaseio.com/courses/$id.json';

      try {

        await http.patch(url, body: json.encode({
          
        'title': subject.title,
        'content': subject.content,
        'color': color,
        'imageUrl': subject.imageUrl,
        'type': type,

        }));

        _halfList[courseIndex] = subject;
        
      } catch (error) {

        print(error);
        throw (error);
      }

   
      
    }else {
      print('...');
    }

    notifyListeners();

  }

  //delete course
  Future<void> deleteCourse(String id) async {

    final url = 'https://tutlify-admin-panel.firebaseio.com/courses/$id.json';
    final existingCourseIndex = _halfList.indexWhere((course) => course.id == id);
    var existingCourse = _halfList[existingCourseIndex];

    _halfList.removeAt(existingCourseIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {

      _halfList.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Could not delete course');
    }
    existingCourse = null; 
    
  }

  
}