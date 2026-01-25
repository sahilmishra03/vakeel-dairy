import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State Variables
  bool _isDarkMode = false;
  String _selectedLanguage = 'en'; // Default: English

  // Theme Constants
  final Color primaryBlack = const Color(0xFF111111);
  final Color secondaryGrey = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: primaryBlack,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: EXPORT DATA ---
            _buildSectionHeader('Reports & Data'),
            const SizedBox(height: 15),

            // Export Today's Cases
            _buildActionTile(
              icon: Icons.today,
              title: 'Export Today\'s Cases',
              subtitle: 'Generate PDF of today\'s hearings',
              onTap: () => _showComingSoon(),
            ),
            const SizedBox(height: 12),

            // Export All Cases
            _buildActionTile(
              icon: Icons.folder_special,
              title: 'Export All Cases',
              subtitle: 'Generate complete case database PDF',
              onTap: () => _showComingSoon(),
            ),

            const SizedBox(height: 30),
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 30),

            // --- SECTION 2: PREFERENCES ---
            _buildSectionHeader('App Preferences'),
            const SizedBox(height: 15),

            // 1. Dark Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: secondaryGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                activeThumbColor: primaryBlack,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                secondary: Icon(Icons.dark_mode, color: primaryBlack),
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 15),

            // 2. Language Switcher (Segmented Control Style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: primaryBlack),
                      const SizedBox(width: 15),
                      const Text(
                        "Language / भाषा",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // The Toggle Buttons
                  Container(
                    height: 45,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildLanguageOption("English", "en"),
                        _buildLanguageOption("हिंदी (Hindi)", "hi"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            const SizedBox(height: 50),
            Center(
              child: Text(
                "Vakeel Diary v1.0.0",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Section Header ---
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.grey[600],
      ),
    );
  }

  // --- Widget: Language Toggle Button ---
  Widget _buildLanguageOption(String label, String code) {
    bool isSelected = _selectedLanguage == code;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
          // TODO: Add actual localization logic here
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isSelected ? primaryBlack : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget: Action Tile ---
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.picture_as_pdf, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // --- Show Coming Soon Dialog ---
  void _showComingSoon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'PDF export functionality will be available in a future update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
