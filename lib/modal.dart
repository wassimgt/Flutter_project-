import 'package:easy_life/db/budget.dart';
import 'package:easy_life/db/dbhelp.dart';
import 'package:flutter/material.dart';

class Modal{
   TextEditingController controller= TextEditingController();
   double nom;
   
DBhelper dbhelper;
 
bool isupdate;
final formkey= new GlobalKey<FormState>();
  mainBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Ajouter un budget ",style :TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
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
    if(isupdate){
      //Budget a = Budget(iduser,nom,_dropdownValue2,mont,0.0,_dropdownValue);
      //dbhelper.update(a); 
      //setState(() { 
       // isupdate=false;
     // });
      //clearname();
    }else{
        Budget a = Budget(null,nom,0,0);
   dbhelper.savebd(a); 

        print("success");
       

    
    }
    clearname();
      // refreshList();
   
  }
}
form(){
  return Form(key:formkey ,
 
child: Column(

 
mainAxisAlignment: MainAxisAlignment.start,
 mainAxisSize: MainAxisSize.min, 
  children: <Widget>[
   
TextFormField(
  controller: controller,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Budget '),
  validator: (val)=>val.length==0?'enter  budget':null,
  onSaved: (val)=> nom=double.parse(val),
),


Row(
  
  children: <Widget>[
SizedBox(
  
  width: 350, // match_parent
  child: RaisedButton.icon(
      
      onPressed: validate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      label: Text('Ajouter' ),
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
  
}