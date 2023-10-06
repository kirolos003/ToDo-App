import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/users.dart';

class UserDao{
    static CollectionReference<User> getUsersCollection(){
      var db = FirebaseFirestore.instance; // This is used to create an object from the database
      // . collection(collection name) => used to check if there is a collection with this collection
      // name if so returns this collection in the variable collection and if there was no collection
      // with that name it will create a new collection with the passed collection name

      // withConvertor function is used to tell the database how to
      // make the conversion of an object to a map and vice versa
      // through the two functions we made => fromJson and toJson

      var usersCollection = db.collection(User.collectionName).withConverter(
        fromFirestore: (snapshot , options) => User.fromJson(snapshot.data()),
        toFirestore: (object , options) => object.toJson(),
      );
      return usersCollection; // return an object of the created or found collection of type CollectionReference<User>
    }

    static Future<void> createUser(User user){
      var usersCollection = getUsersCollection();
      var doc = usersCollection.doc(user.id); // create document with user id(of the authentication service)
      return doc.set(user);
  }

  static Future<User?> getUser(String uid) async{
    var doc =getUsersCollection().doc(uid);
    var docSnapshot = await doc.get();
    return docSnapshot.data();
  }
}

