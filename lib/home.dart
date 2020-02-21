import 'package:device_preview/device_preview.dart';
import 'package:easy_life/Ajout_Achat.dart';
import 'package:easy_life/Ajout_artison.dart';

import 'package:toast/toast.dart';
import 'package:easy_life/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Ajouter_cheque.dart';
import 'db/budget.dart';
import 'db/dbhelp.dart';




void main() => runApp( MyApp1());

class MyApp1 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      builder: DevicePreview.appBuilder,
      title: 'Easy Life',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
        primaryColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: <String , WidgetBuilder> {
        "/a": (BuildContext context )=> new Ajoutart(false),
  
         "/c":(BuildContext context )=> new Ajoutach(),
          "/d":(BuildContext context )=> new Ajouterch(),
            // "/e":(BuildContext context )=> new Consulterach(),
      });
  }
  
}

class MyHomePage extends StatefulWidget {
 
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller= TextEditingController();
   double budget;
   bool isvisible=true;
DBhelper dbhelper;
 List<double> budg;
 List<int> id;
 List<double> sommeartison;
 List<double> sommeachat;
 String bd;
 double reste;
bool isupdate;
GlobalKey<RefreshIndicatorState> refreshKey;
final formkey= new GlobalKey<FormState>();
@override
void initState(){
  super.initState();
   refreshKey = GlobalKey<RefreshIndicatorState>();
 dbhelper= new DBhelper();
   isupdate=false;
  isvisible=true;
   clearname();
   refresh();

}
refreshreste() async{
  setState(() {
    dbhelper.getsommecheque().then((onValue2){

  if(onValue2!=null)
{
  sommeachat=onValue2;
  setState(() {
      reste=budg[0]-sommeachat[0];
  });

}else{
  reste=0;
}
});
  });


}
 refresh() async{
 setState(() {
   dbhelper.getbudget().then((budgett){
  setState(() {
    if(budgett!=null){

  budg=budgett;
  bd=budg[0].toString();
isvisible=false;
  dbhelper.getbudgetid().then((onValue){
if(onValue!=null){
id=onValue;
}
print("id"+id[0].toString()
);

  });

refreshreste();

}
else{
  budg=[0];
  bd="0";
isvisible=true;
}
  });


});
 });
  
}
Future<Null> refreshList() async {
   await Future.delayed(Duration(seconds: 2));
   refreshreste();
   return null;
 }

Container _paypalCard(context) {
  return Container(
    margin: EdgeInsets.all(15),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white,
      border:
          Border.all(color: Colors.white, width: 0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      boxShadow: [
        BoxShadow(
            color: PaypalColors.LightGrey19,
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 1)
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset('assets/img.png', height: 30),
                SizedBox(width: 20),
                Text(
                  'Mon Budget',
                  style: TextStyle(
                      color: PaypalColors.DarkBlue,
                      fontFamily: "worksans",
                      fontSize: 15),
                ),
              ],
            ),
            IconButton(icon: Icon(Icons.edit, size: 18), onPressed: (){
                  isupdate=true;
                  mainBottomSheet(context);
              controller.text=bd.toString();
            })
     
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/chip_thumb.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'TND',
                      style: TextStyle(fontFamily: "vistolsans", fontSize: 25),
                    ),
                    SizedBox(width: 13),
                    Text( budg!=null?bd.toString()+"00":"0",
                      style: TextStyle(fontFamily: "sfprotext", fontSize: 30),
                    ),
                    SizedBox(width: 13),
                  ],
                ),
                Text(
                  'Available',
                  style: TextStyle(
                      fontFamily: "worksans",
                      color: PaypalColors.Grey,
                      fontSize: 17),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20),
       
      ],
    ),
  );
}
Container restt(context) {
  return Container(
    margin: EdgeInsets.all(15),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white,
      border:
          Border.all(color: Colors.white, width: 0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      boxShadow: [
        BoxShadow(
            color: PaypalColors.LightGrey19,
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 1)
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset('assets/rest.png', height: 30),
                SizedBox(width: 20),
                Text(
                  'Mon Reste',
                  style: TextStyle(
                      color: PaypalColors.DarkBlue,
                      fontFamily: "worksans",
                      fontSize: 20),
                ),
              ],
            ),
          
     
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/chip_thumb.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'TND',
                      style: TextStyle(fontFamily: "vistolsans", fontSize: 25),
                    ),
                    SizedBox(width: 13),
                    Text(reste!=null?reste.toString()+"00":"0",
                      style: TextStyle(fontFamily: "sfprotext", fontSize: 30),
                    ),
                    SizedBox(width: 13),
                  ],
                ),
                Text(
                  'Available',
                  style: TextStyle(
                      fontFamily: "worksans",
                      color: PaypalColors.Grey,
                      fontSize: 17),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20),
       
      ],
    ),
  );
}
  mainBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(isupdate?'Update Budget ':'Ajouter Budget',style :TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: "vistolsans")),
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
    if(isupdate==true){
      Budget a = Budget(id[0],budget,reste,0);
      dbhelper.updatebudget(a); 

      setState(() { 
        isupdate=false;
      });
    
refresh();
Navigator.of(context).pop();
    }else{
      print(budget);
        Budget bd =  new Budget(null,budget,0.0,0);
        dbhelper.savebd(bd); 
        isvisible=false;
        print("success");
        Navigator.of(context).pop();
      Toast.show("Success Insert", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.blueAccent);
      refresh();

    }
    clearname();
    

   //Navigator.push(context,MaterialPageRoute(
  //builder: (context)=>MyHomePage()
//));
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
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Budget '),
  validator: (val)=>val.length==0?'enter  budget':null,
  onSaved: (val)=> budget=double.parse(val),
),),] 
),  


Row(
  
  children: <Widget>[
SizedBox(
  
  width: 350, // match_parent
  child: RaisedButton.icon(
      
      onPressed: validate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      label: Text(isupdate?'update':'Ajouter'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
      title: new Text("Easy Life"),
      elevation: defaultTargetPlatform==TargetPlatform.android? 5.0 :0.0,
      ),
     drawer: new Drawer(
       child:  new ListView(
         children: <Widget>[
          
           new UserAccountsDrawerHeader(
             otherAccountsPictures: <Widget>[
               
             ],
             accountName: new Text("EASY LIFE"),
             accountEmail: Text("Suivie votre Budget"),
currentAccountPicture: Image.asset("assets/logo.png"),

           ),
          

           new ListTile(
             title:  new Text("Artison"),
             trailing:  new Icon(Icons.add),
             onTap: ()=>Navigator.of(context).pushNamed("/a"),
           ),
            new ListTile(
             title:  new Text("Achat"),
             trailing:  new Icon(Icons.add),
              onTap: ()=>Navigator.of(context).pushNamed("/c"),
           ),
            new ListTile(
             title:  new Text("Ajouter Avance"),
             trailing:  new Icon(Icons.payment),
             onTap: ()=>Navigator.of(context).pushNamed("/d"),
           ),
           
         
           new Divider(),
              new ListTile(
             trailing:  new Icon(Icons.close),
             title:  new Text("Close"),
    
             onTap:()=>Navigator.of(context).pop() ,
           ),
           
         ],
       ),
     ),
      body:RefreshIndicator(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _paypalCard(context),
           restt(context),
        ],
      ),key: refreshKey,
        onRefresh: () async {
         
        await refreshList(); 
         
          
        },) ,
      //con
      
      floatingActionButton: 
     new Visibility(
       child:
     
 FloatingActionButton(
        onPressed: (){
           
             clearname();
             mainBottomSheet(context);
           
        },
       
        child: Icon(Icons.add),
      ),
      
     
      visible: isvisible,
      ),
      
    );
  }
}











