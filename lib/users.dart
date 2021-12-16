class User {
  String name;
  List<bool> restrictions;

  User(this.name, this.restrictions);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        restrictions = json['restrictions'];

  // factory User.fromJson(Map<String, dynamic> data){
  //   final nm = data['users']['name'] as String;
  //   final 
  // }

  Map<String, dynamic> toJson() => {
        'name': name,
        'restrictions': restrictions,
      };
}