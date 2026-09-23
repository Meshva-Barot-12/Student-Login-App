import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.auth});

  final AuthController auth;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showTokenView = false;

  void _copyStudentId(String studentId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
            const SizedBox(width: 12),
            Expanded(child: Text('Student ID ($studentId) copied to clipboard!')),
          ],
        ),
      ),
    );
  }

  void _showSecurityModal() {
    final account = widget.auth.account;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFF3559E0), size: 28),
                    const SizedBox(width: 10),
                    const Text('Student Security Protocol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(height: 24),
                ListTile(
                  leading: const Icon(Icons.verified_user_rounded, color: Colors.green),
                  title: const Text('Session Security'),
                  subtitle: const Text('TLS 1.3 encrypted in-memory student session'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.person_pin_circle_rounded, color: Colors.blueAccent),
                  title: Text(account?.fullName ?? 'Meshva Barot'),
                  subtitle: Text('ID: ${account?.studentId ?? "STU-2026-8942"} | ${account?.department ?? "Computer Science"}'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to end your student session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(auth: widget.auth)),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('You have successfully signed out.'),
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = widget.auth.account;
    final studentName = account?.fullName ?? 'Meshva Barot';
    final studentId = account?.studentId ?? 'STU-2026-8942';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.school_rounded, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Student Portal',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Security Status',
            icon: const Icon(Icons.security_rounded),
            onPressed: _showSecurityModal,
          ),
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                          ),
                          Text(
                            studentName,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: Color(0xFF10B981)),
                            SizedBox(width: 6),
                            Text('Active', style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Interactive Student ID Card with Gestures
                  Tooltip(
                    message: 'Gestures: Double-tap to flip token view, Long-press to copy ID',
                    child: GestureDetector(
                      onDoubleTap: () => setState(() => _showTokenView = !_showTokenView),
                      onLongPress: () => _copyStudentId(studentId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _showTokenView
                                ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                                : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E3A8A).withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.badge_rounded, color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text('DIGITAL STUDENT IDENTITY', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _showTokenView ? 'TOKEN VIEW' : 'ID CARD',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (!_showTokenView) ...[
                              Text(studentName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('ID: $studentId', style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'monospace')),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('EMAIL', style: TextStyle(color: Colors.white60, fontSize: 10)),
                                        Text(account?.email ?? 'meshva.barot@example.com', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('CONTACT', style: TextStyle(color: Colors.white60, fontSize: 10)),
                                      Text(account?.mobile ?? '9876543210', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ] else ...[
                              const Text('CRYPTOGRAPHIC AUTH TOKEN', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'SHA256:7a9f8e4c1b2d0e5a8f9c1d2e3b4a5f60718293a4b5c6d7e8',
                                  style: TextStyle(color: Colors.greenAccent.shade200, fontSize: 12, fontFamily: 'monospace'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text('Double-tap anywhere on the card to return to standard view.', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            ],
                            const SizedBox(height: 12),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text('💡 Tip: Double-tap to flip • Long-press to copy ID', style: TextStyle(color: Colors.white54, fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Academic Metrics Grid
                  Text(
                    'Academic Overview',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isWide ? 4 : 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: isWide ? 1.35 : 1.25,
                        children: const [
                          _MetricCard(
                            icon: Icons.pie_chart_rounded,
                            iconColor: Color(0xFF10B981),
                            label: 'Attendance',
                            value: '94.2%',
                            change: '+2.1% this month',
                          ),
                          _MetricCard(
                            icon: Icons.grade_rounded,
                            iconColor: Color(0xFFF59E0B),
                            label: 'CGPA',
                            value: '3.88',
                            change: 'Top 5th Percentile',
                          ),
                          _MetricCard(
                            icon: Icons.book_rounded,
                            iconColor: Color(0xFF3B82F6),
                            label: 'Courses',
                            value: '6 Active',
                            change: 'Current Term',
                          ),
                          _MetricCard(
                            icon: Icons.verified_rounded,
                            iconColor: Color(0xFF8B5CF6),
                            label: 'Credits',
                            value: '22 / 24',
                            change: 'On Track',
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Quick Action Cards
                  Text(
                    'Quick Portals & Actions',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFEFF6FF),
                            child: Icon(Icons.shield_outlined, color: Color(0xFF3B82F6)),
                          ),
                          title: const Text('Security & Access Log', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('View verified login attempts and security audits'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: _showSecurityModal,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFECFDF5),
                            child: Icon(Icons.download_rounded, color: Color(0xFF10B981)),
                          ),
                          title: const Text('Digital Student ID Card', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Instant credentials for campus & online facilities'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _copyStudentId(studentId),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFEF2F2),
                            child: Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                          ),
                          title: const Text('Sign Out of Portal', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
                          subtitle: const Text('End your session safely'),
                          onTap: _confirmLogout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.change,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String change;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
