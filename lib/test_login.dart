import 'package:flutter/material.dart';

class GIBLogin extends StatelessWidget {
  const GIBLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:GIBLoginPage()
    );
  }
}
class GIBLoginPage extends StatefulWidget {
  const GIBLoginPage({Key? key}) : super(key: key);

  @override
  State<GIBLoginPage> createState() => _GIBLoginPageState();
}

class _GIBLoginPageState extends State<GIBLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body :SizedBox(
          height: 7000,width: 2000,
          child: Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img.png"),
                fit: BoxFit.fitWidth,

              ),
            ),),
        )
    );
  }
}
