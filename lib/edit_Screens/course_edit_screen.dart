import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//model File
import '../models/subject_model.dart';
//provider File
import '../providers/subject_provider.dart';


class CourseEdit extends StatefulWidget {

  static const routeName = '/course-edit';

  CourseEdit({Key key}) : super(key: key);

  @override
  _CourseEditState createState() => _CourseEditState();
}

class _CourseEditState extends State<CourseEdit> {

  final _colorFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();// to interact the value of the form we need the key

  //provides the types, of the Course or subject
  static const typeSub = <SubjectType>[
    SubjectType.ProgrammingLanguage,
    SubjectType.FrameWork,
    SubjectType.CoreConcepts,
  ];

  //dropdown widget of the courses type
  final List<DropdownMenuItem<SubjectType>> _dropDownMenuItems = typeSub.map((value) => DropdownMenuItem(
    value: value,
    child: FittedBox(fit:BoxFit.contain ,child: Text('$value')),
  ),).toList();


  SubjectType _selectCoursesTypes = SubjectType.ProgrammingLanguage;

  // SubjectType get type {
  //   return _selectCoursesTypes;
  // }

  var _isInit = true;
  var _isLoading = false;

  var _initValue = {
    'title': '',
    'color': '',
    'content': '',
    'imageUrl': '',
    'type': SubjectType.ProgrammingLanguage,
  };

  var _editedCourse = SubjectModel(
    id: null,
    title: '',
    color: null,
    type: SubjectType.ProgrammingLanguage,
    content: '',
    imageUrl: '',
  );


  @override
  void initState() {

    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  

//assigning the initial value using didChangeDependencies
  @override
  void didChangeDependencies() {

    if (_isInit) {

      final courseId = ModalRoute.of(context).settings.arguments as String;

      if (courseId != null) {
        
      _editedCourse = Provider.of<SubjectProvider>(context, listen: false).findById(courseId);
      //assigning the intial value to update the chnages
      _initValue = {
        'title': _editedCourse.title,
        'color': _editedCourse.color.toString(),
        'content': _editedCourse.content,
        'imageUrl': '',
        'type': _editedCourse.type, 
      };
      _imageUrlController.text = _editedCourse.imageUrl;
      _selectCoursesTypes = _initValue['type'];  
      }

    }
    _isInit = false;

    super.didChangeDependencies();
  }



  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _colorFocusNode.dispose();
    _contentFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {

      setState(() {
        //this set state will automatically update the imageUrl when the focus is lossed//
      });
      
    }
  }


  ///save the form data
  Future<void> _saveFormData() async{


    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return; //it will stops the execution of function if there is validation error exist
    }

    setState(() {
    _isLoading = true;
    });

    _form.currentState.save();

    if (_editedCourse.id != null) {

      try {

        await Provider.of<SubjectProvider>(context, listen: false).updateCourses(_editedCourse.id, _editedCourse);
        
      } catch (error) {

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error ocurred!!'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),],
            ),
          );

      }

    }else {

      try{

        await Provider.of<SubjectProvider>(context, listen: false).addCourses(_editedCourse);

      } catch (error) {

         await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error ocurred!!'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),],
            ),
          );

      } 
      // finally {

      //   setState(() {   
      //   _isLoading = false;
      //   });

      //   Navigator.of(context).pop();

      // }
  

    }

    setState(() {   
    _isLoading = false;
    });

    Navigator.of(context).pop();

    // Navigator.of(context).pop();

  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit your Courses'
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveFormData();
            },
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
          child: ListView(
            // shrinkWrap: true,
            children: <Widget>[

              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(labelText: 'Course Name'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_colorFocusNode);
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your input';
                  }
                  return null;
                },

                onSaved: (value) {
                  _editedCourse = SubjectModel(
                    title: value,
                    color: _editedCourse.color,
                    type: _editedCourse.type,
                    content: _editedCourse.content,
                    imageUrl: _editedCourse.imageUrl,
                    id: _editedCourse.id,
                    
                  );
                },
              ),

              TextFormField(
                initialValue: _initValue['color'],
                decoration: InputDecoration(labelText: 'Color(ex: Colors.green)'),
                textInputAction: TextInputAction.next,
                focusNode: _colorFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contentFocusNode);
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your input';
                  }

                  // if ((!value.startsWith('0xff')) || (!value.startsWith('0xFF'))) {
                  //   return 'enter the valid input';
                  // }
                  return null;
                },

                onSaved: (value) {

                  // Color colorValue = value as Color; 

                   _editedCourse = SubjectModel(
                    title: _editedCourse.title,
                    color: int.parse(value),
                    type: _editedCourse.type,
                    content: _editedCourse.content,
                    imageUrl: _editedCourse.imageUrl,
                    id: _editedCourse.id,
                  );
                },
              ),

              TextFormField(
                initialValue: _initValue['content'],
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                focusNode: _contentFocusNode,

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your input';
                  }
                  return null;
                },

                onSaved: (value) {

                   _editedCourse = SubjectModel(
                    title: _editedCourse.title,
                    color: _editedCourse.color,
                    type: _editedCourse.type,
                    content: value,
                    imageUrl: _editedCourse.imageUrl,
                    id: _editedCourse.id,
                  );
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),
                    child: _imageUrlController.text.isEmpty ? 
                    Text('Enter the imageUrl') 
                    : FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        _imageUrlController.text
                      ),
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'ImageUrl'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveFormData();
                      },

                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your input';
                        }

                        if (!value.startsWith('https') || (!value.startsWith('http'))) {
                          return 'Enter the valid input';
                        }
                        return null;
                      },

                      onSaved: (value) {

                        _editedCourse = SubjectModel(
                          title: _editedCourse.title,
                          color: _editedCourse.color,
                          type: _editedCourse.type,
                          content: _editedCourse.content,
                          imageUrl: value,
                          id: _editedCourse.id,
                        );
                      },

                    ),
                  )

                ],
              ),

              // SizedBox(
              //   height: 20,
              // ),

              Container(
                width: MediaQuery.of(context).size.width - 5,
                height: 300,
                  child: ListTile(
                  title: Text('Select Type'),
                  trailing: Container(
                    width: 100,
                    height: 200,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: DropdownButton<SubjectType>(

                        value: _selectCoursesTypes,
                        onChanged: (newValue) {
                          setState(() {
                            _selectCoursesTypes = newValue;
                          });

                          _editedCourse = SubjectModel(
                                title: _editedCourse.title,
                                color: _editedCourse.color,
                                type: newValue,
                                content: _editedCourse.content,
                                imageUrl: _editedCourse.imageUrl,
                                id: _editedCourse.id,
                           );

                        },
                        items: _dropDownMenuItems,
                    ),
                      ),
                  ),
                ),
              ),

              //submit button
              // Container(
              //   width: 200,
              //   height: 100,
              //   margin: EdgeInsets.all(20),
              //   padding: EdgeInsets.all(20),
              //   child: RaisedButton(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     color: Colors.teal,
              //     focusColor: Colors.tealAccent,
              //     highlightElevation: 6,
              //     highlightColor: Colors.tealAccent,
              //     child: Text(
              //       'Create Course',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.w500,
              //         fontSize: 18,
              //       ),
              //     ),
              //     onPressed: () {
              //       _saveFormData();
              //     },
              //   ),
              // )
            ],
          ),
        ),
      )
      
    );
  }
}