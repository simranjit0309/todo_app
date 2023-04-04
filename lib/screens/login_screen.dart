import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/screens/todo_list_screen.dart';

class LoginScreen extends StatelessWidget{

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;


  Future googleLogin(BuildContext context) async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;

    user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try{
      await FirebaseAuth.instance.
      signInWithCredential(credential).then((value) {
        if(value.user !=null){
          Navigator.of(context).pushReplacementNamed('/to_do_list');
        }
      });
    }catch(e){
      print(e.toString());
    }
    print(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0),
          width: MediaQuery.of(context).size.width,
          color: const Color(0xff46529d),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image.asset("assets/images/todo_image.png",width: 250,height: 250,),
              ),
              const SizedBox(height: 30,),
              const Text("TODO APP",style: TextStyle(fontSize: 24.0,color:  Colors.white),),
              const SizedBox(height: 30,),
              const Text("To continue, sign in with google",style: TextStyle(fontSize: 16.0,color:  Colors.white),),
              const SizedBox(height: 30.0,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red,primary: Colors.red,
                    onPrimary: Colors.red,
                    minimumSize: const Size(double.infinity,50)
                ),
                icon: const FaIcon(FontAwesomeIcons.google,color: Colors.white,),
                onPressed: (){
                  googleLogin(context);
                }, label:const Text("Google",style:TextStyle(color: Colors.white)),)
            ],
          ),
        ),
      ),
    );
  }

}