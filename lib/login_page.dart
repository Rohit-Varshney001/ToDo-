import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/forgot_password_page.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/sign_up_page.dart';
import 'package:todo_app/uiHelper/ui_helper.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';



var name;
var user_name_login;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password)async{
    if(email == "" || password == "") {
      MotionToast.warning(
          title: Text("Email/Password is Empty"),
          description: Text("Type valid Email/Password")
      ).show(context);
    }else{
      UserCredential? userCredential;
      try{
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
          name = value.user?.uid;
          user_name_login = value.user?.email;
          user_name_login = user_name_login.toString().length > 7 ? value.user?.email.toString().substring(0, 7).toUpperCase():value.user?.email.toString().toUpperCase();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
      on FirebaseAuthException catch(ex){
        MotionToast.info(
          title:  const Text(
            "Error login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          position: MotionToastPosition.center,
          description:  Text("Wrong Email/Password"),
        ).show(context);
      }
    }
  }

  signinWithGoogle(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing the dialog with back button or tapping outside
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Hide loading indicator
        Navigator.pop(context);
        // Handle sign-in cancellation or error
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      if (googleAuth == null) {
        // Hide loading indicator
        Navigator.pop(context);
        // Handle authentication error
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

      // Assuming name, user_name_login, and context are properly declared elsewhere
      name = user.user?.uid;
      user_name_login = user.user?.email;
      user_name_login = user_name_login.toString().length > 7 ? user.user?.email.toString().substring(0, 7).toUpperCase() : user.user?.email.toString().toUpperCase();

      // Hide loading indicator
      Navigator.pop(context);

      // Navigate to the Home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);
      // Handle any unexpected errors
      MotionToast.info(
        title:  const Text(
          "Error login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        position: MotionToastPosition.center,
        description:  Text("Error signing in with Google: $e"),
      ).show(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,


      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/loginLogo.png"),
            SizedBox(height: 15,),


            UiHelper.customTextField(emailController, "Email", Icons.mail, false),
            UiHelper.customTextField(passwordController, "Password", Icons.password, true),
            SizedBox(height: 30,),
            UiHelper.customButton(() {
              login(emailController.text.toString(), passwordController.text.toString());
            }, "Login"),
            SizedBox(height: 15,),

            SizedBox(height: 50, width: 200,

               child: ElevatedButton(style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 5,
                ),
                onPressed: () {
                    signinWithGoogle(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 25,
                        width: 25,
                        child: Image.asset("assets/images/google.png")
                    ),
                    Text("Sign in with Google", style: TextStyle(
                      color: Colors.black,
                      fontSize: 13
                      ),),
                  ],
                ),

              ),
            ),
            SizedBox(height: 15,),



            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account,",style: TextStyle(fontSize: 18),),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp_page()),);
                }, child: Text("SignUp",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500))),


              ],
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()),);
            }, child: Text("Forgot Password ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500))),



          ],

        ),
      ),
    );
  }
}
