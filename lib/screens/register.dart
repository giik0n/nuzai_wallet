import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    ColorScheme _colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/icons/Logo.png',scale: 1.5,),
                  RichText(
                    text: TextSpan(
                      style: _textTheme.headline6,
                      text: "",
                      children: [
                        TextSpan(text: "Join "),
                        TextSpan(
                            text: "N",
                            style: TextStyle(color: _colorScheme.secondary)),
                        TextSpan(text: "uzai wallet"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Column(
                      children: [
                        CupertinoButton(
                            borderRadius: BorderRadius.circular(8),
                            color: Color.fromRGBO(245, 244, 248, 1),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const RegisterPage()));
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        color: Color.fromRGBO(23, 25, 46, 1)),
                                  ),
                                  Icon(
                                    Icons.mail_outline_rounded,
                                    color: Color.fromRGBO(23, 25, 46, 1),
                                  )
                                ])),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromRGBO(245, 244, 248, 1),
                                  child: Center(
                                    child: Image.asset('assets/icons/google.png',scale: 1.5,),
                                  ),
                                  onPressed: () {}),
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromRGBO(245, 244, 248, 1),
                                  child: Center(
                                    child: Image.asset('assets/icons/facebook.png',),
                                  ),
                                  onPressed: () {}),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            color: Color.fromRGBO(23, 25, 46, 0.1),
                            height: 1,
                          )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text("or"),
                          ),
                          Expanded(
                              child: Container(
                            color: Color.fromRGBO(23, 25, 46, 0.1),
                            height: 1,
                          )),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account?",
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.blue[50]),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Sing In",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: RichText(
                text: TextSpan(
                  style: _textTheme.bodySmall,
                  text: "",
                  children: [
                    TextSpan(text: "By signing up, you agree to "),
                    TextSpan(
                        text: "Terms of Serice ",
                        style: TextStyle(color: _colorScheme.secondary)),
                    TextSpan(text: "and confirm that our "),
                    TextSpan(
                        text: "Privacy Policy ",
                        style: TextStyle(color: _colorScheme.secondary)),
                    TextSpan(text: "applies to you"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//By signing up, you agree to Terms of Serice and
// confirm that our Privacy Policy applies to you
