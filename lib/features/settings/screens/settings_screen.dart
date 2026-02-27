import 'package:flutter/material.dart';
import 'package:supa_app/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _faceIdEnabled = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Settings', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),
            _buildSectionHeader('SECURITY'),
            const SizedBox(height: 12),
            _buildSwitchTile(
              label: 'FaceID / Fingerprint Lock',
              icon: Icons.face_rounded,
              value: _faceIdEnabled,
              onChanged: (val) => setState(() => _faceIdEnabled = val),
            ),
            _buildSwitchTile(
              label: 'Push Notifications',
              icon: Icons.notifications_active_rounded,
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('ACCOUNT'),
            const SizedBox(height: 12),
            _buildSettingsTile(
              label: 'Management API Token',
              icon: Icons.key_rounded,
              onTap: () {},
            ),
            _buildSettingsTile(
              label: 'Personal Access Tokens',
              icon: Icons.token_rounded,
              onTap: () {},
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Sign Out', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.accent, Colors.blueAccent]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('ZH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ZeeshanHQ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                Text('Developer Tier', style: TextStyle(color: AppTheme.accent, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.white24, size: 20)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.secondary.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      ),
    );
  }
}
