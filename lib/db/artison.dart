

class Artison {
int id ;
String  name ;
String desgination ;
double montant ;
double reste ;
String etat;
Artison(this.id,this.name,this.desgination,this.montant,this.reste,this.etat);
 Map<String, dynamic> toMap(){
   var map =<String, dynamic>{

'id':id,
'name':name,
'desgination':desgination,
'etat':etat,
'montant':montant,
'reste':reste,

   };
   return map;
 }
 String get nom => name ;
 String get desg =>desgination;
 String get eta =>etat;
 double get mont =>montant;
 int get ida => id;


Artison.fromMap(Map<String, dynamic> map){
  id=map['id'];
  name=map['name'];
 etat=map['etat'];
  montant=map['montant'];
  desgination=map['desgination'];
  reste=map['reste'];
}
 
}