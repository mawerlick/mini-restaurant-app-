import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import "package:flutter/services.dart" as s;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'order.dart';

void main() {
  runApp(AppBase());
}

class AppBase extends StatelessWidget {
   AppBase({
    Key key,
  }) : super(key: key); // ??
  
  YamlMap myData;
  Future<void> LoadData() async {
    final String data = await rootBundle.loadString('assets/menu.yaml');
    final mapData = await loadYaml(data);
    myData = mapData;
    //print(mapData["menus"][0]["items"][0]["caption"]);
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
     future: LoadData(),
     builder: (context, snapshot){
       if (snapshot.connectionState == ConnectionState.done) {
            
            return MaterialApp(home: MyHomePage(myData: myData,));
          } 
          else {
            
            
            return CircularProgressIndicator();
          }
     },
     
     );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.myData}) : super(key: key);

  final YamlMap myData;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 120, 123),
        title: Text("Lezzet Durağı"),
      ),
      body: widget.myData["menus"]!=null? Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 110,
                child: ListView.builder(
                  itemCount: widget.myData["menus"][0]["items"].length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: Image.asset(
                          widget.myData["menus"][0]["items"][index]["image"]),
                      title: Text(widget.myData["menus"][0]["items"][index]["name"]),
                      //backgroundColor: Colors.yellow[200] ,
                      collapsedBackgroundColor: Colors.redAccent[100],
                      children: <Widget>[
                        SizedBox(
                          height: (widget.myData["menus"][0]["items"][index]["items"]
                                          .length *
                                      40 +
                                  10)
                              .toDouble(),
                          child: ListView(
                            children: widget.myData["menus"][0]["items"][index]
                                    ["items"]
                                .map<Widget>((menudata) => InkWell(
                                      splashColor: Colors.redAccent[100],
                                      highlightColor: const Color.fromARGB(
                                          255, 44, 120, 123),
                                      onTap: () {
                                        if (index == 0 && menudata["subMenus"] != null) {
                                         // print(menudata.runtimeType);
                                         // print(myData["menus"]);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Order(
                                                          menuData: menudata , mainData: widget.myData)));
                                        }
                                      },
                                      child: ListTile(
                                        leading: Image.asset(menudata["image"]),
                                        title: Text(menudata["name"]),
                                        trailing:
                                            Text(menudata["price"].toString()),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ):Container(
        child:Text("loading data"),
      ),
    );
  }
}
