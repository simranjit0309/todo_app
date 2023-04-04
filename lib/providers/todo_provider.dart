import 'package:flutter/material.dart';

class ToDoProvider extends ChangeNotifier{
  final List<String> categoriesDropdownList = ['Business','Personal'];
  var selectedItem = "Business";
  var toDoTextController = TextEditingController();
  var placeTextController = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  String selectedTime = "";
  bool isSelected = false;

  bool validateUserInputData(){
    if(selectedTime.isNotEmpty&&toDoTextController.text.isNotEmpty&&placeTextController.text.isNotEmpty){
      return true;
    }
    return false;
  }


  void showToDoCancel() {
    notifyListeners();
  }

  void showPlaceCancel() {
    notifyListeners();
  }


  setCategoryValue(value){
    selectedItem = value;
    notifyListeners();
  }


  void selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(

      context: context,
      initialTime: time,
    );
    if(newTime!=null){
      time = newTime;
      print("time:"+time.toString());
      selectedTime = time.format(context);
      print("selected time:"+selectedTime.toString());
      notifyListeners();
    }

  }

  void clearSelectedTime(){
   selectedTime = "";
   notifyListeners();
  }

  void clearToDoText(){
    toDoTextController.text = "";
    notifyListeners();
  }

  void clearPlaceText(){
    placeTextController.text = "";
    notifyListeners();
  }
  void updateCheckbox(bool value){
    isSelected = value;
    notifyListeners();
  }

  void clearAllData(){
    toDoTextController.text = "";
    placeTextController.text = "";
    selectedTime = "";
    selectedItem = "Business";
  }
}