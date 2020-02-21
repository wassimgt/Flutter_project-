class Achat {
int id_achat;
String Reference;
String type;
double Montant;
double reste ;
String Date_fact;
String Etat;
Achat(this.id_achat,this.Reference,this.type,this.Montant,this.Date_fact,this.Etat,this.reste);
Map<String, dynamic> toMap(){
   var map =<String, dynamic>{
'id_achat':id_achat,
'Reference':Reference,
'type':type,
'reste':reste,
'Montant':Montant,
'Date_fact':Date_fact,
'Etat':Etat,

   };
   return map;
 }
Achat.fromMap(Map<String, dynamic> map){
   id_achat=map['id_achat'];
  Reference=map['Reference'];
  Montant=map['Montant'];
  type=map['type'];
 Etat=map['Etat'];
  Date_fact=map['Date_fact'];
  reste=map['reste'];
  
}

}