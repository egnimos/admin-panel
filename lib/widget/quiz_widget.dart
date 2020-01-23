import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/subject_topics.dart';
import '../screen/topic_content_quiz_content_form_screen.dart';
import '../providers/quiz_answer_provider.dart';

class QuizWidget extends StatefulWidget {

  final String topicOrQuizId;

  //construct
  QuizWidget(this.topicOrQuizId); 
    

   //choice button widget,
  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {

  var _isLoading = false;
  var _isInit = true;


  @override
  void didChangeDependencies() {

    if (_isInit) {
      setState(() {
       _isLoading = true;
      });
      Provider.of<QuizAnswerProvider>(context).fetchAndSetQues().then((_) {
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

    final queAnsData = Provider.of<QuizAnswerProvider>(context).queAns.where((ques) => ques.qcId == widget.topicOrQuizId).toList();

    // final scaffold = Scaffold.of(context);

    return   Scaffold(
      
      appBar: AppBar(
        title: Text(
          'Quiz Screen',
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                TopicContentQuizContentFormScreen.routeName,

                arguments: {
                  'id' : widget.topicOrQuizId,
                  'type': CourseType.Quiz,
                }
              );
            },
          )
        ],
      ),

      body:  _isLoading ?

      Center(
        child: CircularProgressIndicator(),
      )
       
      : 

      //  RefreshIndicator(
      //    onRefresh: () {},
      //           child: 
                Container(
           width: MediaQuery.of(context).size.width - 5,
           height: MediaQuery.of(context).size.height -5,
           child: PageView.builder(

              itemCount: queAnsData.length,
              itemBuilder: (_, i) => QuizWidgetClass(
        
                  id: queAnsData[i].id,
                  question: queAnsData[i].question,
                  options: {
                    'a': queAnsData[i].options['a'],
                    'b': queAnsData[i].options['b'],
                    'c': queAnsData[i].options['c'],
                    'd': queAnsData[i].options['d'],
                  },
                  answer: queAnsData[i].answer,
              ),
            ),
         ),
      //  ),
   
    );
          
  }

}

//quiz widget
class QuizWidgetClass extends StatelessWidget {

  final String id;
  final String question; 
  final Map<String, String> options; 
  final String answer;

  const QuizWidgetClass({
    @required this.id,
    @required this.question,
    @required this.options,
    @required this.answer,
    Key key,
  }) : super(key: key);


  //opition button.....
  Padding choiceButton(String text) {
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 15.0,
      ),
      child: MaterialButton(
        onPressed: () {},
        
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
        
        color: Colors.indigo,
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )
      )
    );
  }

  Container displayQuesAnswer( String text) {
    
    return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                               ),
                    
                  );
    
  }


  @override
  Widget build(BuildContext context) {

    final scaffold = Scaffold.of(context);
    
    return Container(
      color: Colors.white,
           width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  width: 200,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(
                    top: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {

                          try {

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete message!!'),
                                content: Text('Are you sure you want to delete the item'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }
                                  ),

                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () async {

                                      try {

                                      await Provider.of<QuizAnswerProvider>(context, listen:false).deleteQues(id);
                                        
                                      } catch (error) {

                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Problem occured'),
                                            content: Text('Check your Internet connection'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ) 
                                        );
                                      }
                                    }
                                  )
                                ],
                              )
                            );
                            
                            
                          } catch (error) {

                            print(error);

                             scaffold.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Delete failed!! check you internet connection',
                                  style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ),
                            );
                          }
                        },
                      ),

                    ],
                  ),
                ),
                
                Expanded(
                  flex: 2,
                  child: displayQuesAnswer('Ques : $question'),
                  
                ),
                
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: FittedBox( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        choiceButton(options['a']),
                        choiceButton(options['b']),
                        choiceButton(options['c']),
                        choiceButton(options['d']),
                      ],
                    ),
                   ),
                  ),
                ),
                
                Expanded(
                  flex: 1,
                  child: displayQuesAnswer('Ans : $answer'),
                )
                
              ],),
        
    );
  }
}