import 'package:flutter/material.dart';
import 'package:testapp/signup/signup_page.dart';
import '../top_page.dart';
import 'login_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          decoration:
                          InputDecoration(hintText: 'example@gmail.com'),
                          controller: mailController,
                          onChanged: (text) {
                            model.mail = text.trim();
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: 'password'),
                          controller: passwordController,
                          obscureText: true,
                          onChanged: (text) {
                            model.password = text;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            child: Text('ログイン'),
                            onPressed: () async {
                              model.startLoading();
                              try {
                                await model.login();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TopPage();
                                    },
                                  ),
                                );
                              } catch (e) {
                                _showTextDialog(context, e.toString());
                                model.endLoading();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: TextButton(
                            child: Text('まだアカウントを持っていない方はこちら',style: TextStyle(color:Colors.grey)),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SignUpPage();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                model.isLoading
                    ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : SizedBox()
              ],
            );
          },
        ),
      ),
    );
  }
}

_showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}