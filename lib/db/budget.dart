class Budget{
 double budget ;
 double reste ;
 int nb;
 int id ;
 Budget(this.id,this.budget,this.reste,this.nb);
  Map<String, dynamic> toMap(){
    
   var map =<String, dynamic>{

'id':id,
'budget':budget,
'reste':reste,
'nb':nb,
   };
   return map;
 }
  double get budgett =>budget;
 Budget.fromMap(Map<String, dynamic> map){
  id=map['id'];
  budget=map['budget'];
 reste=map['reste'];
  nb=map['nb'];

}
}