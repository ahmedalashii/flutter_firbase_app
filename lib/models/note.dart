class Note{
  late String id;
  late String title;
  late String info;

  Note();

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = <String,dynamic>{};
    map["title"] = title;
    map["info"] = title;
    return map;
  }
}