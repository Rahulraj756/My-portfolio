import 'package:flutter/material.dart';
import 'package:my_practice_app/Dashboard/hero_section_admin.dart';
import 'package:my_practice_app/Dashboard/navbar_section_admin.dart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dashboard sections ki list
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Navbar Section',
        'subtitle': 'Manage title, font size & color',
        'icon': Icons.navigation_rounded,
        'accentColor': Colors.cyanAccent,
        'onTap': (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavbarAdminScreen()),
          );
        },
      },
      {
        'title': 'Hero Section',
        'subtitle': 'Manage heading & subtitle',
        'icon': Icons.person_outline_rounded,
        'accentColor': Colors.amberAccent,
        'onTap': (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HeroAdminScreen()),
          );
        },
      },
      {
        'title': 'Services Section',
        'subtitle': 'Manage services list (Kal banega)',
        'icon': Icons.design_services_rounded,
        'accentColor': Colors.greenAccent,
        'onTap': (context) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Services section kal banega!')),
          );
        },
      },
      {
        'title': 'Projects Section',
        'subtitle': 'Manage portfolio projects (Kal banega)',
        'icon': Icons.work_rounded,
        'accentColor': Colors.pinkAccent,
        'onTap': (context) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Projects section kal banega!')),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard Hub',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF1E1E24),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Select Section to Customize',
              style: MediaQuery.of(context).size.width > 800
                  ? const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      letterSpacing: 0.5,
                    )
                  : const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      letterSpacing: 0.5,
                    ),
            ),
            const SizedBox(height: 24),

            // Wrap widget use karne se cards content ke hisab se automatic adjust honge
            Wrap(
              spacing: 16.0, // Cards ke beech horizontal gap
              runSpacing: 16.0, // Cards ke beech vertical gap
              children: dashboardItems.map((item) {
                return SizedBox(
                  // Laptop par ek row mein 4 cards fit karne ke liye width adjust ki hai
                  width: MediaQuery.of(context).size.width > 800
                      ? (MediaQuery.of(context).size.width - 48 - 48) / 4
                      : (MediaQuery.of(context).size.width - 48 - 16) / 1,
                  child: _buildWrapCard(
                    context,
                    title: item['title'],
                    subtitle: item['subtitle'],
                    icon: item['icon'],
                    accentColor: item['accentColor'],
                    onTap: () => item['onTap'](context),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Wrap ke liye flexible card layout jski height content par depend karegi
  Widget _buildWrapCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Height sirf content ke hisab se hogi
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 26),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
