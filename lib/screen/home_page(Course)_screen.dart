import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/course_widget.dart';
import './course_edit_screen.dart';
import '../providers/subject_provider.dart';
// import '../models/subject_model.dart';
// import '../providers/subject_provider.dart';


class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _isInit = true;
  var _isLoading = false;

  Future<void> _fetchData(BuildContext context) async {
    await Provider.of<SubjectProvider>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {

    if (_isInit) {

      setState(() {
        _isLoading = true;
      });
      _fetchData(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }




  @override
  Widget build(BuildContext context) {

    final courseData = Provider.of<SubjectProvider>(context);
    //subject (Programming language)..
    //final programmingLanguage = courseData.halfList.where((type) => type.type == SubjectType.ProgrammingLanguage).toList();

    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Course List'
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                CourseEdit.routeName,
              );
            },
          )
        ],
      ),

      body: _isLoading ? LinearProgressIndicator(
        backgroundColor: Colors.purple,
      )
      
      : RefreshIndicator(
        onRefresh: () => _fetchData(context),
              child: Padding(
          padding: EdgeInsets.all(10),
          // child: SingleChildScrollView(
          //     child: Column(
          //     children: <Widget>[
              
                //  Container(
                //    width: MediaQuery.of(context).size.width - 5,
                //       height: 300,
                      child: ListView.builder(
                      itemCount: courseData.halfList.length,
                      itemBuilder: (_, i) => Column(
                        children: <Widget>[

                          CourseWidget(
                           id: courseData.halfList[i].id,
                           title: courseData.halfList[i].title,
                           color: courseData.halfList[i].color,
                           imageUrl: courseData.halfList[i].imageUrl,
                           type: courseData.halfList[i].type,
                          ),

                          Divider()

                        ],),

                  ),
                    ),
       
                  // Container(
                  //   height: 300,
                  //   color: Colors.red,
                  // ),
          
          //     ],
          //   ),
          // ),
          ),
      // ),

    );
  }
}