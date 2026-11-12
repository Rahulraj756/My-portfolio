import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavbarAdminScreen extends StatefulWidget {
  const NavbarAdminScreen({super.key});

  @override
  State<NavbarAdminScreen> createState() => _NavbarAdminScreenState();
}

class _NavbarAdminScreenState extends State<NavbarAdminScreen> {
  final TextEditingController _titleController = TextEditingController();
  double _currentFontSize = 20.0;
  Color _selectedColor = Colors.white;

  // Button ka visual state track karne ke liye variable
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titleController.text = prefs.getString('nav_title') ?? 'PORTFOLIO';
      _currentFontSize = prefs.getDouble('nav_fontsize') ?? 20.0;
      int colorVal = prefs.getInt('nav_color') ?? Colors.white.toARGB32();
      _selectedColor = Color(colorVal);
    });
  }

  Future<void> _saveNavbarSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nav_title', _titleController.text.trim());
    await prefs.setDouble('nav_fontsize', _currentFontSize);
    await prefs.setInt('nav_color', _selectedColor.toARGB32());

    // Save hote hi button ka state change karenge
    setState(() {
      _isSaved = true;
    });

    // 2 seconds baad button ko wapas normal state mein le aayenge
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSaved = false;
        });
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved permanently!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Navbar Section'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              'Customize Navbar Section',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Portfolio Brand Name',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Font Size: ${_currentFontSize.toStringAsFixed(0)}px',
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: _currentFontSize,
              min: 14.0,
              max: 32.0,
              divisions: 9,
              label: _currentFontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _currentFontSize = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text('Select Text Color:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.amber),
                _colorButton(Colors.cyan),
                _colorButton(Colors.greenAccent),
                _colorButton(Color(0xffe11d48)),
              ],
            ),
            const SizedBox(height: 40),

            // Dynamic Save Button with Instant Color & Text Feedback
            ElevatedButton(
              onPressed: _isSaved ? null : _saveNavbarSettings, // Save hote waqt thodi der ke liye disable ho jayega
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSaved ? Colors.green : Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSaved ? Icons.check_circle : Icons.save,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isSaved ? 'Saved Successfully! ✓' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
