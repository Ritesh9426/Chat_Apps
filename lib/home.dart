import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userId;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Home',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              letterSpacing: 1,

            ),),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 30),

              onPressed: () async {
                await googleSignIn.signOut();
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.setString('id', '');
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (listContext, index) =>
                    buildItem(snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }

            return Container();
          },
        ));
  }

  buildItem(doc) {
    return (userId != doc['id'])
        ? GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatPage(docs: doc)));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Card(
                color: Colors.green[200],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                  child: Container(
                    alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/circle.jpg'),
                            radius: 25,
                          ),
                          SizedBox(width: 10,),
                          Text(doc['name'],style: TextStyle(color: Colors.black,fontSize: 20),),
                        ],
                      ),
                    ),
                ),
              ),
            ),
          )
        : Container();
  }
}
