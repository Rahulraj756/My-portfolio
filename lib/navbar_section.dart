import 'package:flutter/material.dart';
import 'package:my_practice_app/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_practice_app/navlink_item.dart';

import 'Dashboard/admin_dashboard.dart'; // Admin dashboard ka import

class NavbarSection extends StatefulWidget {
  const NavbarSection({super.key});

  @override
  State<NavbarSection> createState() => _NavbarSectionState();
}

class _NavbarSectionState extends State<NavbarSection> {
  String logoText = 'PORTFOLIO';
  double logoFontSize = 20.0;
  Color logoColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadNavbarSettings(); // App khulte hi permanent local storage se data uthayega
  }

  // SharedPreferences se data load karne ka permanent function
  Future<void> _loadNavbarSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      logoText = prefs.getString('nav_title') ?? 'PORTFOLIO';
      logoFontSize = prefs.getDouble('nav_fontsize') ?? 20.0;
      int colorValue = prefs.getInt('nav_color') ?? Colors.white.toARGB32();
      logoColor = Color(colorValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen ki width check karenge (agar 700px se kam hai toh mobile view manenge)
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      height: 70,
      color: AppThemeColors.background,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMobile)
                Text(
                  logoText,
                  style: TextStyle(
                    color: logoColor,
                    fontSize: logoFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
            ],
          ),
          // Nav Links
          if (!isMobile)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavLinkItem(title: 'Home', onTap: () {}),
                  const SizedBox(width: 10),
                  NavLinkItem(title: 'About', onTap: () {}),
                  const SizedBox(width: 10),
                  NavLinkItem(title: 'Services', onTap: () {}),
                  const SizedBox(width: 10),
                  NavLinkItem(title: 'Projects', onTap: () {}),
                  const SizedBox(width: 10),
                  NavLinkItem(title: 'Pricing', onTap: () {}),
                  const SizedBox(width: 10),
                  NavLinkItem(title: 'Contact', onTap: () {}),
                ],
              ),
            ),
          // Admin Login Button
          if (!isMobile)
            ElevatedButton(
              onPressed: () async {
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
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: AppThemeColors.whiteText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          //  NAV MENU BAR
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: AppThemeColors.textPrimary),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Side drawer open karega
                },
              ),
            ),
        ],
      ),
    );
  }
}
