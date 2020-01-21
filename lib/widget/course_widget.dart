import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject_model.dart';
import '../screen/course_topic_screen.dart';
import '../screen/course_edit_screen.dart';
import '../providers/subject_provider.dart';


class CourseWidget extends StatelessWidget {

  final String id;
  final String title;
  final int color;
  final String imageUrl;
  final SubjectType type;


   CourseWidget({
     @required this.id,
     @required this.title,
     @required this.color,
     @required this.imageUrl,
     @required this.type,
     Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return InkWell(

      onTap: () {
        Navigator.of(context).pushNamed(
          CourseTopicScreen.routeName,
          arguments: {
            'id': id,
            'title': title,
            'imageUrl': imageUrl,
          }
        );
      },

          child: Card(
        elevation: 6,
        color: Color(color),
            child: ListTile(

          title: Text(title),

          leading: FittedBox(

              child: CircleAvatar(
              backgroundImage: NetworkImage(
                imageUrl
              ),
            ),
          ),

          trailing: Container(
            width: 100,

            child: Row(
              children: <Widget>[

                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      CourseEdit.routeName,
                      arguments: id,
                    );
                  },
                  color: Colors.black,
                ),

                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {

                      await Provider.of<SubjectProvider>(context, listen: false).deleteCourse(id);
                      
                    } catch (error) {

                      scaffold.showSnackBar(
                        SnackBar(
                          // backgroundColor: Colors.black54,
                          content: Text('Delete Failed!! check your internet connection', style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                           textAlign: TextAlign.center),
                        ),
                      );

                    }
                  },
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}