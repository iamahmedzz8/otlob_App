import 'package:flutter/material.dart';
const Color profileOrange = Color(0xFFFF654F);
const Color profileBackground = Color(0xFFF8F9FB);
const Color profileText = Color(0xFF202735);

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onOrders;
  final VoidCallback? onAddress;
  final VoidCallback? onSettings;
  final VoidCallback? onSupport;
  final VoidCallback? onEditProfile;

  const ProfileScreen({
    super.key,
    this.onOrders,
    this.onAddress,
    this.onSettings,
    this.onSupport,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: profileBackground,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: profileText,
                ),
              ),
              const SizedBox(height: 16),

              // Profile information card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF735F),
                      Color(0xFFFF503E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(27),
                  boxShadow: [
                    BoxShadow(
                      color: profileOrange.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '7AMO',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '7amo@gmail.app',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFE4E0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onEditProfile ??
                              () => _showMessage(
                            context,
                            'Edit profile',
                          ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                        Colors.white.withValues(alpha: 0.18),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              _ProfileMenuItem(
                title: 'My Orders',
                subtitle: 'View your order history',
                icon: Icons.receipt_long_rounded,
                iconColor: const Color(0xFF3185E8),
                iconBackground: const Color(0xFFEDF5FF),
                onTap: onOrders ??
                        () => _showMessage(context, 'My Orders'),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                title: 'My Address',
                subtitle: 'Manage saved addresses',
                icon: Icons.location_on_rounded,
                iconColor: const Color(0xFFE84D96),
                iconBackground: const Color(0xFFFFEEF6),
                onTap: onAddress ??
                        () => _showMessage(context, 'My Address'),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                title: 'Settings',
                subtitle: 'App preferences',
                icon: Icons.settings_rounded,
                iconColor: const Color(0xFFA451E8),
                iconBackground: const Color(0xFFF7EEFF),
                onTap: onSettings ??
                        () => _showMessage(context, 'Settings'),
              ),

              const SizedBox(height: 12),

              _ProfileMenuItem(
                title: 'Help & Support',
                subtitle: 'Get help or contact us',
                icon: Icons.help_rounded,
                iconColor: const Color(0xFFEF4F57),
                iconBackground: const Color(0xFFFFEEEE),
                onTap: onSupport ??
                        () => _showMessage(context, 'Help & Support'),
              ),

              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFFEEEE),
                    foregroundColor: profileOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title screen is not connected yet'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text(
          'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Log out',
              style: TextStyle(color: profileOrange),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Connect logout to your authentication system.',
          ),
        ),
      );
    }
  }
}

class ProfileSubScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const ProfileSubScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackground,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: profileBackground,
        foregroundColor: profileText,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: profileOrange,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: profileText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This page is ready for its functionality.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 81),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: profileText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF858B95),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFD0D4DA),
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}