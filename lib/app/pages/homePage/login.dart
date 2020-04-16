import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function doLogin;
  Login(this.doLogin);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Text(
                "Bem vindo ao ChatApp",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            textLine("Troque mensagens instantâneas."),
            textLine("Crie grupos com seus amigos."),
            GestureDetector(
              onTap: widget.doLogin,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "images/google.png",
                      width: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Continuar com o Google",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textLine(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 30,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
