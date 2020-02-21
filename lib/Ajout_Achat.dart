import 'package:easy_life/db/achat.dart';
import 'package:easy_life/db/dbhelp.dart';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'Consulter_achat.dart';
//import 'home.dart';
class Ajoutach extends StatefulWidget {
  @override
  _AjoutartState createState() => _AjoutartState();
}
String _dropdownValue,dropdowntype ;
class _AjoutartState extends State<Ajoutach> {


      TextEditingController controller= TextEditingController();

      TextEditingController controller2= TextEditingController();

      TextEditingController controller3= TextEditingController();

      TextEditingController controller4= TextEditingController();
 TextEditingController controller5= TextEditingController();


int id;
String ref,nv;
List<String> typefac=['Electricté','Autre'];

String etat;
DateTime date;
double mont;
   final format = DateFormat("dd-MM-yyyy");
final formkey= new GlobalKey<FormState>();
List<String> listdrop=['Payee','Non payee'];
DBhelper dbhelper;
  Future<List<Achat>> achats;
bool isupdate;
bool isvisible;
@override
void initState(){
  super.initState();
  dbhelper=DBhelper();
  isupdate=false;
  isvisible=false;
   refrechlist();
}

refrechlist(){
  setState(() {

     achats=dbhelper.gettypeachat();
   

  });
}

clearname(){
  controller.text='';
  controller2.text='';
  controller3.text='';
  controller4.text='';
  controller5.text="";
}

validate(){
  if(formkey.currentState.validate()){
    formkey.currentState.save();
      String x=format.format(date);
    if(isupdate){
    
      //Achat a = Achat(id,ref,dropdowntype,mont,x,_dropdownValue,0.0);
      //dbhelper.updateach(a); 
      //setState(() {
       // isupdate=false;
      //});
      //clearname();
    }else{
      if(dropdowntype =="Autre"){
             Achat a = Achat(null,ref,nv,mont,x,_dropdownValue,0.0);
        dbhelper.saveachat(a);

        print("success");
        Toast.show("Success Insert", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
        //print("xxxxxxxxxxxxxxxxxxxxxxx"+dbhelper.x);
      refrechlist();

      }else{
             Achat a = Achat(null,ref,dropdowntype,mont,x,_dropdownValue,0.0);
   dbhelper.saveachat(a);

        print("success");
        Toast.show("Success Insert", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
        //print("xxxxxxxxxxxxxxxxxxxxxxx"+dbhelper.x);
      refrechlist();

      }
     
//MyHomePage c= new MyHomePage();
  //    c.createState();
    }
    clearname();
      // refreshList();
   
  }
}

form(){
  return Form(key:formkey ,
  child: Padding(
padding: EdgeInsets.all(5.0),
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize:MainAxisSize.min ,
  verticalDirection: VerticalDirection.down,
  children: <Widget>[
TextFormField(
  controller: controller,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(labelText: 'Reference facture ', hintText: 'entrer votre reference'),
  validator: (val)=>val.length==0?'enter Reference facture':null,
  onSaved: (val)=> ref=val,
),
DropdownButton<String>(
  isExpanded: true,
  
      hint: Text("Type Facture"),
      items: typefac.map<DropdownMenuItem<String>>((String value) {
       
        return DropdownMenuItem<String>(
          
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          dropdowntype = newValue;
          if(dropdowntype=="Autre"){
              isvisible=true;
          }else{
            isvisible=false;
          }
        });
      },
      value: dropdowntype,

    ),
Visibility(child: TextFormField(
onSaved: (val)=>nv=val,
controller: controller5,
keyboardType: TextInputType.text,
decoration: InputDecoration(labelText: 'Nouveaux Type ', hintText: 'Entrer Nouveaux Type'),
),
visible: isvisible,
),
  DateTimeField(
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
      TextFormField(
  controller: controller3,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Montant'),
  validator:  (val1)=>val1.length==0?'entrer Montant':null,
  onSaved: (val1)=> mont=double.parse(val1),
),
SizedBox(height: 10),
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
      
      label: Text(isupdate?'update':'Ajouter' ),
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
SingleChildScrollView dataTable(List<Achat> achats){
return SingleChildScrollView(
scrollDirection:  Axis.vertical,

child:SingleChildScrollView(
   scrollDirection: Axis.horizontal,

child: DataTable(
  sortAscending: true,
  columns: [
    DataColumn(
      label: Text('Type Facture',style: TextStyle(fontSize: 12.0)),
       ),
   
        DataColumn(
      label: Text('Action',style: TextStyle(fontSize: 12.0)),
       ),
    
  ],
  rows: achats.map((achat)=> DataRow(
    cells:[
     
       DataCell(
        Text(achat.type),
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
  builder: (context)=>Consulterach(achat)
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
    return
    DefaultTabController(
      length: 2,
      child:Scaffold(

      resizeToAvoidBottomPadding: false,
      appBar: new AppBar( 
        title: Center(
         child:Text("Achat      "), 
         
        ),
        bottom:TabBar(
tabs: <Widget>[
  Tab(
    text: " Ajouter Achat",
  ),
  Tab(
text: "Consulter Achat",
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
    
  }
}