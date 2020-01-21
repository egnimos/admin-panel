import 'package:flutter/material.dart';


import '../providers/subject_topics.dart';


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

  // String _courseId;

  @override
  void initState() {

  //  final _courseId = ModalRoute.of(context).settings.arguments as String; 

    super.initState();
  }

    var _editedTopic = SubjectTopics(
    id: null,
    subId: null,
    title: '',
    type: CourseType.Topics,
  );


    //dropdown widget of the courses type
  final List<DropdownMenuItem<CourseType>> _dropDownMenuItems = typetopic.map((value) => DropdownMenuItem(
    value: value,
    child: FittedBox(fit:BoxFit.contain ,child: Text('$value')),
  ),).toList();


  CourseType _selectTopicTypes = CourseType.Topics;


  //add and updte the form data
  void _saveFormData() {

    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return; //return if the validation exist
    }


    _form.currentState.save();

    // print(_editedTopic.id);
    // print(_editedTopic.subId);
    // print(_editedTopic.title);
    // print(_editedTopic.type);
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


       body: Padding(
         padding: EdgeInsets.all(8.0),
         child: Form(
           key: _form,
           child: SingleChildScrollView(
            //  controller: ScrollController(

            //  ),
              child: Column(
               children: <Widget>[

                
                SizedBox(
                    height: 40,
                ),


                  // Expanded(
                  //   //  flex: 2,
                    //  child: 

                  //  ),

                  // SizedBox(
                  //   height: 30,
                  // ),

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