import 'package:flutter/material.dart';

//providers Files
import '../providers/subject_topics.dart';
//edit Files
import '../edit_Screens/topic_content_edit_widget.dart';
//widget Files
import '../widget/quiz_widget.dart';



class TopicQuizScreen extends StatefulWidget {
  
  static const routeName = 'topic-quiz-screen';

  const TopicQuizScreen({Key key}) : super(key: key);

  @override
  _TopicQuizScreenState createState() => _TopicQuizScreenState();
}

class _TopicQuizScreenState extends State<TopicQuizScreen> {

  @override
  Widget build(BuildContext context) {

      final topicOrQuizData = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      final topicOrQuizid = topicOrQuizData['id'];
      final type = topicOrQuizData['type'];
      // final title = topicOrQuizData['title'];

    // if (type == CourseType.Quiz) {
    // }

    // if (type == CourseType.Topics) {

    //   //write some code...
    //   // _appBarTitle = 'Topic';
    // }


    return type == CourseType.Quiz ? 
      
      //quiz widget...

      QuizWidget(topicOrQuizid)

     

      :

      //topics screen... 
      TopicContentEditWidget();
      
  }
}