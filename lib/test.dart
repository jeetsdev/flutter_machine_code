// // Code review interview context

// // You need to review a Flutter social network app. You need to perform the code review in 40 mins. For simplicity, the PR is shared in a Google doc.
// // Consider that this PR is raised by less experienced developers. They should be able to learn from your comments.
// // Like any real PR, there are some minor and some major issues. Major issues will have more weight in the scoring of the code review round.
// // You can do whatever you would normally do while performing code review like:
// // Askimaing a question.
// // Suggesting improvements / alternate ways of writing code.
// // Share a link to specs, documentation, guideline, blog, video, etc.
// // You can use the internet like you would do while performing a code review. However, please be mindful of the 40 mins time limit.
// // Take those concerns into consideration: scalability, accessibility, testability, SOLID, state management, localization readiness
// // Pro tip: Try to add comments as you go instead of adding all the comments towards the end.


// lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/src/bloc_provider.dart';
// import 'package:flutter_bloc/src/bloc_builder.dart';

// import './logic.dart';

// class SocialNetwork extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => BlocProvider.value(
//         value: SocialBloc(),
//         child: MaterialApp(
//           title: 'Flutter refactoring test',
//           theme: ThemeData(primarySwatch: Colors.blue),
//           home: BlocBuilder<SocialBloc, SocialState>(
//             builder: (context, state) => SafeArea(
//               child: Scaffold(
//                 appBar: AppBar(title: Text('Social Network App 🌐')),
//                 body: MessageScreen(),
//               ),
//            ),
//          ),
//       );
// }

// class MessageScreen extends StatefulWidget {
//   MessageScreen();

//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     TextEditingController _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
// _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.watch<SocialBloc>();
//     return FutureBuilder(
//       future: bloc.getMessages(),
//       builder: (context, snapshot) => snapshot.hasData && bloc.state is LoadedSocialState
//           ? Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     children: (snapshot.data as List<Message>)
//                         .map((e) => GestureDetector(
//                             onTap: () {},
//                             child: Column(
//                               children: [
//                                 Text(e.content,
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Text('Message ID: ${e.id}',
//                                     style: TextStyle(
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.w300)),
//                               ],
//                             )))
//                         .toList(),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _controller,
//                           decoration: InputDecoration(hintText: 'Write a message...'),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: () {
//                           if (_controller.text.isNotEmpty) {
//                             bloc.postMessage(_controller.text);
//                             _controller.clear();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           : Container(
//               child: Center(
//                   child: Text('Loading', style: TextStyle(fontSize: 14))),
//             ),
//     );
//   }
// }

// abstract class SocialState {}

// class LoadingSocialState extends SocialState {}

// class LoadedSocialState implements SocialState {}

// class SocialBloc extends Cubit<SocialState> {
//   SocialBloc()
//       : api = SocialApi(),
//         super(LoadedSocialState());

//   @visibleForTesting
//   SocialApi api;

//   Future<List<Message>> getMessages() {
//     emit(LoadingSocialState());
//     return api.getMessages()..then((_) => emit(LoadedSocialState()));
//   }

//   Future<void> postMessage(String content) => api.postMessage(content);
// }



// class SocialApi {


//   static const _apiKey = String.fromEnvironment('API_KEY',
//       defaultValue: '7586eda0-4c0c-435b-bce8-0bfd7b536966');

//   Future<List<Message>> getMessages() async {
//     final response =
//         await http.get(Uri.parse('https://api.example.com/messages?key=$_apiKey'));
//     final rawList = jsonDecode(response.body) as List<dynamic>;
//     return rawList.map((s) => Message(s['id'], s['content'])).toList();
//   }

//   Future<void> postMessage(String content) async {
//     await http.post(Uri.parse('https://api.example.com/messages?key=$_apiKey'),
//         body: jsonEncode({'content': content}));
//   }
// }

// class Message {
//   Message(this.id, this.content);

//   String id;
//   String content;
// }

