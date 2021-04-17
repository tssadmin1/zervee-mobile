import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;
  
  Future<UserCredential> signinWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future signOut() async{
    if(_auth!=null)
     _auth.signOut();
    
  }
    

}