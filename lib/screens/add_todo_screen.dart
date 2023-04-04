import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/firebase_provider.dart';
import '../providers/todo_provider.dart';



class AddTodoScreen extends StatelessWidget{

   String todoText = '';
   String category = '';
   String place = '';
   String time = '';
   String? toId = '';
   bool isAddTodo = false;


   AddTodoScreen(this.isAddTodo,[this.toId]);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
   return SafeArea(
     child: Scaffold(
       body: Container(
         height: height,
         padding: const EdgeInsets.all(12.0),
         color: const Color(0xff46529d),
         child: SingleChildScrollView(
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children:  [
                    InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,size: 28,color: Color(0xff33a7df),)),
                    Text(!isAddTodo?'Edit your TODO':"Add new TODO",style: TextStyle(fontSize: 16.0,color: Colors.white)),
                   Visibility(
                     visible: !isAddTodo,
                     child: InkWell(
                         onTap:(){
                           Provider.of<FirebaseProvider>(context,listen: false).deleteNote(context,toId!);
                         },
                         child: Icon(Icons.delete,size: 28,color: Color(0xff33a7df))),
                   )
                 ],
               ),
               const SizedBox(height: 14.0,),
                Container(
                    alignment: Alignment.center,
                    width: 65,
                    height: 65,
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.all(
                      Radius.circular(35)),
                        border: Border.all(
                        width: 1,
                        color: const Color(0xff5d67a9)
                  ),
             ),child: Image.asset("assets/images/to_do_list.png",height: 44,width : 44,color: Color(0xff33a7df))),
               const SizedBox(height: 14.0,),
               Container(
                 padding: const EdgeInsets.fromLTRB(6.0,6.0,6.0,0.0),
                 child: Column(
                   children: [
                     Consumer<ToDoProvider>(builder: (ctx,toDoProvider,_){
                         if(isAddTodo){
                           time = toDoProvider.time.format(context);
                         }else{
                           final format = DateFormat.jm();
                           if(toDoProvider.selectedTime.isNotEmpty) {
                             if(time.isEmpty) {
                               var timeOfDay = TimeOfDay.fromDateTime(format.parse(toDoProvider.selectedTime));
                               time = timeOfDay.format(context);
                             }
                           }
                         }

                       return  Column(
                         children: [
                           DropdownButton<String>(
                               dropdownColor: const Color(0xff5d67a9),
                               isExpanded: true,
                               alignment: Alignment.centerRight,
                               icon: const Icon(Icons.arrow_drop_down_sharp,size: 28,color: Color(0xff5d67a9),),
                               underline: Container(
                                 height: 1.5,
                                 color: const Color(0xff5d67a9),
                               ),
                               value: toDoProvider.selectedItem,
                               items: toDoProvider.categoriesDropdownList.map<DropdownMenuItem<String>>((String value){
                                 return DropdownMenuItem(
                                   value: value,
                                   child: Text(
                                       value,style: const TextStyle(fontSize: 16.0,color: Colors.white)
                                   ),
                                 );
                               }).toList(),
                               onChanged: (value){
                                 toDoProvider.setCategoryValue(value);
                               }),
                           const SizedBox(height: 6.0,),
                           SizedBox(
                             height: 34,
                             child:TextField(
                               onChanged: (value){
                                 toDoProvider.showToDoCancel();
                                 //print(toDoProvider.toDoText);
                               },
                               decoration: InputDecoration(
                                 contentPadding: EdgeInsets.zero,
                                 suffixIcon: Visibility(
                                   visible: toDoProvider.toDoTextController.text.isNotEmpty,
                                   child: InkWell(
                                     onTap:(){
                                       toDoProvider.clearToDoText();
                                     },
                                     child: const Padding(
                                       padding: EdgeInsets.only(left: 20.0),
                                       child: Icon(Icons.cancel,color:  Color(0xff5d67a9),),
                                     ),
                                   ),
                                 ),
                                 hintText: "Todo",
                                 hintStyle: const TextStyle(color: Color(0xff5d67a9),fontSize: 16.0,),
                                 counterText: "",
                                 enabledBorder: const UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xff5d67a9),width: 1.5),
                                 ),
                                 focusedBorder: const UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xff5d67a9),width: 1.5),
                                 ),
                               ),
                               style: TextStyle(fontSize: 16.0,color: Colors.white),
                               controller: toDoProvider.toDoTextController,
                               maxLines: 1,
                               maxLength: 30,
                             ),
                           ),
                           const SizedBox(height: 18.0,),
                           SizedBox(
                             height: 34,
                             child:TextField(
                               onChanged: (value){
                                 toDoProvider.showPlaceCancel();
                               },
                               decoration: InputDecoration(
                                 contentPadding: EdgeInsets.zero,
                                 suffixIcon: Visibility(
                                   visible: toDoProvider.placeTextController.text.isNotEmpty,
                                   child: InkWell(
                                     onTap:(){
                                       toDoProvider.clearPlaceText();
                                     },
                                     child: const Padding(
                                       padding: EdgeInsets.only(left: 20.0),
                                       child: Icon(Icons.cancel,color:  Color(0xff5d67a9),),
                                     ),
                                   ),
                                 ),
                                 hintText: "Place",
                                 hintStyle: const TextStyle(color: Color(0xff5d67a9),fontSize: 16.0,),
                                 counterText: "",
                                 enabledBorder: const UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xff5d67a9),width: 1.5),
                                 ),
                                 focusedBorder: const UnderlineInputBorder(
                                   borderSide: BorderSide(color: Color(0xff5d67a9),width: 1.5),
                                 ),
                               ),
                               style: TextStyle(fontSize: 16.0,color: Colors.white),
                               maxLines: 1,
                               maxLength: 30,
                               controller: toDoProvider.placeTextController,
                             ),
                           ),
                           const SizedBox(height: 18.0,),
                           Container(
                             height: 34,
                             decoration: const BoxDecoration(
                               border: Border(
                                 bottom: BorderSide(width: 1.5, color: Color(0xff5d67a9)),
                               ),
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 InkWell(
                                     onTap:(){
                                       FocusManager.instance.primaryFocus?.unfocus();
                                       toDoProvider.selectTime(context);
                                     },
                                     child: SizedBox(
                                       width: width-100,
                                         child:  Text(toDoProvider.selectedTime.isNotEmpty?toDoProvider.selectedTime:"Time",
                                             style: TextStyle(color: toDoProvider.selectedTime.isNotEmpty?Colors.white:Color(0xff5d67a9),fontSize: 16.0,)))),
                                 Visibility(
                                   visible: toDoProvider.selectedTime.isNotEmpty,
                                   child: InkWell(
                                     onTap: (){
                                       toDoProvider.clearSelectedTime();
                                     },
                                     child: const Padding(
                                       padding: EdgeInsets.only(left: 20.0),
                                       child: Icon(Icons.cancel,color:  Color(0xff5d67a9),),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                          ),
                           const SizedBox(height: 12.0,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Is Task Completed",style: TextStyle(fontSize: 16.0,color: Colors.white),),
                               Checkbox(
                                 checkColor: Colors.white,
                                 activeColor: Colors.greenAccent,
                                 value: toDoProvider.isSelected,
                                 onChanged: (value) {
                                   toDoProvider.updateCheckbox(value!);
                                   print(value);
                                 },
                               ),
                             ],
                           )
                         ],

                       );
                     },
                     ),
                     InkWell(
                       onTap:(){
                         var todoProvider = Provider.of<ToDoProvider>(context,listen: false);
                         bool isDataVaildated =todoProvider.validateUserInputData();
                        if(isDataVaildated){
                          print("after valid time:"+todoProvider.selectedTime);
                          if( !isAddTodo){
                            Provider.of<FirebaseProvider>(context,listen: false).editTodo(
                                todoProvider.selectedItem,todoProvider.toDoTextController.text,todoProvider.placeTextController.text,todoProvider.selectedTime,toId!,todoProvider.isSelected).then((value) => {
                              if(value){
                                Provider.of<ToDoProvider>(context,listen: false).clearAllData(),
                                Navigator.of(context).pop(),
                                Provider.of<FirebaseProvider>(context,listen: false).getTodos(),
                              }
                            });
                          }else{
                            Provider.of<FirebaseProvider>(context,listen: false).addToDoToFirebase(
                                todoProvider.selectedItem,todoProvider.toDoTextController.text,todoProvider.placeTextController.text,todoProvider.time.format(context),todoProvider.isSelected).then((value) => {
                              if(value){
                                Provider.of<ToDoProvider>(context,listen: false).clearAllData(),
                                Navigator.of(context).pop(),
                                Provider.of<FirebaseProvider>(context,listen: false).getTodos(),
                              }
                            });
                          }

                        }else{

                            final snackBar = SnackBar(
                              content: const Text('one or more fields are missing'),
                                  backgroundColor: Color(0xff2ebaee),
                              duration: Duration(seconds: 1),
                                  );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                       },
                       child: Container(
                           decoration: const BoxDecoration(boxShadow: [
                             BoxShadow(
                                 color: Color(0x26000000),
                                 offset: Offset(0, 5),
                                 blurRadius: 4,
                                 spreadRadius: 0)
                           ],color: Color(0xff2ebaee),
                             borderRadius: BorderRadius.all(
                                 Radius.circular(
                                     4.0)),

                           ),
                           width: width,
                           height: 50,
                           alignment: Alignment.center,
                           child:  Text(!isAddTodo?'EDIT YOUR TODO':'ADD YOUR TODO ',
                               style: const TextStyle(
                                   color: Colors.white,
                                   fontWeight: FontWeight.w600,
                                   fontFamily: "Roboto",
                                   fontStyle: FontStyle.normal,
                                   fontSize: 12.5),
                               textAlign: TextAlign.center)),
                     ),
                   ],
                 )
               ),

             ],
           ),
         ),
       ),
     ),
   );
  }

}