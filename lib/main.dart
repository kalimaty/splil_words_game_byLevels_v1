import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'questions.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE questions(id INTEGER PRIMARY KEY, question TEXT, answer TEXT, a INTEGER, answerOrder INTEGER)",
      );
    },
    version: 1,
  );
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestionProvider(database)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Word Game',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelsPage()),
                );
              },
              child: Text(
                'Levels',
                style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultsPage()),
                );
              },
              child: Text(
                'Results',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class LevelsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final questionProvider = Provider.of<QuestionProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Levels'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: questionProvider.getQuestions(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           final questions = snapshot.data!;
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5),
//             itemCount: questions.length,
//             itemBuilder: (context, index) {
//               bool isUnlocked = index == 0 || questions[index - 1]['a'] == 1;
//               return GestureDetector(
//                 onTap: isUnlocked
//                     ? () async {
//                         var result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => QuestionPage(
//                               level: index + 1,
//                               question: questions[index],
//                             ),
//                           ),
//                         );
//                         if (result != null) {
//                           questionProvider.refreshQuestions();
//                         }
//                       }
//                     : null,
//                 child: Card(
//                   color: questions[index]['a'] == 1
//                       ? Colors.green
//                       : isUnlocked
//                           ? Colors.white
//                           : Colors.grey,
//                   child: Center(
//                     child: Text("${index + 1}"),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class LevelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Levels'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionProvider.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final questions = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              bool isUnlocked = index == 0 || questions[index - 1]['a'] == 1;
              return GestureDetector(
                onTap: isUnlocked
                    ? () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionPage(
                              level: index + 1,
                              question: questions[index],
                            ),
                          ),
                        );
                        if (result != null) {
                          questionProvider.refreshQuestions();
                        }
                      }
                    : null,
                child: Card(
                  color: questions[index]['a'] == 1
                      ? Colors.green
                      : isUnlocked
                          ? Colors.white
                          : Colors.grey,
                  child: Center(
                    child: Text("${index + 1}"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// class ResultsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final questionProvider = Provider.of<QuestionProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Results'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: questionProvider.getQuestions(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           final questions = snapshot.data!;
//           return ListView.builder(
//             itemCount: questions.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text("Level ${index + 1}"),
//                 subtitle: Text("Word: ${questions[index]['answer']}"),
//                 trailing: Icon(
//                   questions[index]['a'] == 1 ? Icons.check : Icons.close,
//                   color: questions[index]['a'] == 1 ? Colors.green : Colors.red,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionProvider.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final questions = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Level ${index + 1}"),
                      subtitle: Text("Word: ${questions[index]['answer']}"),
                      trailing: Icon(
                        questions[index]['a'] == 1 ? Icons.check : Icons.close,
                        color: questions[index]['a'] == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await questionProvider.resetGame();
                },
                child: Text('Reset Game'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class QuestionProvider extends ChangeNotifier {
  final Future<Database> _database;
  List<Map<String, dynamic>> _questions = [];

  QuestionProvider(this._database);

  Future<void> initDatabase() async {
    final db = await _database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM questions'),
    );

    if (count == 0) {
      var q = Questions.questions;
      q.shuffle();
      for (var question in q) {
        await db.insert('questions', question);
      }
    }

    await refreshQuestions();
  }

  Future<void> refreshQuestions() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('questions');
    _questions = maps;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    if (_questions.isEmpty) {
      await initDatabase();
    }
    return _questions;
  }

  Future<void> resetGame() async {
    final db = await _database;
    await db.transaction((txn) async {
      for (var question in _questions) {
        await txn.update('questions', {'a': 0},
            where: 'id = ?', whereArgs: [question['id']]);
      }
    });
    await refreshQuestions();
  }
}

// class QuestionProvider extends ChangeNotifier {
//   final Future<Database> _database;
//   List<Map<String, dynamic>> _questions = [];

//   QuestionProvider(this._database);

//   Future<void> initDatabase() async {
//     final db = await _database;
//     final count = Sqflite.firstIntValue(
//       await db.rawQuery('SELECT COUNT(*) FROM questions'),
//     );

//     if (count == 0) {
//       var q = Questions.questions;
//       q.shuffle();
//       for (var question in q) {
//         await db.insert('questions', question);
//       }
//     }

//     await refreshQuestions();
//   }

//   Future<void> refreshQuestions() async {
//     final db = await _database;
//     final List<Map<String, dynamic>> maps = await db.query('questions');
//     _questions = maps;
//     notifyListeners();
//   }

//   Future<List<Map<String, dynamic>>> getQuestions() async {
//     if (_questions.isEmpty) {
//       await initDatabase();
//     }
//     return _questions;
//   }

//   Future<void> resetQuestions() async {
//     final db = await _database;
//     for (var question in Questions.questions) {
//       await db.update('questions', {'a': 0, 'answerOrder': 0},
//           where: 'id = ?', whereArgs: [question['id']]);
//     }
//     await refreshQuestions();
//   }

//   Future<void> resetGame() async {
//     final db = await _database;
//     for (var question in _questions) {
//       await db.update('questions', {'a': 0},
//           where: 'id = ?', whereArgs: [question['id']]);
//     }
//     await refreshQuestions();
//   }
// }

// class QuestionProvider extends ChangeNotifier {
//   final Future<Database> _database;
//   List<Map<String, dynamic>> _questions = [];

//   QuestionProvider(this._database);
// //  المفترض جدول الاسئلة  فارغ  نتاكد من ذلك لتعبئته بالاسئلة  وتخزينه فى داتا بيز
//   Future<void> initDatabase() async {
//     final db = await _database;
//     final count = Sqflite.firstIntValue(
//       await db.rawQuery('SELECT COUNT(*) FROM questions'),
//     );

//     if (count == 0) {
//       var q = Questions.questions;
//       q.shuffle();
//       for (var question in q) {
//         await db.insert('questions', question);
//       }
//     }

//     await refreshQuestions();
//   }

// //تقوم هذه الدالة بتحديث قائمة الأسئلة من قاعدة البيانات.
//   Future<void> refreshQuestions() async {
//     final db = await _database;
//     final List<Map<String, dynamic>> maps = await db.query('questions');
//     _questions = maps;
//     notifyListeners();
//   }

// //تقوم هذه الدالة بإرجاع قائمة الأسئلة.
//   Future<List<Map<String, dynamic>>> getQuestions() async {
//     if (_questions.isEmpty) {
//       await initDatabase();
//     }
//     return _questions;
//   }
// }

class Questions {
  static final List<Map<String, dynamic>> questions = [
    {
      "id": 0,
      "question": "question here 1 ?",
      "answer": "faisal",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 1,
      "question": "question here 2?",
      "answer": "moha",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 2,
      "question": "question here 3?",
      "answer": "samir",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 3,
      "question": "question here 4?",
      "answer": "ahmed",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 4,
      "question": "question here 5?",
      "answer": "omar",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 5,
      "question": "question here 6?",
      "answer": "adel",
      "a": 0,
      "answerOrder": 0
    },
    {
      "id": 6,
      "question": "question here 7?",
      "answer": "hany",
      "a": 0,
      "answerOrder": 0
    },
  ];
}

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
//   FlutterTts flutterTts = FlutterTts();
// // لتحديد المكان التالي الذي سيتم ملؤه عند إدخال حروف الاجابة
//   goToNext() {
//     setState(() {
//       //تحديث المتغير بقيمة جديدة
//       //فهرس اول خانة فارغة من قائمة   emptyField
//       firstEmptyIndex = emptyField.indexOf(
//           emptyField.firstWhere((element) => element == "", orElse: () => ""));
//     });
//   }

// //تقوم هذه الدالة بالتحقق من حالة الحقول الفارغة، وتحديد ما إذا كانت الإجابة مكتملة وصحيحة. إذا كانت الإجابة
// //مكتملة، تقوم بمعالجة الإجابة؛ وإذا لم تكن مكتملة، تقوم بتهيئة الحقل الفارغ التالي ليتم ملؤه.
//   checkIfFull(BuildContext context) {
//     if (emptyField.join().length < answerChars.length) {
//       goToNext();
//     } else {
//       checkIfCorrect();
//       markAsAnswer(context);
//     }
//   }

//   bool checkIfCorrect() {
//     return emptyField.join() == answerChars.join();
//   }

//   markAsAnswer(BuildContext context) async {
//     if (emptyField.join() == answerChars.join()) {
//       final db =
//           await Provider.of<QuestionProvider>(context, listen: false)._database;
//       await db.update('questions', {'a': 1},
//           where: 'id = ?', whereArgs: [widget.level - 1]);

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
//                 Navigator.of(context).pop(true); // Return to levels screen
//               },
//               child: Text('Back to Levels'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // markAsAnswer() async {
//   //   if (emptyField.join() == answerChars.join()) {
//   //     final db = await Provider.of<QuestionProvider>(context, listen: false)
//   //         ._database;
//   //     await db.update('questions', {'a': 1},
//   //         where: 'id = ?', whereArgs: [widget.level - 1]);
//   //     showDialog(
//   //         context: context,
//   //         builder: (context) => AlertDialog(
//   //               backgroundColor: Colors.green,
//   //               title: Text('Correct!'),
//   //               content: Text('You have earned points!'),
//   //               actions: [
//   //                 TextButton(
//   //                   onPressed: () {
//   //                     Navigator.of(context).pop();
//   //                     Navigator.of(context).pop(true);
//   //                   },
//   //                   child: Text('Back to Levels'),
//   //                 ),
//   //               ],
//   //             ));
//   //   }
//   // }

//   startTTS() async {
//     await flutterTts.speak(widget.question['answer']);
//   }

//   @override
//   void initState() {
//     charList.shuffle();
//     startTTS();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           Divider(),
//           Text(widget.question['question'],
//               style: Theme.of(context).textTheme.headline5),
//           Divider(),
//           GridView(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: answerChars.length),
//             children: List.generate(answerChars.length, (index) {
//               return GestureDetector(
//                 onTap: () {
//                   markAsAnswer(context);
//                   setState(() {
//                     emptyField[index] = "";
//                     firstEmptyIndex = index;
//                   });
//                   checkIfFull(context);
//                 },

//                 child: Card(
//                   color: () {
//                     if (checkIfCorrect()) {
//                       return Colors.green;
//                     } else if (emptyField.join().length == answerChars.length) {
//                       return Colors.red;
//                     } else if (emptyField[index] == "") {
//                       return Colors.grey;
//                     } else {
//                       return Colors.white;
//                     }
//                   }(),
//                   child: Center(
//                     child: Text(
//                       "${emptyField[index]}",
//                       style: TextStyle(
//                         color: () {
//                           if (checkIfCorrect() ||
//                               emptyField.join().length == answerChars.length) {
//                             return Colors.white;
//                           } else {
//                             return Colors.black;
//                           }
//                         }(),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // child: Card(
//                 //   color: checkIfCorrect()
//                 //       ? Colors.green
//                 //       : emptyField.join().length == answerChars.length
//                 //           ? Colors.red
//                 //           : emptyField[index] == ""
//                 //               ? Colors.grey
//                 //               : Colors.white,
//                 //   child: Center(
//                 //     child: Text(
//                 //       "${emptyField[index]}",
//                 //       style: TextStyle(
//                 //         color: checkIfCorrect() ||
//                 //                 emptyField.join().length == answerChars.length
//                 //             ? Colors.white
//                 //             : Colors.black,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               );
//             }),
//           ),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             gridDelegate:
//                 SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
//             itemCount: charList.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   if (emptyField.join().length < answerChars.length) {
//                     setState(() {
//                       emptyField[firstEmptyIndex] = charList[index];
//                       firstEmptyIndex = emptyField.indexOf(
//                           emptyField.firstWhere((element) => element == "",
//                               orElse: () => ""));
//                     });
//                   }
//                   checkIfFull(context);
//                 },
//                 child: Card(
//                   child: Center(
//                     child: Text(
//                       "${charList[index]}",
//                       style: Theme.of(context).textTheme.headline4,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class QuestionPage extends StatefulWidget {
  final int level;
  final Map<String, dynamic> question;

  const QuestionPage({Key? key, required this.level, required this.question})
      : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> allChars = "abcdefghijklmnopqrstuvwxyz".split("");
  late List<String> answerChars = widget.question['answer'].split("");
  late List<String> otherChars =
      List.generate(10 - answerChars.length, (index) {
    return allChars[Random().nextInt(allChars.length)];
  });
  late List charList = [...answerChars, ...otherChars];
  late var emptyField =
      List.generate(answerChars.length, (index) => "").toList();
  int firstEmptyIndex = 0;
  FlutterTts flutterTts = FlutterTts();

  goToNext() {
    setState(() {
      firstEmptyIndex = emptyField.indexOf(
          emptyField.firstWhere((element) => element == "", orElse: () => ""));
    });
  }

  checkIfFull(BuildContext context) {
    if (emptyField.join().length < answerChars.length) {
      goToNext();
    } else {
      checkIfCorrect();
      markAsAnswer(context);
    }
  }

  bool checkIfCorrect() {
    return emptyField.join() == answerChars.join();
  }

  markAsAnswer(BuildContext context) async {
    if (emptyField.join() == answerChars.join()) {
      final db =
          await Provider.of<QuestionProvider>(context, listen: false)._database;
      await db.update('questions', {'a': 1},
          where: 'id = ?', whereArgs: [widget.level - 1]);

      bool isLastLevel = widget.level == Questions.questions.length;

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Correct!'),
          content: Text('You have earned points!'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(true); // Return to levels screen

                if (isLastLevel) {
                  await Provider.of<QuestionProvider>(context, listen: false)
                      .resetGame();
                }
              },
              child: Text('Back to Levels'),
            ),
          ],
        ),
      );
    }
  }

  startTTS() async {
    await flutterTts.speak(widget.question['answer']);
    print(widget.question['answer']);
  }

  @override
  void initState() {
    charList.shuffle();
    startTTS();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Divider(),
          Text(widget.question['question'],
              style: Theme.of(context).textTheme.headline5),
          Divider(),
          GridView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: answerChars.length),
            children: List.generate(answerChars.length, (index) {
              return GestureDetector(
                onTap: () {
                  markAsAnswer(context);
                  setState(() {
                    emptyField[index] = "";
                    firstEmptyIndex = index;
                  });
                  checkIfFull(context);
                },
                child: Card(
                  color: () {
                    if (checkIfCorrect()) {
                      return Colors.green;
                    } else if (emptyField.join().length == answerChars.length) {
                      return Colors.red;
                    } else if (emptyField[index] == "") {
                      return Colors.grey;
                    } else {
                      return Colors.white;
                    }
                  }(),
                  child: Center(
                    child: Text(
                      "${emptyField[index]}",
                      style: TextStyle(
                        color: () {
                          if (checkIfCorrect() ||
                              emptyField.join().length == answerChars.length) {
                            return Colors.white;
                          } else {
                            return Colors.black;
                          }
                        }(),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemCount: charList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (emptyField.join().length < answerChars.length) {
                    setState(() {
                      emptyField[firstEmptyIndex] = charList[index];
                      firstEmptyIndex = emptyField.indexOf(
                          emptyField.firstWhere((element) => element == "",
                              orElse: () => ""));
                    });
                  }
                  checkIfFull(context);
                },
                child: Card(
                  child: Center(
                    child: Text(
                      "${charList[index]}",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
