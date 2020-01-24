import 'package:flutter/material.dart';

//model File
import './subject_topics_units_model.dart';


class SubjectTopicsUnitsProvider with ChangeNotifier {

  List<SubjectTopicsUnitsModel> _units = [];


  List<SubjectTopicsUnitsModel> get units {
    return [..._units];
  } 



  
}