import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoListItem extends StatelessWidget{
  TodoModel todoModel;
  TodoListItem(this.todoModel, {super.key});
  DateFormat format = DateFormat("hh:mm a");
  DateFormat formatter = DateFormat("dd/MM/yyyy–hh:mm a");

  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding:
          const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: todoModel.isSelected?Colors.greenAccent: const Color(0xffcbcede)
              ),
              borderRadius: const BorderRadius.all(Radius.circular(32))),
            child: Image.asset(todoModel.category =="Personal"?"assets/images/personal.png":"assets/images/business.png",height: 32,width : 32,),),
        const SizedBox(width: 10.0,),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width*0.5,
                child: Text(todoModel.todo! ,style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w600),softWrap: true,maxLines: 2,)),
            const SizedBox(height: 5.0,),
            Text(todoModel.place!,style: const TextStyle(fontSize: 14.0,color:  Color(0xffa7aab9)),),
          ],
        ),
        const Spacer(),
        Text(todoModel.time!,style: const TextStyle(fontSize: 10.0,color:  Color(0xffa7aab9)),)
      ],
    );
  }

}