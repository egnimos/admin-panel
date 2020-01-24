import 'package:flutter/material.dart';

//provider files
import '../providers/subject_topics.dart';

//edit Screen files
import '../edit_Screens/quiz_edit_widget.dart';
import '../edit_Screens/topic_content_edit_widget.dart';


class TopicContentQuizContentFormScreen extends StatelessWidget {

  static const routeName = '/topic-content-quiz-content';

  const TopicContentQuizContentFormScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final topicOrQuizdata = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final String topicOrQuizId = topicOrQuizdata['id'];
    final CourseType type = topicOrQuizdata['type'];

    return type == CourseType.Quiz ?

    QuizEditWidget(
      topicsOrQuizId: topicOrQuizId,
    )

    :

    TopicContentEditWidget();

  }
}