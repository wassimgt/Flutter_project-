import 'package:easy_life/db/Cheque.dart';
import 'package:easy_life/db/achat.dart';
import 'package:easy_life/db/artison.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:easy_life/db/dbhelp.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
class Ajouterch extends StatefulWidget {
  
  @override
  _AjouterchState createState() => _AjouterchState();
  
}
  Achat _currentAchat,_currentAchat2;
 
class _AjouterchState extends State<Ajouterch> {
    Future<List<Artison>> artisons;
     Future<List<Achat>> achat;
   final format = DateFormat("dd-MM-yyyy");
   final format2 = DateFormat("dd-MM-yyyy");
      TextEditingController controller= TextEditingController();

      TextEditingController controller2= TextEditingController();

      TextEditingController controller3= TextEditingController();

      TextEditingController controller4= TextEditingController();

  

      TextEditingController controller22= TextEditingController();

      TextEditingController controller33= TextEditingController();

      TextEditingController controller44= TextEditingController();
      final formkey= new GlobalKey<FormState>();
      final formkey2= new GlobalKey<FormState>();
      String ref;
      DateTime dat,dat2;
            String ref2;
double mont , mont2;
      int iduser;
      bool isupdate;
      DBhelper dbhelper;
      Artison _currentArtison,_currentArtison2;
    List<double> rest,rest2;
     Future<List<Artison>> typeart;
     Future<List<Achat>>  typeach;
//List<DropdownMenuItem<String>> list ;
@override
void initState(){
 
  dbhelper= new DBhelper();

refrechget();
  
  isupdate=false; 
// listbox();

  super.initState();
  
}
refrechget()async{
setState(() {
  typeart=dbhelper.getNomart();
  typeach=dbhelper.getNomach();
});
}

clearname(){
  
  controller2.text='';
  controller3.text='';
  controller4.text='';
 
}
clearname2(){
  
  controller22.text='';
  controller33.text='';
  controller44.text='';
}

validate(){
  if(formkey.currentState.validate()){
    formkey.currentState.save();
      String dt= format.format(dat);
        Cheque a = Cheque(null,ref,mont,dt,_currentArtison2.id,null);
     dbhelper.savechequebyart(a);
if(_currentArtison2.reste==0){
  dbhelper.updatereste(_currentArtison2.montant-mont,_currentArtison2.id);
   Toast.show("Success update1",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
   setState(() {
      dbhelper.getresteart(_currentArtison2.id).then((onValue){
      if(onValue!=null){

        rest=onValue;
        if(rest[0]==0){
          setState(() {
            dbhelper.updatetype("Payee",_currentArtison2.id);
          print("typemodifier"+rest[0].toString());
          Navigator.push(context,MaterialPageRoute(
  builder: (context)=>Ajouterch(),
));
          });
          
        }
      }
   });
   });

}
else
{
  dbhelper.updatereste(_currentArtison2.reste-mont, _currentArtison2.id);
    
      dbhelper.getresteart(_currentArtison2.id).then((onValue){
      if(onValue!=null){

        rest=onValue;
        if(rest[0]==0){
          setState(() {
             dbhelper.updatetype("Payee",_currentArtison2.id);
          print("typemodifier"+rest[0].toString());

          });
         
        }
      }

   });
   Toast.show("Success update2",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
 
}
     
  
        //Toast.show("Success Insert",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);

 
    typeart=dbhelper.gettypeartison();
    artisons=dbhelper.getNomartbytype(_currentArtison.desgination);
    clearname();
   
    
   
  }
}
validate1(){
  if(formkey2.currentState.validate()){
    formkey2.currentState.save();
    
    String dt2= format.format(dat2);
    Cheque a = Cheque(null,ref2,mont2,dt2,null,_currentAchat2.id_achat);
     dbhelper.savechequebyart(a);
  if(_currentAchat2.reste==0){
      dbhelper.updateresteach(_currentAchat2.Montant-mont2,_currentAchat2.id_achat);
      Toast.show("Success update1",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
     setState(() {
        dbhelper.getresteach(_currentAchat2.id_achat).then((onValue){
        if(onValue!=null){

            rest2=onValue;
            if(rest2[0]==0){
            setState(() {
              dbhelper.updatetypeach("Payee",_currentAchat2.id_achat);
              print("typemodifier"+rest2[0].toString());
               });

        }
      }
   });
   });

}else{
  dbhelper.updatereste(_currentAchat2.reste-mont2, _currentAchat2.id_achat);
     setState(() {
      dbhelper.getresteach(_currentAchat2.id_achat).then((onValue){
      if(onValue!=null){

        rest2=onValue;
        if(rest2[0]==0){
          setState(() {
            dbhelper.updatetypeach("Payee",_currentAchat2.id_achat);
          print("typemodifier"+rest2[0].toString());
          });
          
        }
      }
   });
   });
   Toast.show("Success update2",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
}
       // print("success achat");
       // Toast.show("Success Insert",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.greenAccent);
       // print("xxxxxxxxxxxxxxxxxxxxxxx"+dbhelper.x);
     setState(() {
       typeach=dbhelper.getNomach();
    achat=dbhelper.getNomachbytype(_currentAchat.type); 
     });
          Navigator.push(context,MaterialPageRoute(
  builder: (context)=>Ajouterch(),
));
    clearname2();
      // refreshList();
   
  }
}
 form(){
  return Form(key:formkey ,
  child: Padding(
padding: EdgeInsets.all(15.0),
child:Column(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize:MainAxisSize.min ,
 
  
  children: <Widget>[
    
FutureBuilder<List<Artison>>(
                future: typeart,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Artison>> snapshot) {

                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Artison>(
                    items: snapshot.data
                        .map((user) => DropdownMenuItem<Artison>(
                        
                              child: Text(user.desgination),
                              value: user,
                            
                            ))
                        .toList(),
                        
                    onChanged: (Artison value) {
                      setState(() {
                        _currentArtison = value;
                        artisons=dbhelper.getNomartbytype(_currentArtison.desgination);
                      });
                    },
                    
                // value: _currentUser,
                    isExpanded: true,
                    
                    hint: Text('Select type'),
                  );
                }),
                            SizedBox(height: 20.0),
                          
            _currentArtison != null
                ? Text(
                    "Type: " +
                        _currentArtison.desgination.toString(),style: TextStyle(fontSize: 15.0), )
                     
                : Text("No type selected"),
 FutureBuilder<List<Artison>>(
                future: artisons,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Artison>> snapshot) {

                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Artison>(
                    items: snapshot.data
                        .map((user) => DropdownMenuItem<Artison>(
                        
                              child: Text(user.name),
                              value: user,
                            
                            ))
                        .toList(),
                        
                    onChanged: (Artison value) {
                      setState(() {
                        _currentArtison2 = value;
                      
                      });
                    },
                    
                // value: _currentUser,
                    isExpanded: true,
                    
                    hint: Text('Select Artison'),
                  );
                }),
                            SizedBox(height: 20.0),
                          
            _currentArtison2 != null
                ? Text(
                    "Name: " +
                        _currentArtison2.name.toString(),style: TextStyle(fontSize: 15.0), )
                     
                : Text("No Artison selected"),
TextFormField(
  controller: controller2,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(labelText: 'Reference cheque'),
  validator: (val)=>val.length==0?'enter Reference':null,
  onSaved: (val)=> ref=val,
),
 DateTimeField(
    
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(labelText: 'Date Cheque'),
         validator: (val1)=>val1==null?'Enter Date cheque':null,
        onSaved: (val1)=> dat=val1,
      ),

TextFormField(
  controller: controller3,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Montant'),
  validator:  (val1){
if(val1.length==0){
  return'enter Montant';
}else{
  if(_currentArtison2.montant< double.parse(val1)){
    return'le Montant saisie est superieur au Montant totale';

  }
  if(_currentArtison2.reste!=0.0){
  if(double .parse(val1)>_currentArtison2.reste){
    return'le Montant saisie est superieur au reste ';
  }}
  return null;
}

  },
  onSaved: (val1)=> mont= double .parse(val1),
),
  

 SizedBox(height: 20),
Row(
  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    RaisedButton.icon(
      onPressed: validate,
      
      label: Text('Ajouter' ),
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

form1(){
  return Form(key:formkey2 ,
  child: Padding(
padding: EdgeInsets.all(15.0),
child:Column(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize:MainAxisSize.min ,
  verticalDirection: VerticalDirection.down,
  
  children: <Widget>[
    
FutureBuilder<List<Achat>>(
                future: typeach,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Achat>> snapshot) {

                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Achat>(
                 
                          
                    items: snapshot.data
                        .map((user) => DropdownMenuItem<Achat>(
                        
                              child: Text(user.type),
                              value: user,
                            
                            ))
                        .toList(),
                        
                    onChanged: (Achat value) {
                      setState(() {
                        _currentAchat = value;
                        achat=dbhelper.getNomachbytype(_currentAchat.type);
                      });
                    },
                   
                // value: _currentUser,
                    isExpanded: true,
                    
                    hint: Text('Select Type Facture'),
                  );
                }),
                            SizedBox(height: 20.0),
                          
            _currentAchat != null
                ? Text(
                    "Type: " +
                        _currentAchat.type )
                     
                : Text("No Type selected"),
 FutureBuilder<List<Achat>>(
                future: achat,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Achat>> snapshot) {

                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<Achat>(
                 
                          
                    items: snapshot.data
                        .map((user) => DropdownMenuItem<Achat>(
                        
                              child: Text(user.Reference),
                              value: user,
                            
                            ))
                        .toList(),
                        
                    onChanged: (Achat value) {
                      setState(() {
                        _currentAchat2 = value;
                      });
                    },
                     value:null ,
                // value: _currentUser,
                    isExpanded: true,
                    
                    hint: Text('Select Reference Facture'),
                  );
                }),
                            SizedBox(height: 20.0),
                          
            _currentAchat2 != null
                ? Text(
                    "Reference: " +
                        _currentAchat2.Reference )
                     
                : Text("No Reference selected"),
 
TextFormField(
  controller: controller22,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(labelText: 'Reference cheque'),
  validator: (val)=>val.length==0?'enter Reference':null,
  onSaved: (val)=> ref2=val,
),

 DateTimeField(
    
        format: format2,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        decoration: InputDecoration(labelText: 'Date Cheque'),
         validator: (val1)=>val1==null?'Enter Date cheque':null,
        onSaved: (val1)=> dat2=val1,
      ),

TextFormField(
  controller: controller33,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Montant'),
  validator:  (val1){
if(val1.length==0){
  return'enter Montant';
}else{
  if(_currentAchat2.Montant< double.parse(val1)){
    return'le Montant saisie est superieur au Montant totale';

  }
  if(_currentAchat2.reste!=0.0){
  if(double .parse(val1)>_currentAchat2.reste){
    return'le Montant saisie est superieur au reste ';
  }}
  return null;
}

  },
  onSaved: (val1)=> mont2=double.parse(val1) ,
),
 SizedBox(height: 10),
Row(
  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    RaisedButton.icon(
      onPressed: validate1,
      
      label: Text('Ajouter' ),
       icon: Icon(Icons.add),
        color: Colors.blue[500],
    ),
     RaisedButton.icon(
       icon: Icon(Icons.close),
      onPressed: (){
        setState(() {
          isupdate=false;
        });
        clearname2();
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




  @override
  Widget build(BuildContext context) { 
    return DefaultTabController(
      length: 2,
      child:Scaffold(

      resizeToAvoidBottomPadding: false,
      appBar: new AppBar( 
        title: Center(
         child:Text("Ajouter Chéque      "), 
         
        ),
        bottom:TabBar(
tabs: <Widget>[
  Tab(
    text: "Artison",
  ),
  Tab(
text: "Achat",
  ),
],

        ) ,
      
      ),
      
      body:TabBarView(
        
        children: <Widget>[

          Container(
            
              margin: EdgeInsets.all(0),
              child: form(),
          ),
          Container(
             margin: EdgeInsets.all(0),
              child: form1(),
          ),
        ],
      ),
         
     
 
   ),
  
      


    );
    
    
     
  }

}