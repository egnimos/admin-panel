import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/subject_topics.dart';
import '../providers/subject_topics_provider.dart';


class TopicEditScreen extends StatefulWidget {

  static const routeName = '/topic-edit-screen';

  const TopicEditScreen({Key key}) : super(key: key);

  @override
  _TopicEditScreenState createState() => _TopicEditScreenState();
}

class _TopicEditScreenState extends State<TopicEditScreen> {

  final _form = GlobalKey<FormState>(); // to interact the value of the form we need the key

  //provides the types, of the Course or subject
  static const typetopic = <CourseType>[
    CourseType.Topics,
    CourseType.Quiz,
  ];


    //dropdown widget of the courses type
  final List<DropdownMenuItem<CourseType>> _dropDownMenuItems = typetopic.map((value) => DropdownMenuItem(
    value: value,
    child: FittedBox(fit:BoxFit.contain ,child: Text('$value')),
  ),).toList();


  CourseType _selectTopicTypes = CourseType.Topics;

  // var _isInit = true;
  var _isLoading = false;
  // String courseId;

  // var _initValue = {
  //   'subId': null,
  //   'title': '',
  //   'type' : CourseType.Topics,
  // };


  var _editedTopic = SubjectTopics(
    id: null,
    subId: null,
    title: '',
    type: CourseType.Topics,
  );


  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {

  //     final topicsId = ModalRoute.of(context).settings.arguments as String;

  //     if (topicsId != null) {

  //       _editedTopic = Provider.of<SubjectTopicsProvider>(context, listen: false).findById(topicsId);

  //       _initValue = {
  //         'subId': _editedTopic.subId,
  //         'title': _editedTopic.title,
  //         'type': _editedTopic.type,
  //       };
  //       _selectTopicTypes = _initValue['type'];
        
  //     }
  //     else {

  //       print(topicsId);

  //     }
      
  //   }
  //   _isInit = false;

  //   // if (_editedTopic.id == null) {
  //   //    courseId = ModalRoute.of(context).settings.arguments as String; 
  //   // }
  //   super.didChangeDependencies();
  // }




  //add and updte the form data
  Future<void> _saveFormData() async {

    setState(() {
      _isLoading = true;
    });

    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return; //return if the validation exist
    }


    _form.currentState.save();

    try {

      

      await Provider.of<SubjectTopicsProvider>(context, listen: false).addTopics(_editedTopic);
      
    } catch (error) {

       showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Process faied check the connection'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),],

        ),
      );
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();


  }

 

  


  @override
  Widget build(BuildContext context) {


    final courseId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Topic Edit screen'
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save,),
            onPressed: () {
              _saveFormData();
            },
          )
        ],
      ),


       body: _isLoading ? Center(
         child: CircularProgressIndicator()
       )
       : Padding(
         padding: EdgeInsets.all(8.0),
         child: Form(
           key: _form,
           child: SingleChildScrollView(
              child: Column(
               children: <Widget>[

                
                SizedBox(
                    height: 40,
                ),

                  Container(
                width: MediaQuery.of(context).size.width - 5,
                height: 150,
                  child: ListTile(
                  title: Text('Select Type'),
                  trailing: Container(
                    width: 150,
                    height: 200,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: DropdownButton<CourseType>(

                        value: _selectTopicTypes,
                        onChanged: (newValue) {
                          setState(() {
                            _selectTopicTypes = newValue;
                          });

                          _editedTopic = SubjectTopics(
                                id: _editedTopic.id,
                                subId: courseId,
                                title: _editedTopic.title,
                                type: newValue,
                           );


                          
                        },
                        items: _dropDownMenuItems,
                    ),
                      ),
                  ),
                ),
              ),

                  
              Container(
                width: double.infinity,
                height: 100,
                child: TextFormField(
                  // initialValue: _initValue['title'],
                  decoration: InputDecoration(
                    labelText: 'Topic Name',
                    helperText: 'Enter the topic name or quiz name (ex: Introduction to Java or Quiz time 1',
                    ),
                    textInputAction: TextInputAction.done,

                    onFieldSubmitted: (_) {
                      _saveFormData();
                    },

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the valid input';
                      }
                      return null;
                    },

                    onSaved: (value) {
                      _editedTopic = SubjectTopics(
                                id: _editedTopic.id,
                                subId: courseId,
                                title: value,
                                type: _editedTopic.type,
                           );
                    },
                ),
              ),
                 
                 
               ],
             ),
           ),
         ),
       ),
    );
  }
}