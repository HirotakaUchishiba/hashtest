import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testapp/domain/community.dart';

class UnitCommunityDetailPage extends StatelessWidget {
  final UnitCommunity unitCommunity;
  UnitCommunityDetailPage(this.unitCommunity);
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            unitCommunity.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chat_room")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) return Container();

                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];

                        bool isOwnMessage = false;
                        if (document['user_name'] == true) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                        //isOwnMessageがtrueの場合
                            ? _ownMessage(
                            document['message'], document['user_name']
                        )
                        //isOwnMessageがfalseの場合
                            : _message(
                            document['message'], document['user_name']
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _handleSubmit,
                        decoration:
                        InputDecoration.collapsed(hintText: "メッセージの送信"),
                      ),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _handleSubmit(_controller.text);
                          }),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(userName,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue
            ),),
            Text(message),
          ],
        ),
        Icon(Icons.person),
      ],
    );
  }

  Widget _message(String message, String userName) {
    return Row(
      children: <Widget>[
        Icon(Icons.person),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(userName,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber
            ),),
            Text(message),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) async{
    _controller.text = "";
    var db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final document = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    db.collection("chat_room").add({
      "user_name": data['nickname'],
      //user_nameを変数に変更する
      "message": message,
      "created_at": DateTime.now()
    });
  }
}