class User {
  static const String collectionName= 'users';
  String? id;
  String? fullName;
  String? userName;
  String? email;

  User({
    this.id,
    this.fullName,
    this.userName,
    this.email
  });

  // This function is used to convert the object data to a map to make the data base understand it
  Map<String , dynamic> toJson(){
    return{
      'id' : id ,
      'fullName' : fullName ,
      'userName' : userName ,
      'email' : email ,
    };
  }

  // This function is used to convert the map data to an object to make the data object understand it
  User.fromJson(Map<String , dynamic>? json){
    id  = json?['id'];
    fullName  = json?['fullName'];
    userName  = json?['userName'];
    email  = json?['email'];
  }
}
