import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//models Files
import '../models/subject_model.dart';
import '../models/http_exception.dart';



class SubjectProvider with ChangeNotifier {

  List<SubjectModel> _halfList = [];

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
        notifyListeners();
        
      } catch (error) {

        print(error);
        throw (error);
      }

   
      
    }else {
      print('...');
    }

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