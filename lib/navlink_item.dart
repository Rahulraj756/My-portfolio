import 'package:flutter/material.dart';
import 'package:my_practice_app/theme_colors.dart';

class NavLinkItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const NavLinkItem({super.key, required this.title, required this.onTap});

  @override
  State<NavLinkItem> createState() => _NavLinkItemState();
}

class _NavLinkItemState extends State<NavLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _isHovered
                      ? AppThemeColors.primaryAccent
                      : const Color(0xFF0F172A), // Dark text for light theme
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
