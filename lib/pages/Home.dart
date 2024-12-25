import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/adminPage.dart';
import 'package:booking/pages/auth/auth_page.dart';
import 'package:booking/pages/agencies/firstAgency.dart';
//import 'package:booking/pages/home_page.dart';
import 'package:booking/pages/nav_pages/search_page.dart';
import 'package:booking/pages/nav_pages/setting_page.dart';
import 'package:booking/pages/users/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // drower signout
  bool showLoginPage = true;
  void togglePge() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void signOut() {
    setState(() {
      FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AuthPage();
      }));
    });
  }

  // index for naviagation bottom
  int _selectedIndex = 0;

  // function for navigation pages
  void _IndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages
  final List<Widget> _pages = [
    // HomePage ka u yeer hadadd agencies badan isku keenaysid.
    AgencyDetail(), // kan ku badal
    SettingPage(),
    SearchPage(),
    UserPage(),
  ];

  // Method to get current user's email
  Future<String?> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 15, left: 40),
            child: Image.asset(
              "lib/images/plane.png",
              height: 40,
              width: 40,
            ),
          ),
        ),
        actions: const [
          // Bar icons from Components folder
          RightIcons(),
        ],
      ),

      // Drawer Side
      drawer: Drawer(
        child: Container(
          color: Colors.teal[300],
          child: FutureBuilder<String?>(
            future: getCurrentUserEmail(), // Get current user's email
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              String? currentUserEmail = snapshot.data;

              return ListView(
                children: [
                  DrawerHeader(
                    child: Image.asset("lib/images/plane.png"),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                  ),
                  // Show Admin ListTile only if the current user's email is 'dere@gmail.com'
                  if (currentUserEmail == 'dere@gmail.com') ...[
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Admin",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Adminpage()));
                      },
                    ),
                  ],
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "About",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 360,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "logout",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () {
                      signOut();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),

      // Body
      body: _pages[_selectedIndex],
// Navigation Bottom
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: _IndexChanged,
        color:
            Colors.teal.shade300, // Change the background color of the navbar
        buttonBackgroundColor: Colors.teal, // Color for the center button
        backgroundColor: Colors.blue, // Background color of the navbar
      ),
    );
  }
}
