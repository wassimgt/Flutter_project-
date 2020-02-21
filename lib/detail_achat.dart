import 'package:easy_life/Ajout_Achat.dart';
import 'package:easy_life/db/achat.dart';
import 'package:easy_life/db/dbhelp.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Consulter_art.dart';
import 'db/Cheque.dart';
import 'db/artison.dart';
import 'home.dart';
class Detailachat extends StatefulWidget {
  int id;
  Achat art;
    Detailachat(this.art);

  @override
  _DetailachatState createState() => _DetailachatState(this.art);
}
String _dropdownValue;
class _DetailachatState extends State<Detailachat> {
  
      TextEditingController controller= TextEditingController();

      TextEditingController controller2= TextEditingController();

      TextEditingController controller3= TextEditingController();

      TextEditingController controller4= TextEditingController();
  Achat _art;
 Future<List<Artison>> artisons;
  Future<List<Cheque>> cheque;
 List<double> avance;
  _DetailachatState(this._art);
bool _isVisible = false;
DBhelper dbhelper;
  double reste=0;
  
int id;
String ref;
List<String> type=['electricté'];
String etat;
DateTime date;
double mont;
   final format = DateFormat("dd-MM-yyyy");
final formkey= new GlobalKey<FormState>();
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
   String x=format.format(date);
     Achat a = Achat(_art.id_achat,ref,_dropdownValue,mont,x,_art.Etat,reste);
      dbhelper.updateach(a); 
      setState(() { 
       _art=a;
      });
    
   
   
   Toast.show("Success update", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
      MyHomePage c= new MyHomePage();
      c.createState();
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
  onSaved: (val)=> ref=val,
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
      items: type.map<DropdownMenuItem<String>>((String value) {
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


      ),], 
),   
Row(
   children:<Widget>[
      Expanded(
       child: DateTimeField(
    controller: controller4,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(labelText: 'Date Facture'),
         validator: (val1)=>val1==null?'Enter Date Facture':null,
        onSaved: (val1)=> date=val1,
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
    cheque=dbhelper.getchequeachat(_art.id_achat);
dbhelper..getavanceachat(_art.id_achat).then((onValue){
setState(() {
  if(onValue!=null){
  avance=onValue;
  print(avance);

  reste=_art.Montant-avance[0];

  
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
   Navigator.push(context,MaterialPageRoute(
  builder: (context)=>Ajoutach() ));
     Navigator.of(cont).pop();
  
    },

  ),
  FlatButton(
    child: Text("OUI",style: TextStyle(color: Colors.black)),
    onPressed:  () {
    dbhelper.delete(_art.id_achat);
Navigator.push(context,MaterialPageRoute(
  builder: (context)=>ConsulterArt(null)));
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
     if(_art.Etat=="Non payee"){
    _isVisible=true;
  }
  });
 
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
        padding: const EdgeInsets.all(5.0),
        
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
  Text("Reference Facture :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.Reference.toString()),

],

     ),
    
    Row(
children: <Widget>[
   SizedBox(height: 50), SizedBox(width: 20),
  Text("Type Facture :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.type.toString()),

],

     ),
          
 
           Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 20),
  Text("Montant :",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0)),
 SizedBox(width: 20),
  Text(_art.Montant.toString()+"00"),
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
  Text(_art.Etat),

],
     ),
   SizedBox(height: 30),   
Row(
children: <Widget>[
   SizedBox(height: 50),
    SizedBox(width: 15),

RaisedButton.icon(
  icon: Icon(Icons.edit),
  onPressed: (){
    controller.text=_art.Reference;
controller3.text=_art.Montant.toString();
mainBottomSheet(context);
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