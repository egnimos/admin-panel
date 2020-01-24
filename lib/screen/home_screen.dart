import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//models Files
import '../models/subject_model.dart';
//providers Files
import '../providers/subject_provider.dart';
import '../providers/subject_topics_provider.dart';
import '../providers/quiz_answer_provider.dart';
//screen Files
import '../screen/Course_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var _isInit = true;
  var _isLoading = false;

  Future<void> fetchData(BuildContext context) async {

    await Provider.of<SubjectProvider>(context, listen:false).fetchAndSetProducts().then((_) {
      Provider.of<SubjectTopicsProvider>(context, listen:false).fetchAndSetTopics();
    }).then((_) {
      Provider.of<QuizAnswerProvider>(context, listen:false).fetchAndSetQues();
    });

  }


  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchData(context).then((_) {
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

    final coursesList = Provider.of<SubjectProvider>(context).halfList;

    final courseProgramming = coursesList.where((pro) => pro.type == SubjectType.ProgrammingLanguage).toList();
    final courseFrameWork = coursesList.where((pro) => pro.type == SubjectType.FrameWork).toList();
    final courseCoreConcept = coursesList.where((pro) => pro.type == SubjectType.CoreConcepts).toList();

    final topicsList = Provider.of<SubjectTopicsProvider>(context).topicsQuizs;

    final quizList = Provider.of<QuizAnswerProvider>(context).queAns;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home')
      ),
      body: _isLoading ?

      LinearProgressIndicator(
        backgroundColor: Colors.teal,
      )

      : RefreshIndicator(
        onRefresh: () => fetchData(context),
              child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //heading
              headingContainer(context, 'Course Category'), // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,


              //container of the courses category
              FittedBox(
                  child: Row(
                  children: <Widget>[
                    courseContainer('Programming', courseProgramming.length, 'No of Courses:', SubjectType.ProgrammingLanguage),

                    courseContainer('FrameWork', courseFrameWork.length, 'No of Courses:', SubjectType.FrameWork),
                  ],
                ),
              ),

              
              SizedBox(
                height: 50,
              ),

              courseContainer('Core Concept', courseCoreConcept.length, 'No of Courses:', SubjectType.CoreConcepts),

              SizedBox(
                height: 50,
              ),


              //other info
              headingContainer(context, 'List Of Topics'),

              otherInfo('List Of Topics', topicsList.length, 'No of Topics:', 'Topics' ),

              headingContainer(context, 'Topic Content & Quiz Content'),

              FittedBox(
                  child: Row(
                  children: <Widget>[
                    otherInfo('Topics Content', 234, 'No of Content:', 'Topics Content'),
                    otherInfo('Quiz Content', quizList.length, 'No of Quiz:', 'Quiz content'),
                  ],
                ),
              ),

                 
             





              


                
            ],
          ),
        ),
      ),
    );
  }

  Container headingContainer(BuildContext context, text) {
    return Container(
            width: MediaQuery.of(context).size.width - 5,
            height: 80,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.teal[900],
              ),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget courseContainer(String text, int number, String info,  SubjectType type) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          HomePage.routeName,

          arguments: type,
        );
      },
      
          child: Container(
              width: 200,
              height: 250,
              padding: EdgeInsets.only(
                top:30,
                ),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(2, 2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Container(
                    padding: EdgeInsets.only(
                      top:20,
                      bottom: 20,
                      ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      top:5,
                      left: 5,
                      right: 5,
                      bottom: 30,
                      ),
                    child: Text(
                      '$type',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        ),
                    ),
                    // elevation: 5,
                    color: Colors.teal[900],
                    margin: EdgeInsets.all(0),
                    child: FittedBox(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            child: Text(
                              info,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            child: Text(
                              '$number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget otherInfo(String text, int number, String info,  String type) {
   return Container(
                  width: 200,
                  height: 250,
                  padding: EdgeInsets.only(
                    top:30,
                    ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(1, 1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(
                          top:20,
                          bottom: 20,
                          ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(
                          top:5,
                          bottom: 30,
                          ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                        ),
                        ),
                        // elevation: 5,
                        color: Colors.red[900],
                        margin: EdgeInsets.all(0),
                        child: FittedBox(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  info,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
  }
}