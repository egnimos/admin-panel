import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//model Files
import '../models/subject_model.dart';
//providers Files
import '../providers/subject_provider.dart';
//edit Screen Files
import '../edit_Screens/course_edit_screen.dart';
//widget Files
import '../widget/course_widget.dart';



class HomePage extends StatefulWidget {
  static const routeName = '/course-screen';

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
    
    final courseType = ModalRoute.of(context).settings.arguments as SubjectType;

    final courseData = Provider.of<SubjectProvider>(context).halfList.where((course) => course.type == courseType).toList();

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
                      itemCount: courseData.length,
                      itemBuilder: (_, i) => Column(
                        children: <Widget>[

                          CourseWidget(
                           id: courseData[i].id,
                           title: courseData[i].title,
                           color: courseData[i].color,
                           imageUrl: courseData[i].imageUrl,
                           type: courseData[i].type,
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