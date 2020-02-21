import 'package:easy_life/db/dbhelp.dart';
import 'package:easy_life/detail_artison.dart';

import 'package:flutter/material.dart';
import 'db/artison.dart';
import 'dart:async';


class ConsulterArt extends StatefulWidget {
 Artison art;
 ConsulterArt(this.art);
 
  @override
  _ConsulterartState createState() => _ConsulterartState(this.art);
}


class _ConsulterartState extends State<ConsulterArt> {
Artison art;
_ConsulterartState(this.art);
  Future<List<Artison>> artisons;
 
String x;
var dbhelper;


@override
void initState(){
  super.initState();
  dbhelper=DBhelper();
 
  refreshList();
}
refreshList(){
  setState(() {
   
     artisons=dbhelper.getartison(art.desgination.toString());
     
  });
 
}
SingleChildScrollView dataTable(List<Artison> artisonss){
  
return SingleChildScrollView(
scrollDirection:  Axis.vertical,

child:SingleChildScrollView(
   scrollDirection: Axis.horizontal,
   child:
   DataTable(
   sortAscending: true,
   sortColumnIndex: 0,
  columns: [
    
    DataColumn(
      label: Text('Name',style: TextStyle(fontSize: 12.0)),
       ),
        DataColumn(
      label: Text('Etat',style: TextStyle(fontSize: 12.0)),
       ),
          DataColumn(
      label: Text('Montant',style: TextStyle(fontSize: 12.0)),
       ),
        DataColumn(
      label: Text('Action',style: TextStyle(fontSize: 12.0)),
       ),
    
  ],
  rows: artisonss.map((artisonn)=> DataRow(
   
    cells:[
      DataCell(
        Text(artisonn.name,style: TextStyle(fontSize: 12.0)),
      ),
      DataCell(
        Text(artisonn.etat,style: TextStyle(fontSize: 12.0)),
      ),
      DataCell(
        Text(artisonn.montant.toString()+"00",style: TextStyle(fontSize: 12.0)),
      ),
       DataCell(
       
         Row(
         children: <Widget>[  
        IconButton(
          iconSize: 17.0,
          color: Colors.blue,
          focusColor: Colors.blueAccent,
          icon: Icon( Icons.description),
          onPressed: (){
Navigator.push(context,MaterialPageRoute(
  builder: (context)=>Detailart(artisonn)
));
          },
        ),
         ],
        ),
      ),
    ] ,
  ),).toList(),
) ,
),
);

}
list(){
  return Expanded(
child: FutureBuilder(
  future: artisons,
  builder: (context,snapshot){
if(snapshot.hasData){
 return dataTable(snapshot.data);
}
if(null ==snapshot.data || snapshot.data.length ==0){
  return Text("No data Found");
}
return CircularProgressIndicator();
  },
),


  );
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar( 
        title: Center(
         child:Text("Consulter "+art.desgination.toString()), 
        ),

      ),
      body:new Container(
 child:  new Column(
   mainAxisAlignment: MainAxisAlignment.start,
   mainAxisSize: MainAxisSize.min,
   verticalDirection: VerticalDirection.down,
   children: <Widget>[

 list(),
   ],
 ),
   ),
  
   );
  }
}