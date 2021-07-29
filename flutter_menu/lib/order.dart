import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class Order extends StatefulWidget {
  Order({Key key, this.menuData, this.mainData}) : super(key: key);

  final YamlMap menuData;
  final YamlMap mainData;
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {

  int checkBoxIndex = -1;  
  Color selectionColor= Colors.redAccent[100];
  List<int> arr = [];

  Widget _subMenuBuildder(BuildContext context, int index) {

      int subMenuIndex = widget.mainData["menus"].indexWhere(
        (menu) => menu["key"].toString() == widget.menuData["subMenus"][index].toString()
      );

      //print(subMenuIndex);

      return ExpansionTile(

        title: Text(widget.menuData["subMenus"][index]), 
        children: <Widget>[

          SizedBox(
            height: (widget.mainData["menus"][subMenuIndex]["items"].length*40+10).toDouble(),
            child: ListView.builder(
                          itemCount: widget.mainData["menus"][subMenuIndex]["items"].length,
                          itemBuilder: (context, index2) {
                            return ListTile(
                              
                                   onTap: () {
                                     setState(() { 

                                       if(checkBoxIndex != index2){
                                         checkBoxIndex = index2;
                                          
                                       }
                                       else{
                                         checkBoxIndex = -1;
                                       }
                                       

                                     });       
                                   },
                                   tileColor: index2 == checkBoxIndex? Colors.yellowAccent[100]:Colors.redAccent[100],
                                   leading: Image.asset(widget.mainData["menus"][subMenuIndex]["items"][index2]["image"]),
                                        
                                   title: widget.mainData["menus"][subMenuIndex]["items"][index2]["name"] != null ?
                                   Text(widget.mainData["menus"][subMenuIndex]["items"][index2]["name"])
                                   :Text(widget.mainData["menus"][subMenuIndex]["items"][index2]["caption"]),

                                   trailing:widget.mainData["menus"][subMenuIndex]["items"][index2]["price"] != null ? 
                                   Text(widget.mainData["menus"][subMenuIndex]["items"][index2]["price"].toString()): null,

                                   );
                          },
                        ),
                                   
          ),

        ],

      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 120, 123),
        title: Text(widget.menuData["name"].toString()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 110,
                child: ListView.builder(
                    itemCount: widget.menuData["subMenus"].length,
                    itemBuilder: _subMenuBuildder),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
