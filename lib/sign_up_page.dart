import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/login_page.dart';
import 'package:todo_app/uiHelper/ui_helper.dart';


String collectionId = "";

class SignUp_page extends StatefulWidget {
  const SignUp_page({super.key});

  @override
  State<SignUp_page> createState() => _SignUp_pageState();
}

class _SignUp_pageState extends State<SignUp_page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool isPasswordFieldFocused = false;
  bool passwordsMatch = true; // Flag to track if passwords match
  final GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();
  File? pickedImage;






  signUp(String email, String password, String rePassword) async{
    if(email == "" || password == ""|| rePassword == ""){

      MotionToast.warning(
          title:  Text("Email/Password is Empty"),
          description:  Text("Type valid Email/Password")
      ).show(context);
    }else if(email.isNotEmpty) {
      bool isValid = EmailValidator.validate(email);
      if (isValid) {
        if (password != rePassword) {
          // If passwords don't match, set passwordsMatch flag to false
          MotionToast.warning(
              title:  Text("Password missmatched"),
              description:  Text("check password")
          ).show(context);
          passwordsMatch = false;
        } else {
          // Passwords match, proceed with sign up
          passwordsMatch = true;
          // Perform signup logic here

          UserCredential? userCredential;
          try{
            userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value){
              collectionId = value.user!.uid;

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            });
          }
          on FirebaseAuthException catch(ex){
            MotionToast.info(
              title:  const Text(
                "Error SignUp",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              position: MotionToastPosition.center,
              description:  Text(ex.code.toString()),
            ).show(context);
          }

          print("Successful");


        }

      }else{
        MotionToast.warning(
            title:  Text("Ivalid Email"),
            description:  Text("Enter Valid Email")
        ).show(context);
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp Page"),
        centerTitle:true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/loginLogo.png"),
              SizedBox(height: 10,),
              UiHelper.customTextField(emailController, "Email", Icons.mail, false),

              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isPasswordFieldFocused = hasFocus;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordFieldFocused = true;
                    });
                  },
                  child: UiHelper.customTextField(passwordController, "Password", Icons.password, false,),
                ),
              ),
              if (isPasswordFieldFocused)
                FlutterPwValidator(
                  controller: passwordController,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  width: 400,
                  height: 200,
                  onSuccess: () {
                    print("Success");
                  },
                  onFail: () {
                    print("Failed");
                  },
                ),

              UiHelper.customTextField(rePasswordController, "re-enter password", Icons.password, false),


              SizedBox(height: 30,),
              UiHelper.customButton(() {
                signUp(emailController.text.toString(), passwordController.text.toString(),rePasswordController.text.toString());

              }, "SignUp"),
              SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account,",style: TextStyle(fontSize: 18),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                  }, child: Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)))
                ],
              )
            ],

          ),
        ),
      ),

    );
  }
}