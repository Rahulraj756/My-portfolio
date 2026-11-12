import 'package:flutter/material.dart';
import 'package:my_practice_app/Dashboard/admin_dashboard.dart';
import 'package:my_practice_app/Screens/Sections/hero_section.dart';
import 'package:my_practice_app/theme_colors.dart';

import 'navbar_section.dart';

void main() {
  runApp(const NavbarDemo());
}

class NavbarDemo extends StatefulWidget {
  const NavbarDemo({super.key});

  @override
  State<NavbarDemo> createState() => _NavbarDemoState();
}

class _NavbarDemoState extends State<NavbarDemo> {
  Future<void> _loadNavbarSettings() async {
    setState(() {
      // Refresh the navbar data after returning from admin dashboard.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        // Mobile view ke liye side drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Text(
                  'Navigation Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const ListTile(leading: Icon(Icons.home), title: Text('Home')),
              const ListTile(leading: Icon(Icons.info), title: Text('About')),
              const ListTile(
                leading: Icon(Icons.design_services),
                title: Text('Services'),
              ),
              const ListTile(
                leading: Icon(Icons.work),
                title: Text('Projects'),
              ),
              const ListTile(
                leading: Icon(Icons.price_change),
                title: Text('Pricing'),
              ),
              const ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text('Contact'),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboard(),
                      ),
                    );
                    _loadNavbarSettings(); // Admin se wapas aate hi naya data reload ho jayega
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeColors.primaryAccent,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: AppThemeColors.whiteText,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView(children: const [NavbarSection(), HeroSection()]),
      ),
    );
  }
}
