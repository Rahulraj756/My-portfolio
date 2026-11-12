import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme_colors.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  String heroTitle = 'Hi, I am Rahul Raj';
  String heroSubtitle = 'Flutter Developer & Spreadsheet Expert';
  String heroBioText =
      'This is a customizable hero section. You can change the title and subtitle from the admin panel.';

  @override
  void initState() {
    super.initState();
    _loadHeroSettings();
  }

  Future<void> _loadHeroSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      heroTitle = prefs.getString('hero_title') ?? 'Hi, I am Rahul Raj';
      heroSubtitle =
          prefs.getString('hero_subtitle') ??
          'Flutter Developer & Spreadsheet Expert';
      heroBioText = prefs.getString('hero_bio') ?? 'This is a customizable hero section. You can change the title and subtitle from the admin panel.';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen ki width check karenge ki mobile hai ya desktop
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Expanded(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 80,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        color: AppThemeColors
            .background, // Background color from theme_colors.dart
        child: SingleChildScrollView(
          // Scrollable banaya hai taaki mobile par overflow na ho
          child: isDesktop
              ? Row(
                  // Laptop/Desktop View: Aamne-samne (Side-by-Side)
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "HELLO, I'M",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppThemeColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 0),

                          RichText(
                            text: TextSpan(
                              text: heroTitle,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemeColors.primaryAccent, // Text primary color from theme_colors.dart
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          RichText(
                            text: TextSpan(
                              text: heroSubtitle,
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppThemeColors.textPrimary, // Text secondary color from theme_colors.dart
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          SizedBox(
                            width: 500,
                            child: RichText(
                              text: TextSpan(
                                text: heroBioText,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppThemeColors.textSecondary, // Text secondary color from theme_colors.dart
                                    letterSpacing: 1,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemeColors.primaryAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View My Work',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.whiteText,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: AppThemeColors.whiteText,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemeColors.textPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Download CV',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColors.whiteText,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.download_outlined,
                                      size: 16,
                                      color: AppThemeColors.whiteText,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 400,
                              height: 500,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppThemeColors.primaryAccent,
                                    AppThemeColors.primaryAccent.withValues(
                                      alpha: 0.9,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/hero3.png',
                              width: 500,
                              height: 610,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  // Mobile View: Upar-Neeche (Stacked)
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 500,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppThemeColors.primaryAccent,
                                  AppThemeColors.primaryAccent.withValues(
                                    alpha: 0.9,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/hero3.png',
                            width: 500,
                            height: 410,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: heroTitle,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.primaryAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: heroSubtitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      heroBioText,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.textSecondary,
                        letterSpacing: 1,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColors.primaryAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View My Work',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemeColors.whiteText,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: AppThemeColors.whiteText,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Download CV',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemeColors.whiteText,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.download_outlined,
                                size: 16,
                                color: AppThemeColors.whiteText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
