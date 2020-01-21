import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './topic_edit_screen.dart';
import '../widget/topic_widget.dart';
import '../providers/subject_topics_provider.dart';


class CourseTopicScreen extends StatelessWidget {

  static const routeName = '/course-topic';

   CourseTopicScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final courseData = ModalRoute.of(context).settings.arguments as Map<String, String>;

    final String courseId = courseData['id'];
    final String courseTitle = courseData['title'];
    final String courseImageUrl = courseData['imageUrl'];

    final topicData = Provider.of<SubjectTopicsProvider>(context).topicsQuizs.where((topQuiz) => topQuiz.subId == courseId).toList();
    
    return Scaffold( 

      appBar: AppBar(
        title: Text(
          courseTitle,
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                TopicEditScreen.routeName,

                arguments: courseId
              );
              print(courseId);
              
            },
          )
        ],
      ),
    
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: topicData.length,
          itemBuilder: (_,i) => TopicWidget(
            id: topicData[i].id,
            title: topicData[i].title,
            courseTitle: courseTitle,
            imageUrl: courseImageUrl,
            type: topicData[i].type,
          )
        ),
      ),
    );
  }
}