import 'package:flutter/material.dart';

class UiHelper{
  static customTextField(TextEditingController controller, String text, IconData iconData, bool tohide){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: TextField(
        keyboardType: text == "Email"
            ? TextInputType.emailAddress
            : text == "OTP"
            ? TextInputType.number
            : TextInputType.text,
        controller: controller,
        obscureText: tohide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),

            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(35),

            )
        ),
      ),
    );
  }




  static customButton(VoidCallback voidCallback, String text){
    return SizedBox(height: 50, width: 200,

      child: ElevatedButton(style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
        onPressed: () { voidCallback(); },
        child: Text(text, style: TextStyle(
            color: Colors.white,
            fontSize: 20
        ),),

      ),
    );
  }


}