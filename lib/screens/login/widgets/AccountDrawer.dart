import 'package:flutter/material.dart';
import 'package:painal/screens/reports/ReportsScreen.dart';

class AccountDrawer extends StatelessWidget {
  final String email;
  final VoidCallback onLogout;

  const AccountDrawer({super.key, required this.email, required this.onLogout});

  void _openReports(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ReportsScreen()));
  }

  void _openRequests(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Requests'),
            content: const Text('Requests page coming soon.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: viewInsets.bottom > 0 ? viewInsets.bottom : 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 12,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 38,
                                backgroundColor: Colors.green[100],
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.green,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.18),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'Admin',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Admin User',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  icon: const Icon(Icons.list_alt, size: 20),
                                  label: const Text('View Requests'),
                                  onPressed: () => _openRequests(context),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  icon: const Icon(Icons.report, size: 20),
                                  label: const Text('View Reports'),
                                  onPressed: () => _openReports(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red[700],
                                side: BorderSide(color: Colors.red[200]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(Icons.logout, size: 20),
                              label: const Text('Logout'),
                              onPressed: onLogout,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('Close'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
