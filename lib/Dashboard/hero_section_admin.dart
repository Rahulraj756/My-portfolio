import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeroAdminScreen extends StatefulWidget {
  const HeroAdminScreen({super.key});

  @override
  State<HeroAdminScreen> createState() => _HeroAdminScreenState();
}

class _HeroAdminScreenState extends State<HeroAdminScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _biotextController = TextEditingController();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadHeroData();
  }

  Future<void> _loadHeroData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titleController.text =
          prefs.getString('hero_title') ?? 'Hi, I am Rahul Raj';
      _subtitleController.text =
          prefs.getString('hero_subtitle') ??
          'Flutter Developer & Spreadsheet Expert';
      _biotextController.text = prefs.getString('hero_bio') ?? 'I am a passionate Flutter developer with a knack for creating beautiful and functional mobile applications. I specialize in building responsive UIs and integrating complex functionalities seamlessly. My expertise extends to working with APIs';
    });
  }

  Future<void> _saveHeroData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hero_title', _titleController.text.trim());
    await prefs.setString('hero_subtitle', _subtitleController.text.trim());
    await prefs.setString('hero_bio', _biotextController.text.trim());

    setState(() {
      _isSaved = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSaved = false);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _biotextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Hero Section'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              'Customize Hero Section',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Hero Title',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: 'Hero Subtitle',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _biotextController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Hero Bio Text',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSaved ? null : _saveHeroData,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSaved ? Colors.green : Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isSaved ? 'Saved Successfully! ✓' : 'Save Changes',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
