
import 'package:easy_life/db/dbhelp.dart';

import 'package:flutter/material.dart';
import 'Consulter_art.dart';
import 'db/artison.dart';

import 'package:toast/toast.dart';

//import 'home.dart';


class Ajoutart extends StatefulWidget {
  bool isupdate;
 @override
  Ajoutart(this.isupdate);
  @override
  _AjoutartState createState() => _AjoutartState(this.isupdate);
}
String _dropdownValue,_dropdownValue2 ;
class _AjoutartState extends State<Ajoutart> {
  Future<List<Artison>> artisons;
  
_AjoutartState(this.isupdate);
      TextEditingController controller= TextEditingController();

      TextEditingController controller2= TextEditingController();

      TextEditingController controller3= TextEditingController();

      TextEditingController controller4= TextEditingController();

String nom;

int iduser;

String etat,desg;

double mont;

final formkey= new GlobalKey<FormState>();

var dbhelper;
 
bool isupdate;
List<String> listtype=['Architect','Decorateur','Menuisier','Maçon','Peintre','Plombier','Electricien','Ferrinier'];
List<String> listdrop=['Payee','Non payee'];
@override
void initState(){
  super.initState();
  dbhelper=DBhelper();
  refreshList();
 
}

refreshList(){
  setState(() {
     artisons=dbhelper.gettypeartison();
  });
 
}

clearname(){
  controller.text='';
  controller2.text='';
  controller3.text='';
  controller4.text='';
_dropdownValue=null;
_dropdownValue2=null;
}

validate(){
  if(formkey.currentState.validate()){
    formkey.currentState.save();
    if(isupdate){
      Artison a = Artison(iduser,nom,_dropdownValue2,mont,0,_dropdownValue);
      dbhelper.update(a); 
      setState(() {
        isupdate=false;
      });
    
    }else{
        Artison a = Artison(null,nom,_dropdownValue2,mont,0,_dropdownValue);
   dbhelper.save(a); 

        print("success");
        Toast.show("Success Insert", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
      //MyHomePage c= new MyHomePage();
      
      //c.createState().refreshList();
      
     refreshList();
    
    }
    clearname();
      // refreshList();
   
  }
}

form(){
  return Form(key:formkey ,
  child: Padding(
    
padding: EdgeInsets.all(20.0),

child: Column(

 
mainAxisAlignment: MainAxisAlignment.start,
  
  children: <Widget>[
   
TextFormField(
  controller: controller,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(labelText: 'Nom Artison '),
  validator: (val)=>val.length==0?'enter nom artison':null,
  onSaved: (val)=> nom=val,
),
SizedBox(height: 5),
DropdownButton<String>(
  isExpanded: true,
  
      hint: Text("Type"),
      items: listtype.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(), 
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue2 = newValue;
        });
      },
      value: _dropdownValue2,
     
    ),
TextFormField(
  controller: controller3,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Montant'),
  validator:  (val1)=>val1.length==0?'enter Montant':null,
  onSaved: (val1)=> mont=double.parse(val1),
),
SizedBox(height: 5),
DropdownButton<String>(
  isExpanded: true,
  
      hint: Text("Etat"),
      items: listdrop.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
        });
      },
      value: _dropdownValue,

    ),





 SizedBox(height: 50),
Row(
  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    RaisedButton.icon(
      onPressed: validate,
      
      label: Text(isupdate ?'update':'Ajouter' ),
       icon: Icon(Icons.add),
        color: Colors.blue[500],
    ),
     RaisedButton.icon(
       icon: Icon(Icons.close),
      onPressed: (){
        setState(() {
          isupdate=false;
        });
        clearname();
      },
      label: Text('cancel'),
      color: Colors.amber,
      
    ),
  ],
)

  ],
),

  ),
  
  
  );
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
      label: Text('Type',style: TextStyle(fontSize: 12.0)),
       ),
     
      
        DataColumn(
      label: Text('Action',style: TextStyle(fontSize: 12.0)),
       ),
    
  ],
  rows: artisonss.map((artisonn)=> DataRow(
    cells:[
      DataCell(
        Text(artisonn.desgination,style: TextStyle(fontSize: 12.0)),
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
  builder: (context)=>ConsulterArt(artisonn)
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
    return DefaultTabController(
      length: 2,
      child:Scaffold(

      resizeToAvoidBottomPadding: false,
      appBar: new AppBar( 
        title: Center(
         child:Text("Artison      "), 
         
        ),
        bottom:TabBar(
tabs: <Widget>[
  Tab(
    text: " Ajouter Artison",
  ),
  Tab(
text: "Consulter Artison",
  ),
],
 
        ) ,
      
      ),
      
      body:TabBarView(
        
        children: <Widget>[

          Container(
               margin: EdgeInsets.all(5),
              child: form(),
          ),
          Container(
             margin: EdgeInsets.all(5),
              child: Container(
                
 child:  new Column(
   
   mainAxisAlignment: MainAxisAlignment.start,
  mainAxisSize: MainAxisSize.max,
   verticalDirection: VerticalDirection.down,
   children: <Widget>[

 list(),
   ],
 ),
   ),
          ),
        ],
      ),
         
     
 
   ),
  
      


    );
    
    
    
    
    
    /*new Scaffold(

      appBar: new AppBar( 
        title: Center(
         child:Text("Ajouter Artison       "), 
        ),

      ),
      body: SingleChildScrollView(
              child: Container(
                child: form(),
                
   ),
      ),
  
   );*/
    
  }
}