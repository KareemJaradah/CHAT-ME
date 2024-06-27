import 'package:chat_me/Screens/Registration_screen.dart';
import 'package:chat_me/Screens/signin_screen.dart';
import 'package:chat_me/widgets/my_buttons.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  
static const String screenRoute='welcome_screen';
 
 const WelcomeScreen ({ Key? key }) : super (key: key);

@override

_WelcomeScreenState createState() => _WelcomeScreenState();

}
class _WelcomeScreenState extends State<WelcomeScreen> {
@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white,
  body: Padding(
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
        'ContactMe',
        style: TextStyle(
          fontSize: 40,
          fontWeight:FontWeight.w900,
          color: Color(0xff2e385b),
          
          ))
    ],
    ),
    SizedBox(height: 30,),
    MyButton(color: Color.fromARGB(255, 91, 90, 88)!,title: 'Sign In',OnPressed: (){
      Navigator.pushNamed(context, SignInScreen.screenRoute);
    },),
        MyButton(color: Color.fromARGB(255, 36, 92, 177)!,title: 'Register',OnPressed: (){
          Navigator.pushNamed(context, RegistrationScreen.screenRoute);
        },)

    ],),
  ),
);
}

}

