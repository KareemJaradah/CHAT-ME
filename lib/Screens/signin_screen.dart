import 'package:chat_me/Screens/chat_screen.dart';
import 'package:chat_me/widgets/my_buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInScreen extends StatefulWidget {
  static const String screenRoute='signin_screen';

const SignInScreen ({ Key? key }) : super (key: key);

@override

_SignInScreenState createState() => _SignInScreenState();

}
class _SignInScreenState extends State<SignInScreen> {
  final _auth=FirebaseAuth.instance;
  late String email;
late String Password;
bool showSpinner=false;

@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white,
  body: ModalProgressHUD(
        inAsyncCall: showSpinner,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
      Column(
      children: [
        Container(
          height: 180,
          child: Image.asset('lib/images/chat.png'),
        ),
        Text(
          'Contact Me',
          style: TextStyle(
            fontSize: 40,
            fontWeight:FontWeight.w900,
            color: Color(0xff2e385b),
            
            ))
      ],
      ),
      SizedBox(height: 50),
      TextField(
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        onChanged: (value) => {
          email=value
        },
        decoration: InputDecoration(
          hintText: 'Enter Your Email',
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20
            ),
            border: OutlineInputBorder(
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ),
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 163, 158, 152),width: 1),
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ) ,
              focusedBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 2),
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ) ,
              ),
      ),
      SizedBox(height: 8),
      TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        onChanged: (value) => {
          Password=value
        },
        decoration: InputDecoration(
          hintText: 'Enter Your Password',
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20
            ),
            border: OutlineInputBorder(
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ),
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 150, 149, 147),width: 1),
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ) ,
              focusedBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 2),
              borderRadius:BorderRadius.all(
                Radius.circular(20)
                ),
              ) ,
              ),
      ),
      SizedBox(height: 10),
      MyButton(color: Color.fromARGB(255, 91, 90, 88), title: "Sign In", OnPressed: ()async{
         setState(() {
                  showSpinner=true;
        });
    try{final user=await _auth.signInWithEmailAndPassword(
    email: email,
     password: Password);
    if(user!=null){
    Navigator.pushNamed(context, ChatScreen.screenRoute);
         setState(() {
                  showSpinner=false;
        });
    }}
    catch(e){
    print(e);
    }
    
      })
    
      ],),
    ),
  ),
);
}

}

