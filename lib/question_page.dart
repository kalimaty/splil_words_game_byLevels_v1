// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:provider/provider.dart';
// import 'package:splil_words_game/questions.dart';
// import 'question_provider.dart';

// class QuestionPage extends StatefulWidget {
//   final int level;
//   final Map<String, dynamic> question;

//   const QuestionPage({Key? key, required this.level, required this.question})
//       : super(key: key);

//   @override
//   _QuestionPageState createState() => _QuestionPageState();
// }

// class _QuestionPageState extends State<QuestionPage> {
//   List<String> allChars = "abcdefghijklmnopqrstuvwxyz".split("");
//   late List<String> answerChars = widget.question['answer'].split("");
//   late List<String> otherChars =
//       List.generate(10 - answerChars.length, (index) {
//     return allChars[Random().nextInt(allChars.length)];
//   });
//   late List charList = [...answerChars, ...otherChars];
//   late var emptyField =
//       List.generate(answerChars.length, (index) => "").toList();
//   int firstEmptyIndex = 0;

//   goToNext() {
//     setState(() {
//       firstEmptyIndex = emptyField.indexOf(
//           emptyField.firstWhere((element) => element == "", orElse: () => ""));
//     });
//   }

//   checkIfFull(BuildContext context) {
//     if (emptyField.join().length < answerChars.length) {
//       goToNext();
//     } else {
//       if (checkIfCorrect()) {
//         markAsAnswer(context, isCorrect: true);
//       } else {
//         markAsAnswer(context, isCorrect: false);
//       }
//     }
//   }

//   bool checkIfCorrect() {
//     return emptyField.join() == answerChars.join();
//   }

//   markAsAnswer(BuildContext context, {bool isCorrect = true}) async {
//     final db =
//         await Provider.of<QuestionProvider>(context, listen: false).database;

//     if (isCorrect) {
//       await db.update('questions', {'a': 1},
//           where: 'id = ?', whereArgs: [widget.level - 1]);

//       bool isLastLevel = (widget.level == Questions.questions.length);
//       if (isLastLevel) {
//         await db.update('questions', {'a': 0}); // Reset all levels
//         await db.update('questions', {'a': 1},
//             where: 'id = ?', whereArgs: [0]); // Unlock the first level
//       }

//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           backgroundColor: Colors.green,
//           title: Text('Correct!'),
//           content: Text('You have earned points!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 if (isLastLevel) {
//                   Navigator.of(context).popUntil(
//                       (route) => route.isFirst); // Go back to the main screen
//                 } else {
//                   Navigator.of(context).pop(true); // Return to levels screen
//                 }
//               },
//               child: Text('Back to Levels'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           backgroundColor: Colors.red,
//           title: Text('Incorrect!'),
//           content: Text('Your answer is incorrect.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 setState(() {
//                   emptyField = List.generate(answerChars.length,
//                       (index) => ""); // Reset the answer field
//                   charList.shuffle(); // Shuffle characters
//                   firstEmptyIndex = 0; // Reset the index
//                 });
//               },
//               child: Text('Retry'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).popUntil(
//                     (route) => route.isFirst); // Go back to the main screen
//               },
//               child: Text('Go to Main'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   List<List<int>> hidingIndex = [];
//   late Timer qTimer;
//   int _timer = 0;
//   FlutterTts flutterTts = FlutterTts();

//   startTimer() {
//     qTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _timer++;
//       });
//     });
//   }

//   playWord() async {
//     await flutterTts.speak(widget.question['answer']);
//   }

//   @override
//   void initState() {
//     charList.shuffle();
//     startTimer();
//     playWord();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     qTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final questionProvider = Provider.of<QuestionProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Level ${widget.level}"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () async {
//               await questionProvider.resetGame();
//               Navigator.of(context).popUntil((route) =>
//                   route.isFirst); // Return to main screen after reset
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Text(widget.question['question']),
//           Wrap(
//             spacing: 4.0,
//             children: charList.map((char) {
//               return ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     if (firstEmptyIndex < answerChars.length) {
//                       emptyField[firstEmptyIndex] = char;
//                       checkIfFull(context);
//                     }
//                   });
//                 },
//                 child: Text(char),
//               );
//             }).toList(),
//           ),
//           Row(
//             children: emptyField.map((char) {
//               return Container(
//                 width: 40,
//                 height: 40,
//                 color: Colors.grey,
//                 margin: EdgeInsets.all(4.0),
//                 child: Center(
//                   child: Text(char),
//                 ),
//               );
//             }).toList(),
//           ),
//           Text("Timer: $_timer seconds"),
//         ],
//       ),
//     );
//   }
// }
