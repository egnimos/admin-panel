import 'package:flutter/material.dart';

import '../providers/subject_topics.dart';


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
    return Card(
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

          child: FittedBox(
            child: Row(
                children: <Widget>[

                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),

                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}