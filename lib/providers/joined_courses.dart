import 'package:flutter/material.dart';


class JoinedCourses {

  final String id;
  final String courseId;
  final String title;
  final String imageUrl;
  final Color color;
  final String content;
  int totalUserJoined;

  //construct
  JoinedCourses({
    @required this.id,
    @required this.courseId,
    @required this.title,
    @required this.imageUrl,
    @required this.color,
    @required this.content,
    this.totalUserJoined = 1,
  });

}


class Courses with ChangeNotifier {

  Map<String, JoinedCourses> _courses = {};

  Map<String, JoinedCourses> get courses {
    return {..._courses};
  }

 


  int get courseCount {
    return _courses.length;
  }

  void addCourses(String subjectId, String title, String imageUrl, Color color, String content, int totalUserJoined) {

    if(!_courses.containsKey(subjectId)) {

      _courses.putIfAbsent(subjectId, () => JoinedCourses(
        id: DateTime.now().toString(),
        courseId: subjectId,
        title: title,
        imageUrl: imageUrl,
        color: color,
        content: content,
        totalUserJoined: totalUserJoined + 1,
      ));
    }
    notifyListeners();
  }

  void removeJoinedCourse(String subjectId) {
    _courses.remove(subjectId);
    notifyListeners();
  }
  
}