import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectfour/presentation/HomePage.dart';
import 'package:connectfour/presentation/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final List<Map<String, dynamic>> userRankings = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  User? currentUser;
  String? uid;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final ScrollController _outerScrollController = ScrollController();
  final ScrollController _innerScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    uid = currentUser?.uid;

    fetchUserRankings().then((rankings) {
      setState(() {
        userRankings.addAll(rankings);
      });
    });

    fetchCurrentUserData().then((data) {
      setState(() {
        userData = data;
        isLoading = false; // Data fetching completed
      });
    }).catchError((error) {
      print("Error fetching user data: $error");
      setState(() {
        isLoading = false; // Data fetching completed with error
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
            controller: _outerScrollController,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 62, 20, 72),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFF4EFFA)),
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFFDFCFE),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A1E1E1E),
                            offset: Offset(-3, 0),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Color(0x1A1E1E1E),
                            offset: Offset(0, 3),
                            blurRadius: 3.5,
                          ),
                          BoxShadow(
                            color: Color(0x171E1E1E),
                            offset: Offset(0, 13),
                            blurRadius: 6.5,
                          ),
                          BoxShadow(
                            color: Color(0x0D1E1E1E),
                            offset: Offset(0, 29),
                            blurRadius: 9,
                          ),
                          BoxShadow(
                            color: Color(0x031E1E1E),
                            offset: Offset(0, 52),
                            blurRadius: 10.5,
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(23, 23, 23, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/images/avatar.png',
                                          fit: BoxFit.cover,
                                          width: 300,
                                          height: 300,
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  isLoading?
                                                  'Loading..':
                                                  userData!['username'] ?? 'No Username',
                                                  style: const TextStyle(
                                                    fontFamily: 'Heebo',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    height: 1.3,
                                                    color: Color(0xFF38343D),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              isLoading?
                                              'Loading..':
                                              userData!['email'] ?? 'No Email',
                                              style: const TextStyle(
                                                fontFamily: 'Heebo',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                height: 1.3,
                                                color: Color(0xFF686071),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
                              child: SizedBox(
                                height: 200,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 5.5, 0, 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: const Text(
                                          'PLAYER LEVEL',
                                          style: TextStyle(
                                            fontFamily: 'Heebo',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            height: 1,
                                            letterSpacing: 0.5,
                                            color: Color(0xFF797085),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: SizedBox(
                                          height: 140,
                                          child: SvgPicture.asset(
                                            'assets/svgs/level.svg',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child:Text(
                                          isLoading?
                                          'Loading..':
                                          '${userData!['winsCount']} Wins!',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24,
                                            height: 0.8,
                                            color: Color(0xFF4D47C3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'SCOREBOARD',
                                        style: TextStyle(
                                          fontFamily: 'Heebo',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 1,
                                          letterSpacing: 0.5,
                                          color: Color(0xFF797085),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      controller: _innerScrollController,
                                      itemCount: userRankings.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: ListTile(
                                            title: Text(
                                              userRankings[index]['username'],
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                height: 0.8,
                                                color: Color(0x8A000000),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            leading: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                height: 0.8,
                                                color: Color(0x8A000000),
                                              ),
                                            ),
                                            trailing: Text(
                                              '${userRankings[index]['winsCount']}W',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16,
                                                height: 0.8,
                                                color: Color(0xFF4D47C3),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: _scrollToBottom,
                                      child: Icon(Icons.expand_circle_down),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 33),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Color(0xFF4D47C3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x664D47C3),
                            offset: Offset(0, 4),
                            blurRadius: 30.5,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: const Color(0xFF4D47C3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x664D47C3),
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            padding: EdgeInsets.symmetric(vertical: 17),
                          ),
                          child: const Text(
                            'Go!',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF8EDED),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x2B000000),
                            offset: Offset(0, 3),
                            blurRadius: 1.5,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          signOutFromGoogleAndFirebase(context);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          padding: EdgeInsets.symmetric(vertical: 17),
                        ),
                        child: const Text(
                          'sign out',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFFBF3131),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserRankings() async {
    // Create a reference to the 'users' collection
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    // Get the documents ordered by 'winsCount' in descending order
    QuerySnapshot querySnapshot = await usersRef.orderBy('winsCount', descending: true).get();

    // Convert the documents into a list of maps
    List<Map<String, dynamic>> userRankings = querySnapshot.docs.map((doc) {
      return {
        'username': doc['username'],
        'winsCount': doc['winsCount'],
      };
    }).toList();

    return userRankings;
  }

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    if (uid != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    }
    return null;
  }

  void signOutFromGoogleAndFirebase(BuildContext context) async {
    try {
      // Show a loading indicator or a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing out...')),
      );

      // Sign out from Google
      await _googleSignIn.signOut();

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to sign-in page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
            (Route<dynamic> route) => false,
      );
    } catch (error) {
      // Handle errors
      print("Error signing out: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while signing out. Please try again.')),
      );
    }
  }
  void _scrollToBottom() {
    if (_outerScrollController.hasClients) {
      _outerScrollController.animateTo(
        _outerScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
