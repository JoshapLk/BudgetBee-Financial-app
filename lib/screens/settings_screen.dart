import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 24),

            // General Settings
            _buildSection(
              title: 'General',
              children: [
                _buildSettingTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: _showLanguageDialog,
                ),
                _buildSettingTile(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  subtitle: _selectedCurrency,
                  onTap: _showCurrencyDialog,
                ),
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Security Settings
            _buildSection(
              title: 'Security',
              children: [
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face ID',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                ),
                _buildSettingTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {
                    _showComingSoonDialog('Change Password');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.security,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security',
                  onTap: () {
                    _showComingSoonDialog('Two-Factor Authentication');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notification Settings
            _buildSection(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildSettingTile(
                  icon: Icons.schedule,
                  title: 'Budget Reminders',
                  subtitle: 'Get notified about budget limits',
                  onTap: () {
                    _showComingSoonDialog('Budget Reminders');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.receipt,
                  title: 'Transaction Alerts',
                  subtitle: 'Get notified for large transactions',
                  onTap: () {
                    _showComingSoonDialog('Transaction Alerts');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Data & Privacy
            _buildSection(
              title: 'Data & Privacy',
              children: [
                _buildSettingTile(
                  icon: Icons.download,
                  title: 'Export Data',
                  subtitle: 'Download your transaction data',
                  onTap: () {
                    _showComingSoonDialog('Export Data');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.backup,
                  title: 'Backup & Sync',
                  subtitle: 'Sync data across devices',
                  onTap: () {
                    _showComingSoonDialog('Backup & Sync');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    _showComingSoonDialog('Privacy Policy');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Support & About
            _buildSection(
              title: 'Support & About',
              children: [
                _buildSettingTile(
                  icon: Icons.help,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    _showComingSoonDialog('Help Center');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts with us',
                  onTap: () {
                    _showComingSoonDialog('Send Feedback');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.star,
                  title: 'Rate App',
                  subtitle: 'Rate us on the app store',
                  onTap: () {
                    _showComingSoonDialog('Rate App');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Danger Zone
            _buildSection(
              title: 'Danger Zone',
              children: [
                _buildSettingTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  textColor: Colors.orange,
                  onTap: () {
                    _showSignOutDialog();
                  },
                ),
                _buildSettingTile(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  textColor: Colors.red,
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFE55C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black.withOpacity(0.2),
            child: const Text(
              'SC',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sophia Carter',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'sophia.carter@email.com',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _showComingSoonDialog('Edit Profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? Colors.white).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? const Color(0xFFFFD700),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.settings, color: Color(0xFFFFD700), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFD700),
        activeTrackColor: const Color(0xFFFFD700).withOpacity(0.3),
        inactiveThumbColor: Colors.white54,
        inactiveTrackColor: Colors.white24,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Select Language',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['English', 'Spanish', 'French', 'German'].map((language) {
                    return ListTile(
                      title: Text(
                        language,
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: Radio<String>(
                        value: language,
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                          Navigator.pop(context);
                        },
                        activeColor: const Color(0xFFFFD700),
                      ),
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Select Currency',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['USD', 'EUR', 'GBP', 'JPY', 'CAD'].map((currency) {
                    return ListTile(
                      title: Text(
                        currency,
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: Radio<String>(
                        value: currency,
                        groupValue: _selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value!;
                          });
                          Navigator.pop(context);
                        },
                        activeColor: const Color(0xFFFFD700),
                      ),
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Coming Soon',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '$feature feature is coming soon!',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'BudgetBee',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('🐝', style: TextStyle(fontSize: 30))),
      ),
      children: const [
        Text('BudgetBee - Your Personal Finance Companion'),
        SizedBox(height: 16),
        Text(
          'Track your spending, manage budgets, and achieve your financial goals with ease.',
        ),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to sign out?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement sign out
                  _showComingSoonDialog('Sign Out');
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showComingSoonDialog('Delete Account');
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
