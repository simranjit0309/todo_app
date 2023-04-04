import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/firebase_provider.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list_item.dart';

class ToDoListScreen extends StatelessWidget {
  DateFormat dateFormat = DateFormat("MMM d, yyyy");

  ToDoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Provider.of<FirebaseProvider>(context, listen: false).getTodos();

    return SafeArea(
      child: Scaffold(
          body: Consumer<FirebaseProvider>(
              builder: (_, user, child) => Column(children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/images/banner_image.jpg"),
                        fit: BoxFit.cover,
                      )),
                      width: width,
                      height: height * 0.28,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(context: context, builder: (ctx)=>AlertDialog( // <-- SEE HERE
                                  title: const Text('Logout'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text('Are you sure want to logout?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        user.signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginScreen()
                                            ),
                                            ModalRoute.withName("/login_screen")
                                        );
                                      },
                                    ),
                                  ],
                                ));
                              },
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  user.currentUserName ?? "",
                                  style: const TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(user.getPersonalCount.toString() ?? "",
                                      style: const TextStyle(fontSize: 24.0, color: Colors.white)),
                                  const SizedBox(height: 4,),
                                  Text("Personal",
                                      style: TextStyle(fontSize: 14.0, color: Colors.white.withOpacity(0.6)))
                                ],
                              ),
                              const SizedBox(width: 6.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(user.getBusinessCount.toString() ?? "", style: TextStyle(fontSize: 24.0, color: Colors.white)),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text("Business", style: TextStyle(fontSize: 14.0, color: Colors.white.withOpacity(0.6)))
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(dateFormat.format(DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xffd7ddf5))),
                              Spacer(),
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Color(0xff2ebaee),
                                  value: user.getCompleteProgress,
                                  backgroundColor: Color(0xff46529d),
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text("${user.getCompleteProgressInPercent}% Done",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Color(0xffd7ddf5)))
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: user.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          :user.toDoList.isEmpty?Center(child:Text("No Todo Found",style: TextStyle(
                        fontSize: 16.0
                      ),)): Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("INBOX",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xffa7aab9),
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0, bottom: 12.0),
                                          child: InkWell(
                                              onTap: () {
                                                var provider =
                                                    Provider.of<ToDoProvider>(
                                                        context,
                                                        listen: false);
                                                var toDoData = user.toDoList.elementAt(index);
                                                provider.toDoTextController.text = toDoData.todo!;
                                                provider.placeTextController.text = toDoData.place!;
                                                provider.selectedTime = toDoData.time!;
                                                provider.selectedItem = toDoData.category!;
                                                provider.isSelected = toDoData.isSelected;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddTodoScreen(false,
                                                            toDoData.todoId!),
                                                  ),
                                                );
                                              },
                                              child: TodoListItem(user.toDoList
                                                  .elementAt(index))),
                                        );
                                      },
                                      itemCount: user.toDoList.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: width,
                                          height: 0.5,
                                          color: const Color(0xffcbcede),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text("COMPLETED",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Color(0xffa7aab9),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffa7aab9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                          ),
                                          child: Text(
                                            user.getCompletedCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),textAlign: TextAlign.center,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                    )
                  ])),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var provider = Provider.of<ToDoProvider>(context, listen: false);
              provider.toDoTextController.text = "";
              provider.placeTextController.text = "";
              provider.selectedTime = "";
              provider.selectedItem = "Business";
              provider.isSelected = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodoScreen(true)),
              );
            },
            backgroundColor: const Color(0xff2ebaee),
            child: const Icon(
              Icons.add,
              size: 32,
            ),
          )),
    );
  }
}
