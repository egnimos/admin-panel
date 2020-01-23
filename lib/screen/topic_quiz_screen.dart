import 'package:flutter/material.dart';
import 'package:tutlify_admin_panel/widget/quiz_widget.dart';
import 'package:tutlify_admin_panel/widget/topic_content_edit_widget.dart';
// import 'package:provider/provider.dart';

// import '../models/question_answer.dart';
// import '../screen/topic_content_quiz_content_form_screen.dart';
// import '../widget/quiz_widget.dart';
// import '../providers/quiz_answer_provider.dart';
import '../providers/subject_topics.dart';



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