import 'package:easy_life/db/dbhelp.dart';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'Ajout_artison.dart';
import 'Consulter_art.dart';
import 'db/Cheque.dart';
import 'db/artison.dart';
//import 'home.dart';
class Detailart extends StatefulWidget {
  int id;
  Artison art;
  @override 
  Detailart(this.art);

  _DetailartState createState() => _DetailartState(this.art);
}
String _dropdownValue2 ;
class _DetailartState extends State<Detailart> {
     TextEditingController controller= TextEditingController();

      TextEditingController controller2= TextEditingController();

      TextEditingController controller3= TextEditingController();

      TextEditingController controller4= TextEditingController();
List<String> listtype=['Architect','Decorateur','Menuisier','Maçon','Peintre','Plombier','Electricien','Ferrinier'];
List<String> listdrop=['Payee','Non payee'];
String nom;
double mont ;
final formkey= new GlobalKey<FormState>();

  Artison _art;
 Future<List<Artison>> artisons;
  Future<List<Cheque>> cheque;
 List<double> avance;
  _DetailartState(this._art);
bool _isVisible = false;
DBhelper dbhelper;
  double reste=0;
@override
void initState(){
  super.initState();
  dbhelper=DBhelper();
   refreshList();
  show();
}
  mainBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Update Artison',style :TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: "vistolsans")),
              Divider(),
              
              form(),
            ],
          );
        }
    );
  }
  clearname(){
  controller.text='';

}
validate(){
  if(formkey.currentState.validate()){
    formkey.currentState.save();
   
      Artison a = Artison(_art.id,nom,_dropdownValue2,mont,reste,_art.etat);
      dbhelper.update(a); 
      setState(() { 
       _art=a;
      });
    
   
   
   Toast.show("Success update", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
     // MyHomePage c= new MyHomePage();
    //  c.createState();
    clearname();
     refreshList();
   Navigator.of(context).pop();
  }
}
form(){
  return Form(key:formkey ,
 
child: Column(
mainAxisAlignment: MainAxisAlignment.start,
 mainAxisSize: MainAxisSize.min, 
  children: <Widget>[
 Row(
   children:<Widget>[
      Expanded(
       child:
    TextFormField(
  controller: controller,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(labelText: 'Nom Artison '),
  validator: (val)=>val.length==0?'enter nom artison':null,
  onSaved: (val)=> nom=val,
),


      ),], 
), 
Row(
   children:<Widget>[
      Expanded(
       child:
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


      ),], 
),   

 Row(
   children:<Widget>[
      Expanded(
       child:
   TextFormField(
  controller: controller3,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Montant'),
  validator:  (val1)=>val1.length==0?'enter Montant':null,
  onSaved: (val1)=> mont=double.parse(val1),
),

      ),], 
),
Row(
  
  children: <Widget>[
SizedBox(
  
  width: 350, // match_parent
  child: RaisedButton.icon(
      
      onPressed: validate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      label: Text('update'),
       icon: Icon(Icons.add),
        color: Colors.blue[300],
    ),
),
    
   
  ],
)

  ],
),

  );
  
  

}
refreshList() async{
    cheque=dbhelper.getcheque(_art.id);
dbhelper.getavance(_art.id).then((onValue){
setState(() {
  if(onValue!=null){
  avance=onValue;
  print(avance);
  reste=_art.montant-avance[0];


  }
  else{
avance=[0];
print(avance);

  }

});
});

 
}
showAlertDialog(BuildContext cont) async {
  AlertDialog alert;
 alert = AlertDialog(
    title: Text("Supprimer"),
    content: Text("voulez-vous supprimer?"),
    actions:<Widget> [
      
      FlatButton(
    child: Text("NOM",style: TextStyle(color: Colors.black)),
    onPressed:  () {
   
     Navigator.of(context).pop();
  
    },

  ),
  FlatButton(
    child: Text("OUI",style: TextStyle(color: Colors.black)),
    onPressed:  () {
    dbhelper.delete(_art.id);
Navigator.push(context,MaterialPageRoute(
  builder: (context)=>Ajoutart(true) ));
    Navigator.of(context).pop();
    },

  )
   
    ],
  );


  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext cont) {
      return alert;
    },
  );
}
show()async{
  setState(() {
     if(_art.etat=="Non payee"){
    _isVisible=true;
  }
  });

}

 showalert(BuildContext cont) async {
  AlertDialog alert2;
 alert2 = AlertDialog(
   contentPadding: EdgeInsets.all(15.0),
   
    actions:<Widget> [
       
    
    ],
  );


  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext cont) {
      return alert2;
    },
  );
}

  SingleChildScrollView dataTable(List<Cheque> cheques){
  
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
      label: Text('Reference Cheque',style: TextStyle(fontSize: 12.0)),
       ),
     
          DataColumn(
      label: Text('Montant',style: TextStyle(fontSize: 12.0)),
       ),
          DataColumn(
      label: Text('Date',style: TextStyle(fontSize: 12.0)),
       ),
        DataColumn(
      label: Text('Action',style: TextStyle(fontSize: 12.0)),
       ),
    
  ],
  rows: cheques.map((artisonn)=> DataRow(
   
    cells:[
      DataCell(
        Text(artisonn.Reference_ch,style: TextStyle(fontSize: 12.0)),
      ),
      DataCell(
        Text(artisonn.Montant.toString()+"00",style: TextStyle(fontSize: 12.0)),
      ),
      DataCell(
        Text(artisonn.Date_ch.toString(),style: TextStyle(fontSize: 12.0)),
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
            //code
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
  future: cheque,
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
  Widget build(BuildContext cont) {
    
    return DefaultTabController(
      length: 2,
      child:Scaffold(

      resizeToAvoidBottomPadding: false,
      appBar: new AppBar( 
        title: Center(
         child:Text("Detail Artison      "), 
         
        ),
        bottom:TabBar(
tabs: <Widget>[
  Tab(
    text: " Detail",
  ),
  Tab(
text: "Liste Cheque",
  ),
],
 
        ) ,
      
      ),
      
      body:TabBarView(
        
        children: <Widget>[

          Container(
               margin: EdgeInsets.all(5),
              child:Padding(
        padding: const EdgeInsets.all(0),
        
        child: Card(
        
          color: Colors.grey[200],
         child: Container(
           height :500 ,
 child:  
  Column(
           mainAxisAlignment: MainAxisAlignment.start,
  mainAxisSize: MainAxisSize.max,
   verticalDirection: VerticalDirection.down,
   children: <Widget>[
         SizedBox(height: 40),
          
     Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),
  Text("Nom :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.name.toString()),

],

     ),
    
    Row(
children: <Widget>[
   SizedBox(height: 50), SizedBox(width: 20),
  Text("Desingation :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.desgination.toString()),

],

     ),
          
 
           Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),
  Text("Montant :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.montant.toString()+"00"),
],
     ),
          

        
        
Visibility(
  visible: _isVisible,
  child: Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),
  Text("Avance :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(avance==null ?"0":avance[0].toString()+"00"),

],
     ),
     
),
Visibility(
  visible: _isVisible,
  child:Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),
  Text("Reste :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(reste.toString()+"00 "),

],
     ),
),
          
            

           Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),

  Text("Etat :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.etat),

],
     ),
   SizedBox(height: 30),   
Row(
children: <Widget>[
 
    SizedBox(width: 15),

RaisedButton.icon(
  icon: Icon(Icons.edit),
  onPressed: (){
mainBottomSheet(context);
controller.text=_art.name;
controller3.text=_art.montant.toString();
  },
  label: Text("edit"),
  color: Colors.blue,

),
SizedBox(width: 20),

RaisedButton.icon(
  icon: Icon(Icons.delete),
  
  onPressed: (){
   showAlertDialog(cont); 
  },
  label: Text("Delete"),
  color: Colors.red[400],

),

SizedBox(width: 20),

],
     ),

           ],
 ),
   ),
   ),
      

      ) ,
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
    
    
    
    
   
  }
}