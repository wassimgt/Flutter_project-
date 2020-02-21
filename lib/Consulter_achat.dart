import 'package:easy_life/db/achat.dart';
import 'package:easy_life/db/dbhelp.dart';


import 'package:flutter/material.dart';

import 'detail_achat.dart';

class Consulterach extends StatefulWidget {
  Achat achat;
  Consulterach(this.achat);
  @override
  _ConsulterachState createState() => _ConsulterachState(this.achat);
}

class _ConsulterachState extends State<Consulterach> {
   Future<List<Achat>> achats;
   Achat achatt;
   _ConsulterachState(this.achatt);
DBhelper dBhelper;
@override
  void initState() {
    dBhelper=DBhelper();
   refrechlist();
    super.initState();
  }
refrechlist(){
  setState(() {
     achats=dBhelper.getachat(achatt.type);
  });
}


SingleChildScrollView dataTable(List<Achat> achats){
return SingleChildScrollView(
scrollDirection:  Axis.vertical,

child:SingleChildScrollView(
   scrollDirection: Axis.horizontal,

child: DataTable(
  sortAscending: true,
  columns: [
    DataColumn(
      label: Text('Reference'),
       ),
        DataColumn(
      label: Text('Etat'),
       ),
          DataColumn(
      label: Text('Montant'),
       ),
        DataColumn(
      label: Text('Action'),
       ),
    
  ],
  rows: achats.map((achat)=> DataRow(
    cells:[
      DataCell(
        Text(achat.Reference),
      ),
       DataCell(
        Text(achat.Etat),
      ),
      DataCell(
        Text(achat.Montant.toString()+"00"),
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
  builder: (context)=>Detailachat(achat)
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
  future: achats,
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
         child:Text("Consulter Achat    "), 
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