import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sunny_connect/modals/app_post.dart';
import 'package:sunny_connect/screens/authentication/login.dart';
import 'package:sunny_connect/utils/app_navigator.dart';
import 'package:sunny_connect/utils/colors.dart';

class Utilities {  
  static showToast(String msg){
    Fluttertoast.showToast(
      msg: '$msg',
      gravity: ToastGravity.TOP,
      backgroundColor: primaryBlue, 
      textColor: Colors.white,
    );
  }

  static showLogoutDialog(BuildContext ctx){
    showDialog(context: ctx, builder: (context)=>AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("Do you want to logout?"),
      actions: [
        MaterialButton(
          color: Colors.grey[400],
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black),),
        ),
        MaterialButton(
          color: primaryBlue,
          onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            AppNavigator.makeFirst(context, const LoginScreen());
          },
          child: const Text('Yes', style: TextStyle(color: Colors.white),),
        ),
      ],
    ));
  }

  static Future<bool> showDeleteDialog(BuildContext ctx, Post post)async{
    bool temp;
    await showDialog(context: ctx, 
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("Do you want delete this post?"),
      actions: [
        MaterialButton(
          color: Colors.grey[400],
          onPressed: (){
            Navigator.pop(context);
            temp= false;
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black),),
        ),
        MaterialButton(
          color: primaryBlue,
          onPressed: ()async{
            Navigator.pop(context);
            temp=true;
          },
          child: const Text('Yes', style: TextStyle(color: Colors.white),),
        ),
      ],
    ));
    return temp;
  }

  static Future showInfoDialog(BuildContext ctx, String title, String content, {Function onTap})async{
    await showDialog(context: ctx,barrierDismissible: false, builder: (context)=>AlertDialog(
      title: Text("$title "),
      content: Text("$content "),
      actions: [
        MaterialButton(
          color: primaryBlue,
          onPressed: onTap??()async{
            Navigator.pop(ctx);
          },
          child: const Text('Okay', style: TextStyle(color: Colors.white),),
        ),
      ],
    ));
  }
  
  static Future<bool> showConfirmDialog(BuildContext ctx, String title, String content)async{
    bool request=false;
    await showDialog(context: ctx,barrierDismissible: false, builder: (context)=>AlertDialog(
      title: Text("$title "),
      content: Text("$content "),
      actions: [
        MaterialButton(
          color: Colors.grey,
          onPressed: ()async{
            request=false;
            AppNavigator.pop(ctx);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white),),
        ),
        MaterialButton(
          color: primaryBlue,
          onPressed: ()async{
            request=true;
            AppNavigator.pop(ctx);
          },
          child: const Text('Yes', style: TextStyle(color: Colors.white),),
        ),
      ],
    ));
    return request;
  }
  

  static textField(String lable, bool obscure, TextInputAction textInputAction, 
      TextEditingController controller, {String Function(String) validtor, TextInputType keyboardType, int maxLines, bool readOnly, int maxLen}  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: maxLen??null,
      readOnly: readOnly??false,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: validtor,
      maxLines: maxLines!=null?(maxLines==100?null:maxLines):1,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(),
      decoration: InputDecoration(
        counterText: '',
        labelText: lable,
        alignLabelWithHint: true,
        labelStyle: const TextStyle(fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
