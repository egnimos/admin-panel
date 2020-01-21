import 'package:flutter/material.dart';
import '../dummy/dummy_material_topics_content_detail.dart';

import './subject_topics_units_model.dart';


class SubjectTopicsUnitsProvider with ChangeNotifier {

  List<SubjectTopicsUnitsModel> _units = dummyMaterialTopicsContentDetail;


  List<SubjectTopicsUnitsModel> get units {
    return [..._units];
  } 

  // List<Widget> tabs(String id) {
  //   List<Widget> tab = [];
  //   var un = _units.where((uni) => uni.id == id).toList();
  //   for (var i = 0; i < un.length; i++) {
  //     tab.add(Tab(icon: Icon(Icons.play_circle_filled),));
  //   }

  //   return tab;
  // }

  
}