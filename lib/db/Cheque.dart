class Cheque {
int id_ch;
String Reference_ch;
double Montant;
String Date_ch;
int id_art;
int id_ach;

Cheque(this.id_ch,this.Reference_ch,this.Montant,this.Date_ch,this.id_art,this.id_ach);
Map<String, dynamic> toMap(){
   var map =<String, dynamic>{
'id_ch':id_ch,
'Reference_ch':Reference_ch,
'Montant':Montant,
'Date_ch':Date_ch,
'id_art':id_art,
'id_ach':id_ach,
   };
   return map;
 }
Cheque.fromMap(Map<String, dynamic> map){
   id_ch=map['id_ch'];
  Reference_ch=map['Reference_ch'];
  Montant=map['Montant'];
  Date_ch=map['Date_ch'];
  id_art=map['id_art'];
  id_ach=map['id_ach'];
}

}