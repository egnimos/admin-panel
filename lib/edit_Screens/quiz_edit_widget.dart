import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//model File
import '../models/question_answer.dart';
//provider File
import '../providers/quiz_answer_provider.dart';


class QuizEditWidget extends StatefulWidget {

  final String topicsOrQuizId;

  QuizEditWidget({
    @required this.topicsOrQuizId,
    Key key}) : super(key: key);

  @override
  _QuizEditWidgetState createState() => _QuizEditWidgetState();
}

class _QuizEditWidgetState extends State<QuizEditWidget> {

    
  final _optionFocusNodea = FocusNode();
  final _optionFocusNodeb = FocusNode();
  final _optionFocusNodec = FocusNode();
  final _optionFocusNoded = FocusNode();
  final _answerFocusNode = FocusNode();

  //to interact the value of the form
  final _form = GlobalKey<FormState>();

//for circular indicator
  var _isLoading = false;


  var _editedQuiz = QuestionAnswer(
    id: null,
    qcId: null,
    question: '',
    options: {
      'a': '',
      'b': '',
      'c': '',
      'd': '',
    },
    answer: '',
  );

  // QuestionAnswer editedQuiz(value) {
  //   return _editedQuiz = QuestionAnswer(
  //   id: null,
  //   qcId: null,
  //   question: '',
  //   options: {
  //     'a': '',
  //     'b': '',
  //     'c': '',
  //     'd': '',
  //   },
  //   answer: '',
  // );
  // }

  Future<void> _saveFormData() async {

    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return; //stops the execution of the function when there is a validation error,
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    try {

      await Provider.of<QuizAnswerProvider>(context, listen: false).addQues(_editedQuiz);
      
    } catch (error) {

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error occured!!'),
          content: Text('problem is occured check the internet connection'),
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

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
   

  }
  
  
  
  
  @override
  void dispose() {
    _optionFocusNodea.dispose();
    _optionFocusNodeb.dispose();
    _optionFocusNodec.dispose();
    _optionFocusNoded.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }
  

  
  //method of the question and answer input
  Container questionAnswerInput(String input, BuildContext context, String topicsOrQuizId) {
    
    return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 5,
                  height: 100,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: input),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_optionFocusNodea);
                    },

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the valid input';
                      }
                      return null;
                    },

                    onSaved: (value) {
                      _editedQuiz = QuestionAnswer(
                        id: _editedQuiz.id,
                        qcId: topicsOrQuizId,
                        question: value,
                        options: {
                          'a': _editedQuiz.options['a'],
                          'b': _editedQuiz.options['b'],
                          'c': _editedQuiz.options['c'],
                          'd': _editedQuiz.options['d'],
                        },
                        answer: _editedQuiz.answer,
                      );
                    },
                  )
                );
  }


  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      appBar: AppBar(
        
        title: Text('Quiz Edit'),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveFormData();
            }
          )
        ],
        
      ),
      
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      )
      : Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                //question input
                questionAnswerInput('Question', context, widget.topicsOrQuizId),
                
                //option  input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Text('a'),
                    
                    SizedBox(
                      width: 20,
                    ),
                    
                    Expanded(
                     child: Container(
                      padding: EdgeInsets.all(10.0),
                     width: MediaQuery.of(context).size.width-5,
                      height: 100,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'option'),
                        textInputAction: TextInputAction.next,
                        focusNode: _optionFocusNodea,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the valid input';
                          }
                          return null;
                        },

                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_optionFocusNodeb);
                        },

                        onSaved: (value) {
                            _editedQuiz = QuestionAnswer(
                            id: _editedQuiz.id,
                            qcId: widget.topicsOrQuizId,
                            question: _editedQuiz.question,
                            options: {
                              'a': value,
                              'b': _editedQuiz.options['b'],
                              'c': _editedQuiz.options['c'],
                              'd': _editedQuiz.options['d'],
                            },
                            answer: _editedQuiz.answer,
                          );

                        },
                      )
                    ),
                    ),
                  ]
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Text('b'),
                    
                    SizedBox(
                      width: 20,
                    ),
                    
                    Expanded(
                     child: Container(
                      padding: EdgeInsets.all(10.0),
                     width: MediaQuery.of(context).size.width-5,
                      height: 100,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'option'),
                        textInputAction: TextInputAction.next,
                        focusNode: _optionFocusNodeb,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the valid input';
                          }
                          return null;
                        },

                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_optionFocusNodec);
                        },

                        onSaved: (value) {
                           _editedQuiz = QuestionAnswer(
                            id: _editedQuiz.id,
                            qcId: widget.topicsOrQuizId,
                            question: _editedQuiz.question,
                            options: {
                              'a': _editedQuiz.options['a'],
                              'b': value,
                              'c': _editedQuiz.options['c'],
                              'd': _editedQuiz.options['d'],
                            },
                            answer: _editedQuiz.answer,
                          );
                          
                        },
                      )
                    ),
                    ),
                  ]
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Text('c'),
                    
                    SizedBox(
                      width: 20,
                    ),
                    
                    Expanded(
                     child: Container(
                      padding: EdgeInsets.all(10.0),
                     width: MediaQuery.of(context).size.width-5,
                      height: 100,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'option'),
                        textInputAction: TextInputAction.next,
                        focusNode: _optionFocusNodec,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the valid input';
                          }
                          return null;
                        },

                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_optionFocusNoded);
                        },

                        onSaved: (value) {
                           _editedQuiz = QuestionAnswer(
                            id: _editedQuiz.id,
                            qcId: widget.topicsOrQuizId,
                            question: _editedQuiz.question,
                            options: {
                              'a': _editedQuiz.options['a'],
                              'b': _editedQuiz.options['b'],
                              'c': value,
                              'd': _editedQuiz.options['d'],
                            },
                            answer: _editedQuiz.answer,
                          );
                          
                        },
                      )
                    ),
                    ),
                  ]
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Text('d'),
                    
                    SizedBox(
                      width: 20,
                    ),
                    
                    Expanded(
                     child: Container(
                      padding: EdgeInsets.all(10.0),
                     width: MediaQuery.of(context).size.width-5,
                      height: 100,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'option'),
                        textInputAction: TextInputAction.next,
                        focusNode: _optionFocusNoded,

                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the valid input';
                          }
                          return null;
                        },

                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_answerFocusNode);
                        },

                        onSaved: (value) {
                          _editedQuiz = QuestionAnswer(
                            id: _editedQuiz.id,
                            qcId: widget.topicsOrQuizId,
                            question: _editedQuiz.question,
                            options: {
                              'a': _editedQuiz.options['a'],
                              'b': _editedQuiz.options['b'],
                              'c': _editedQuiz.options['c'],
                              'd': value,
                            },
                            answer: _editedQuiz.answer,
                          );
                        },
                      )
                    ),
                    ),
                  ]
                ),
                
                //answer input
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 5,
                  height: 100,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Answer'),
                    textInputAction: TextInputAction.done,
                    focusNode: _answerFocusNode,

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the valid input';
                      }
                      return null;
                    },

                    onFieldSubmitted: (value) {
                      _saveFormData();
                    },

                    onSaved: (value) {
                      _editedQuiz = QuestionAnswer(
                        id: _editedQuiz.id,
                        qcId: widget.topicsOrQuizId,
                        question: _editedQuiz.question,
                        options: {
                          'a': _editedQuiz.options['a'],
                          'b': _editedQuiz.options['b'],
                          'c': _editedQuiz.options['c'],
                          'd': _editedQuiz.options['d'],
                        },
                        answer: value,
                      );
                    },
                  )
                ),
                
              ]
            )
          )
        ),
      )
    );
  }
}