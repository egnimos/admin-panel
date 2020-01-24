import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/home_screen.dart';
import './screen/quiz_edit_update_screen.dart';
import './screen/topic_content_quiz_content_form_screen.dart';
import './screen/topic_quiz_screen.dart';
import './screen/topic_edit_screen.dart';
import './screen/topic_edit_screen(update_post).dart';
import './providers/subject_topics_provider.dart';
import './screen/course_topic_screen.dart';
import './providers/subject_provider.dart';
import './screen/Course_screen.dart';
import './screen/course_edit_screen.dart';
import './providers/quiz_answer_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

      ChangeNotifierProvider.value(
        value: SubjectProvider(),
      ),

      ChangeNotifierProvider.value(
        value: SubjectTopicsProvider(),
      ),

      ChangeNotifierProvider.value(
        value: QuizAnswerProvider(),
      )

      ],
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          CourseEdit.routeName: (ctx) => CourseEdit(),
          CourseTopicScreen.routeName: (ctx) => CourseTopicScreen(),
          TopicEditScreen.routeName: (ctx) => TopicEditScreen(),
          TopicEditScreenUpdatePost.routeName: (ctx) => TopicEditScreenUpdatePost(),
          TopicQuizScreen.routeName: (ctx) => TopicQuizScreen(),
          TopicContentQuizContentFormScreen.routeName: (ctx) => TopicContentQuizContentFormScreen(),
          QuizEditUpdateScreen.routeName: (ctx) => QuizEditUpdateScreen()
        },
      ),
    );
  }
}

