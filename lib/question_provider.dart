// // question_provider.dart

// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

// class QuestionProvider extends ChangeNotifier {
//   final Database _database;

//   QuestionProvider(this._database);

//   Future<void> resetGame() async {
//     await _database.update('questions', {'a': 0}); // Reset all levels
//     await _database.update('questions', {'a': 1},
//         where: 'id = ?', whereArgs: [1]); // Unlock the first level
//     await refreshQuestions();
//   }

//   Future<void> refreshQuestions() async {
//     final List<Map<String, dynamic>> maps = await _database.query('questions');
//     _questions = maps;
//     notifyListeners();
//   }

//   Future<List<Map<String, dynamic>>> getQuestions() async {
//     final List<Map<String, dynamic>> maps = await _database.query('questions');
//     _questions = maps;
//     return _questions;
//   }
// }
