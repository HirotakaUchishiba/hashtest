import 'package:flutter/material.dart';
import 'package:testapp/domain/event.dart';

class ExcitingEventDetailPage extends StatelessWidget {

  final ExcitingEvent excitingEvents;


  ExcitingEventDetailPage(this.excitingEvents);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '詳細',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
      ),
      body: excitingEventWidget(context, excitingEvents),
    );
  }

  Widget excitingEventWidget(BuildContext context, ExcitingEvent excitingEvent) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            height: 200,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Hero(
                      tag: 'event-img${excitingEvent.imageURL}',
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: excitingEvent.imageURL != null && excitingEvent.imageURL!.isNotEmpty
                            ?
                        AssetImage('images/exciting_event_images/${excitingEvent.imageURL}')
                            : AssetImage('images/placeholder_image/placeholder.jpeg') ,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(excitingEvent.title, style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  ),
                ]),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .height * 0.43,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('カテゴリ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),),
              ],
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .height * 0.43,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(excitingEvent.category),
              ],
            ),
          ),
        ],
      ),
    );
  }
}