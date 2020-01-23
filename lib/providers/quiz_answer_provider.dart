import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../models/http_exception.dart';
import '../models/question_answer.dart';


class QuizAnswerProvider with ChangeNotifier {

  List<QuestionAnswer> _queAns = [];


  List<QuestionAnswer> get queAns {
    return [..._queAns];
  }

  //fetch ques
  Future<void> fetchAndSetQues() async {

    const url = 'https://tutlify-admin-panel.firebaseio.com/quizQuestions.json';

    try {

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<QuestionAnswer> loadedData = [];

      extractedData.forEach((quesId, quesData) {

        loadedData.add(
          QuestionAnswer(
            id: quesId,
            qcId: quesData['qcId'],
            question: quesData['question'],
            options: {
              'a': quesData['option A'],
              'b': quesData['option B'],
              'c': quesData['option C'],
              'd': quesData['option D'],
            },
            answer: quesData['answer'],
          ));
      });

      print(loadedData);

      _queAns = loadedData;
      notifyListeners();
      
    } catch (error) {

      print(error);
      throw error;
    }
  }


  //add ques
  Future<void> addQues(QuestionAnswer questionAnswer) async {

    const url = 'https://tutlify-admin-panel.firebaseio.com/quizQuestions.json';

    try {
      
      final response = await http.post(
        url,
        body: json.encode({
          'qcId': questionAnswer.qcId,
          'question': questionAnswer.question,
          'option A': questionAnswer.options['a'],
          'option B': questionAnswer.options['b'],
          'option C': questionAnswer.options['c'],
          'option D': questionAnswer.options['d'],
          'answer': questionAnswer.answer,
        })
      );

      print(questionAnswer.qcId);

      final newQues = QuestionAnswer(
        qcId: questionAnswer.qcId,
        question: questionAnswer.question,
        options: {
          'a': questionAnswer.options['a'],
          'b': questionAnswer.options['b'],
          'c': questionAnswer.options['c'],
          'd': questionAnswer.options['d'],
        },
        answer: questionAnswer.answer,
        id: json.decode(response.body)['name'],
      );

      _queAns.add(newQues);
      notifyListeners();

    } catch (error) {

      print(error);
      throw error;

    }
  }


  //update ques
  Future<void> updateQues(String id, QuestionAnswer questionAnswer) async {

    final quesIndex = queAns.indexWhere((ques) => ques.id == id);

    if (quesIndex >= 0) {
      
      final url = 'https://tutlify-admin-panel.firebaseio.com/quizQuestions/$id.json';

      try {
        await http.patch(url, body: json.encode({

          'qcId': questionAnswer.qcId,
          'question': questionAnswer.question,
          'option A': questionAnswer.options['a'],
          'option B': questionAnswer.options['b'],
          'option C': questionAnswer.options['c'],
          'option D': questionAnswer.options['d'],
          'answer': questionAnswer.answer,

        }));

        _queAns[quesIndex] = questionAnswer;
        notifyListeners();

      } catch (error) {

        print(error);
        throw error;

      }
    }else {
      print('...');
    }

  }


  //delete ques
  Future<void> deleteQues(String id) async {

    final url = 'https://tutlify-admin-panel.firebaseio.com/quizQuestions/$id.json';
    final existingQuesIndex = _queAns.indexWhere((ques) => ques.id == id);

    print(existingQuesIndex);
    
    var existingQues = _queAns[existingQuesIndex];

    _queAns.removeAt(existingQuesIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {

      _queAns.insert(existingQuesIndex, existingQues);
      notifyListeners();
      throw HttpException('could not be deleted');

    }
    existingQues = null;

  }


  
}


