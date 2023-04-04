import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_app/model/todo_model.dart';

class FirebaseProvider extends ChangeNotifier{

  var toDo = TodoModel();
  var toDoList = List<TodoModel>.empty(growable: true);
  var isLoading = false;
  var businessCount = 0;
  var personalCount = 0 ;
  DateFormat format = DateFormat("hh:mm a");
  DateFormat formatter = DateFormat("dd/MM/yyyy–hh:mm a");

  String? get currentUserName{
    return currentUser?.displayName;
  }

  int get getPersonalCount{
    personalCount = 0;
    for(int i = 0 ; i < toDoList.length;i++){
      if(toDoList.elementAt(i).category == "Personal"){
        personalCount++;
      }
    }
    return personalCount;
  }

  int get getBusinessCount{
    businessCount = 0;
    for(int i = 0 ; i < toDoList.length;i++){
      if(toDoList.elementAt(i).category == "Business"){
        businessCount++;
      }
    }
    return businessCount;
  }

  int get getCompletedCount{
   return toDoList.where((element) => (element.isSelected)
    ).toList().length;
  }

  User? get currentUser{
    return FirebaseAuth.instance.currentUser;
    }

  String? get getFirebaseUserId{
   return currentUser?.uid;
  }

  double get getCompleteProgress{
    double completeProgress= getCompletedCount/toDoList.length;
    if(completeProgress.isNaN){
      return 0.0;
    }
    return completeProgress;
  }

  int get getCompleteProgressInPercent{
      double completeProgress= getCompletedCount/toDoList.length;
      if(!completeProgress.isNaN) {
        return (double.parse(completeProgress.toStringAsFixed(2)) * 100)
            .toInt();
      }
      return 0;
}

  Future<bool> addToDoToFirebase(String category,String toDo,String place,String time,bool isComplete) async {
      try{
        String? uid = getFirebaseUserId;
        if(uid !=null) {
          CollectionReference user = FirebaseFirestore.instance.collection(uid);
            user.add({
              'category': category,
              'todo': toDo,
              'place': place,
              'time': time,
              'todoId':randomAlphaNumeric(5),
              'isComplete':isComplete
            });
            return true;
        }
      } catch (error) {
        print(error.toString());
      }finally{
        notifyListeners();
      }
      return false;
  }

  Future<void> getTodos() async {
    isLoading= true;
    try {
        String? uid = getFirebaseUserId;
        if (uid != null) {
          //FirebaseFirestore.instance.collection(uid).orderBy("asc");
          CollectionReference user = FirebaseFirestore.instance.collection(uid);
          QuerySnapshot querySnapshot = await user.get();
          List<Map<String, dynamic>?> documentData = querySnapshot.docs.map((e) => e.data() as Map<String, dynamic>?).toList();
          toDoList.clear();
          for (int i = 0; i < documentData.length; i++) {
            toDoList.add(TodoModel(category:  documentData[i]!['category'],
              todo: documentData[i]!['todo'],
                place: documentData[i]!['place'],//format.format(formatter.parse(documentData[i]!['time'])
              time: documentData[i]!['time'],
            todoId:documentData[i]!['todoId'],
              isSelected:documentData[i]!['isComplete'],
            ));
          }
        }

    }catch (e) {
      print(e.toString());
    }finally {
      isLoading= false;
      notifyListeners();
    }
  }

  Future<bool> editTodo(String category,String toDo,String place,String time,String id,bool isComplete) async {
    try{
      String? uid = getFirebaseUserId;
      if(uid !=null) {

        CollectionReference user = FirebaseFirestore.instance.collection(uid);
        QuerySnapshot querySnapshot = await user.get();
        List<String> docIds = querySnapshot.docs.map((doc) => doc.id).toList();
        for(int i = 0 ; i< toDoList.length;i++){
          if(id == toDoList.elementAt(i).todoId){
            FirebaseFirestore.instance.collection(uid).doc(docIds[i]).update({
              'category': category,
              'todo': toDo,
              'place': place,
              'time': time,
              'isComplete':isComplete
            }).then((value) => print("updated note")).catchError((error)=>print("Something went wrong"));
            return true;
          }
        }

      }
    } catch (error) {
      print(error.toString());
    }finally{
      notifyListeners();
    }
    return false;
  }

  Future<void> deleteNote(BuildContext context,String id) async{
    String? uid =getFirebaseUserId;
    if(uid !=null && toDoList.isNotEmpty){
      CollectionReference user = FirebaseFirestore.instance.collection(uid);
      QuerySnapshot querySnapshot = await user.get();
      List<String> docIds = querySnapshot.docs.map((doc) => doc.id).toList();

      for(int i = 0 ; i< toDoList.length;i++){
        if(id == toDoList.elementAt(i).todoId){
          FirebaseFirestore.instance
              .collection(uid)
              .doc(docIds[i])
              .delete();
          toDoList.removeAt(i);
          Navigator.of(context).pop();
          notifyListeners();
        }
      }
      }
    }

  void signOut() async {
    final googleSignIn = GoogleSignIn();
    FirebaseAuth.instance.signOut().then((_) async => {
      toDoList.clear(),
      //To show the google sign in sheet again.
      //If the below line is not added,
      //it will sign in the user with previously selected email id
      //whenever user sign's in again
      await googleSignIn.signOut(),
    });
  }
}