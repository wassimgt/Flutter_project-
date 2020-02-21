  import 'dart:async';


import 'dart:core';
import 'dart:io' as io;

import 'package:easy_life/db/Cheque.dart';
import 'package:easy_life/db/budget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'artison.dart';
import 'achat.dart';
  
class DBhelper{

static Database _db;
static const String ID='id';
static const String Name='name';
static const String ETAT='etat';
static const String Reste='reste';
static const String MONTANT='montant';
static const String DESG='desgination';
static const String TABLE='Artison';
static const String TABLE2='Achat';
static const String TABLE3='Cheque';
static const String TABLE4='Budgets';
static const String  DB_NAME='easylifett.db';
String x;
Future<Database> get db async{
if(_db!=null){
  return _db;

}
_db=await initDb();
return _db;
}
initDb()async{
    io.Directory doc = await getApplicationDocumentsDirectory();
String path = join(doc.path,DB_NAME);

x=path;
var db=await(openDatabase(path,version:1,onCreate: _onCreate)) ;
  
return db;
}
_onCreate(Database db, int version)async{
  await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,$Name TEXT,$DESG TEXT,$MONTANT REAL,$Reste REAL ,$ETAT TEXT) ");
  await db.execute("CREATE TABLE $TABLE2 (id_achat INTEGER PRIMARY KEY,Reference INTEGER,type TEXT ,Montant REAL,$Reste REAL,Date_fact TEXT ,Etat TEXT) ");
  await db.execute("CREATE TABLE $TABLE3 (id_ch INTEGER PRIMARY KEY ,Reference_ch INTEGER ,Montant REAL, Date_ch TEXT ,id_art INTEGER,id_ach INTEGER,FOREIGN KEY(id_art) REFERENCES Artison(id),FOREIGN KEY(id_ach) REFERENCES Achat(id_achat))");
    await db.execute("CREATE TABLE $TABLE4 ($ID INTEGER PRIMARY KEY,budget REAL,$Reste REAL, nb INTEGER ) ");

}
Future<Artison> save(Artison artison )async{
  var dbclient =await db;
  artison.id=await dbclient.insert(TABLE, artison.toMap());
  return artison;
 
  }
  Future<Budget> savebd(Budget budget )async{
  
  var dbclient =await db;
  budget.id=await dbclient.insert(TABLE4, budget.toMap());
  return budget;
 
  }

  Future<Cheque> savechequebyart(Cheque cheque )async{
  var dbclient =await db;
  cheque.id_ch=await dbclient.insert(TABLE3, cheque.toMap());
  print("hcccc"+cheque.id_ch.toString());
  return cheque;
 //await dbclient.transaction((txn) async{
   // var query="insert into $TABLE3 (Reference_ch,Montant,Date_ch,id_art,id_ach) VALUES ('"+cheque.Reference_ch+"','"+cheque.Montant+"','"+ cheque.Date_ch+"','"+ cheque.id_art+"')";
//return await txn.rawInsert(query);

}
 Future<Cheque> savechequebyach(Cheque cheque )async{
  var dbclient =await db;
  cheque.id_ch=await dbclient.insert(TABLE3, cheque.toMap());
  print("hcccc"+cheque.id_ch.toString());
  return cheque;
 //await dbclient.transaction((txn) async{
   // var query="insert into $TABLE3 (Reference_ch,Montant,Date_ch,id_art,id_ach) VALUES ('"+cheque.Reference_ch+"','"+cheque.Montant+"','"+ cheque.Date_ch+"','"+ cheque.id_art+"')";
//return await txn.rawInsert(query);

  

}
Future<Achat> saveachat(Achat achat )async{
  var dbclient =await db;
  achat.id_achat=await dbclient.insert(TABLE2, achat.toMap());
  return achat;
 //await dbclient.transaction((txn) async{
   // var query="insert into $TABLE2 (Reference,Montant,Date_fact,Etat) VALUES ('"+achat.reference+"','"+achat.montants+"','"+ achat.date+"','"+ achat.etat+"')";
//return await txn.rawInsert(query);

 //});

}
 Future<List<Artison>> getNomart() async{
var dbClient = await db;
    String sql;
    sql = "SELECT DISTINCT desgination FROM $TABLE WHERE etat='Non payee'";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Artison> list = result.map((item) {
      return Artison.fromMap(item);
    }).toList();

   
    return list;
} 

Future<List<Artison>> getNomartbytype(String type) async{
var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $TABLE WHERE etat='Non payee' and desgination='"+type+"' ";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Artison> list = result.map((item) {
      return Artison.fromMap(item);
    }).toList();

   
    return list;
}
Future<List<Achat>> getNomachbytype(String type) async{
var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $TABLE2 WHERE etat='Non payee' and type='"+type+"' ";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Achat> list = result.map((item) {
      return Achat.fromMap(item);
    }).toList();

   
    return list;
}
Future<List<double>> getresteart(int id) async {
    var dbClient = await db;

    var results = await dbClient.rawQuery('SELECT reste FROM $TABLE Where id = \'$id\'');

    return results.map((Map<String, dynamic> row) {
      return row["reste"] as double;
    }).toList();
  }
  Future<List<double>> getresteach(int id) async {
    var dbClient = await db;

    var results = await dbClient.rawQuery('SELECT reste FROM $TABLE2 Where id_achat = \'$id\'');

    return results.map((Map<String, dynamic> row) {
      return row["reste"] as double;
    }).toList();
  }
Future<List<double>> getavance(int id) async {
    var dbClient = await db;

    var results = await dbClient.rawQuery('SELECT SUM(Montant) AS somme FROM Cheque Where id_art = \'$id\'');

    return results.map((Map<String, dynamic> row) {
      return row["somme"] as double;
    }).toList();
  }
  Future<List<double>> getsommecheque() async {
    var dbClient = await db;

    var results = await dbClient.rawQuery("SELECT SUM(Montant) AS somme FROM $TABLE3 ");

    return results.map((Map<String, dynamic> row) {
      return row["somme"] as double;
    }).toList();
  }
  Future<List<double>> getsommeach() async {
    var dbClient = await db;
String p="Payee";
    var results = await dbClient.rawQuery("SELECT SUM(Montant) AS somme FROM Achat Where etat='"+p+"'");

    return results.map((Map<String, dynamic> row) {
      return row["somme"] as double;
    }).toList();
  }
  Future<List<double>> getbudget() async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  var results= await dbClient.rawQuery("SELECT budget FROM $TABLE4");
 return results.map((Map<String, dynamic> row) {
      return row["budget"] as double;
    }).toList();
  }
   Future<List<int>> getbudgetid() async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  var results= await dbClient.rawQuery("SELECT id FROM $TABLE4");
 return results.map((Map<String, dynamic> row) {
      return row["id"] as int;
    }).toList();
  }
  Future<List<double>> getavanceachat(int id) async {
    var dbClient = await db;

    var results = await dbClient.rawQuery('SELECT SUM(Montant) AS somme FROM Cheque Where id_ach = \'$id\'');

    return results.map((Map<String, dynamic> row) {
      return row["somme"] as double;
    }).toList();
  }
  Future<List<String>> getachattype() async {
    var dbClient = await db;

    var results = await dbClient.rawQuery('SELECT DISTINCT type FROM $TABLE2 ');

    return results.map((Map<String, dynamic> row) {
      return row["type"] as String;
    }).toList();
  }
  
Future<List<Achat>> getNomach() async{
var dbClient = await db;
    String sql;
    sql = "SELECT DISTINCT type FROM $TABLE2 WHERE etat='Non payee'";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<Achat> list = result.map((item) {
      return Achat.fromMap(item);
    }).toList();

   
    return list;
}


Future<List<Achat>> gettypeachat() async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery("SELECT DISTINCT type FROM $TABLE2");
List<Achat> achat =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    achat.add(Achat.fromMap(maps[i]));
  }
}
return achat;
}

Future<List<Artison>> gettypeartison() async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery("SELECT DISTINCT desgination FROM $TABLE");
List<Artison> artisons =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    artisons.add(Artison.fromMap(maps[i]));
  }
}
return artisons;
}
Future<List<Artison>> getartison(String type) async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery("SELECT * FROM $TABLE WHERE desgination='"+type+"'  ");
List<Artison> artisons =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    artisons.add(Artison.fromMap(maps[i]));
  }
}
return artisons;
}
Future<List<Achat>> getachat(String type) async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery("SELECT * FROM $TABLE2 WHERE type='"+type+"'  ");
List<Achat> achat =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    achat.add(Achat.fromMap(maps[i]));
  }
}
return achat;
}
Future<List<Cheque>> getcheque(int id) async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery('SELECT * FROM Cheque Where id_art = \'$id\'');
List<Cheque> cheque =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    cheque.add(Cheque.fromMap(maps[i]));
  }
}
return cheque;
}
Future<List<Cheque>> getchequeachat(int id) async{
  var  dbClient =await db;
  //List<Map>maps=await dbClient.query(TABLE, columns: [ID,Name,DESG,MONTANT]);
  List<Map> maps= await dbClient.rawQuery('SELECT * FROM Cheque Where id_ach = \'$id\'');
List<Cheque> cheque =[];
if(maps.length>0){
  for(int i=0 ; i< maps.length;i++){
    cheque.add(Cheque.fromMap(maps[i]));
  }
}
return cheque;
}
 getartisonbyid(int id) async{
  var  dbClient =await db;
  var maps=await dbClient.query(TABLE, columns: [Name,DESG,MONTANT,ETAT],where:'$ID=?',whereArgs:[id] );
 // List<Map> maps= await dbClient.rawQuery("SELECT* FROM $TABLE where id="+id);
return maps.isNotEmpty ? Artison.fromMap(maps.first) : Null;
}


Future<int>delete(int id)async{
  var dbClient =await db;
  return await dbClient.delete(TABLE,where: '$ID=?',whereArgs:[id] );
}
Future<int>deleteach(int id)async{
  var dbClient =await db;
  return await dbClient.delete(TABLE2,where: 'id_achat=?',whereArgs:[id] );
}
Future <int> updateach(Achat achat)async{ 
  var dbClient =await db;
  return await dbClient.update(TABLE2, achat.toMap(),where:'id_achat=?',whereArgs: [achat.id_achat] );
}
Future <int> update(Artison artison)async{ 
  var dbClient =await db;
  return await dbClient.update(TABLE, artison.toMap(),where:'$ID=?',whereArgs: [artison.id] );
}
Future <int> updatebudget(Budget budget)async{ 
  var dbClient =await db;
  return await dbClient.update(TABLE4, budget.toMap(),where:'$ID=?',whereArgs: [budget.id] );
}
Future <int> updatetype(String type ,int id)async{ 
  var dbClient =await db;
  int updateCount = await dbClient.rawUpdate('''
    UPDATE $TABLE 
    SET etat = ? 
    WHERE id = ?
    ''', 
    [type, id]);
  return updateCount;
}
Future <int> updatetypeach(String type ,int id)async{ 
  var dbClient =await db;
  int updateCount = await dbClient.rawUpdate('''
    UPDATE $TABLE2 
    SET etat = ? 
    WHERE id_achat = ?
    ''', 
    [type, id]);
  return updateCount;
}
Future <int> updatereste(double type ,int id)async{ 
  var dbClient =await db;
  int updateCount = await dbClient.rawUpdate('''
    UPDATE $TABLE 
    SET reste = ? 
    WHERE id = ?
    ''', 
    [type, id]);
  return updateCount;
}
Future <int> updateresteach(double type ,int id)async{ 
  var dbClient =await db;
  int updateCount = await dbClient.rawUpdate('''
    UPDATE $TABLE2 
    SET reste = ? 
    WHERE id_achat = ?
    ''', 
    [type, id]);
  return updateCount;
}


Future close()async{
  var dbclient= await db;
  dbclient.close();

}

}