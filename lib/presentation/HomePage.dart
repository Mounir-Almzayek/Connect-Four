import 'package:connectfour/presentation/AccountPage.dart';
import 'package:connectfour/presentation/GamePage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 187, 25, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: SizedBox(
                  height: 190,
                  child: Image.asset(
                    'assets/images/Logo.png',
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 115),
                child: const Text(
                  'Connect Four',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    height: 0.8,
                    color: Color(0xFF4D47C3),
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
                      _showDifficultyDialog();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      padding: EdgeInsets.symmetric(vertical: 17),
                    ),
                    child: const Text(
                      'Play!',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFFFFF),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()),);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    padding: EdgeInsets.symmetric(vertical: 17),
                  ),
                  child: const Text(
                    'More Information',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0x8A000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Difficulty'),
          content: Text('Select the difficulty level for the AI.'),
          actions: [
            Column(
              children: [
                _buildDifficultyOption('Easy', 1, Icons.face, 0),
                _buildDifficultyOption('Medium', 3, Icons.sentiment_very_satisfied, 1),
                _buildDifficultyOption('Hard', 5, Icons.sentiment_neutral, 2),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultyOption(String label, int depth, IconData icon, int point) {
    return ListTile(
      leading: Icon(
          icon,
          color: Color(0xFF4D47C3)
      ),
      title: Text(
        label,

      ),
      trailing:Text(
        '${point} xp',
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0x8A000000),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(maxDepth: depth),
          ),
        );
      },

    );
  }
}
