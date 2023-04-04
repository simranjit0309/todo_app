import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import 'package:todo_app/providers/firebase_provider.dart';
import 'package:todo_app/screens/main_page.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'screens/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<FirebaseProvider>(
        create: (_) => FirebaseProvider(),
      ),
      ChangeNotifierProvider<ToDoProvider >(
        create: (_) => ToDoProvider() ,
      ),
    ],child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'sofiapro'),
      title: 'To-Do App',
      home:  const MainPage(),
      routes: {
        '/login_screen':(ctx) =>  LoginScreen(),
        '/to_do_list':(ctx) =>  ToDoListScreen(),
        '/add_to_do':(ctx) =>  AddTodoScreen(false),
      },
    ));
  }
}

