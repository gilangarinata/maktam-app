import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/utils/screen_utils.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("add you image URL here "),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage("Add you profile DP image URL here "),
                  radius: 60.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 90,
          ),
          Text(
            "",
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueGrey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "",
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Status : Karyawan",
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () {
              ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 100.0,
                  maxHeight: 40.0,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Keluar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
