import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutlify_admin_panel/screen/topic_quiz_screen.dart';

import '../screen/topic_edit_screen(update_post).dart';
import '../providers/subject_topics.dart';
import '../providers/subject_topics_provider.dart';


class TopicWidget extends StatelessWidget {

  final String id;
  final String title;
  final CourseType type;
  final String imageUrl;
  final String courseTitle;

  const TopicWidget({
    @required this.id,
    @required this.title,
    @required this.type,
    @required this.imageUrl,
    @required this.courseTitle,
    Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final scaffold = Scaffold.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
         TopicQuizScreen.routeName,

         arguments: {
           'id': id,
           'type': type,
           'title': title,
         } 
        );

        print(id);
      },
          child: Card(
        elevation: 5,
        child: ListTile(
          
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),

          title: Text(
            title
          ),

          subtitle: type == CourseType.Topics 
          ? Text(
            '$courseTitle and type is TOPIC',
          ) 
          : Text(
           '$courseTitle and type is Quiz', 
          ),

          trailing: Container(

            width: 100,

            // child: FittedBox(
              child: Row(
                  children: <Widget>[

                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        TopicEditScreenUpdatePost.routeName,
                        arguments: id,
                      );
                    },
                  ),

                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.delete),
                    onPressed: () async {

                      try {

                        await Provider.of<SubjectTopicsProvider>(context, listen: false).deleteTopics(id);
                        
                      } catch (error) {

                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Delete Failed!! check your internet connection',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        );
                      }
                    },
                  )

                ],
              ),
            ),
          ),
        // ),
      ),
    );
  }
}