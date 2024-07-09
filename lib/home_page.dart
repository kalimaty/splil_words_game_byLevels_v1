// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'question_page.dart';
// import 'question_provider.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final questionProvider = Provider.of<QuestionProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Levels'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () async {
//               await questionProvider.resetGame();
//             },
//           ),
//         ],
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
//           if (questions.isEmpty) {
//             return Center(child: Text("No questions available."));
//           }

//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 5,
//             ),
//             itemCount: questions.length,
//             itemBuilder: (context, index) => GestureDetector(
//               onTap: () async {
//                 var result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QuestionPage(
//                       level: index + 1,
//                       question: questions[index],
//                     ),
//                   ),
//                 );
//                 if (result != null) {
//                   questionProvider.refreshQuestions();
//                 }
//               },
//               child: Card(
//                 color: questions[index]['a'] == 1 ? Colors.green : Colors.grey,
//                 child: Center(
//                   child: Text("${index + 1}"),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
