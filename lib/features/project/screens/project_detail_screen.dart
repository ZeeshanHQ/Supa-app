import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/supa_button.dart';
import 'package:supa_app/core/widgets/success_check.dart';
import 'package:supa_app/features/project/screens/logs_screen.dart';
import 'package:supa_app/features/project/screens/ai_query_screen.dart';
import 'package:supa_app/features/database/screens/table_browser_screen.dart';
import 'package:supa_app/core/services/auth_service.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectName;
  const ProjectDetailScreen({super.key, required this.projectName});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _isPausing = false;
  bool _isRestarting = false;
  final AuthService _authService = AuthService();

  Future<void> _showConfirmationBottomSheet({
    required String title,
    required String description,
    required String actionLabel,
    required Color actionColor,
    required Future<void> Function() onConfirm,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: AppTheme.secondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SupaButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                child: Text(actionLabel),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: AppTheme.secondary)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSecureAction(String actionName, Future<void> Function() action) async {
    final authenticated = await _authService.authenticateBiometrically();
    
    if (authenticated) {
      await action();
      if (mounted) {
        _showNotification('$actionName successful', isError: false);
      }
    } else {
      if (mounted) {
        _showNotification('Authentication failed', isError: true);
      }
    }
  }

  void _showNotification(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        backgroundColor: isError ? AppTheme.error : AppTheme.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.projectName, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
          ),
        ],
      ),
      body: Hero(
        tag: 'project_${widget.projectName}',
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('METRICS & HEALTH'),
              const SizedBox(height: 12),
              _buildChartSection(),
              const SizedBox(height: 32),
              _buildSectionHeader('INFRASTRUCTURE CONTROL'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Restart DB',
                      icon: Icons.refresh_rounded,
                      color: Colors.orangeAccent,
                      isLoading: _isRestarting,
                      onPressed: () => _showConfirmationBottomSheet(
                        title: 'Critical: Restart Database',
                        description: 'Are you sure you want to restart the database? This will disconnect all active sessions.',
                        actionLabel: 'Confirm Restart',
                        actionColor: Colors.orangeAccent,
                        onConfirm: () => _handleSecureAction('Restart', () async {
                          setState(() => _isRestarting = true);
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() => _isRestarting = false);
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Increased spacing for "Fat Finger" safety
                  Expanded(
                    child: _buildActionButton(
                      label: 'Pause Project',
                      icon: Icons.pause_rounded,
                      color: AppTheme.error,
                      isLoading: _isPausing,
                      onPressed: () => _showConfirmationBottomSheet(
                        title: 'Pause Infrastructure',
                        description: 'Pausing the project will stop all compute services. You can resume at any time.',
                        actionLabel: 'Pause Now',
                        actionColor: AppTheme.error,
                        onConfirm: () => _handleSecureAction('Pause', () async {
                          setState(() => _isPausing = true);
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() => _isPausing = false);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('DATABASE TOOLS'),
              const SizedBox(height: 12),
              _buildQuickAccessTile(
                label: 'Table Browser',
                subtitle: 'Browse and manage database tables',
                icon: Icons.table_chart_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TableBrowserScreen()),
                  );
                },
              ),
              _buildQuickAccessTile(
                label: 'SQL Editor',
                subtitle: 'AI-assisted query engine',
                icon: Icons.terminal_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AIQueryScreen()),
                  );
                },
              ),
              _buildQuickAccessTile(
                label: 'User Management',
                subtitle: 'Auth policies and user list',
                icon: Icons.people_alt_rounded,
                onTap: () {},
              ),
              _buildQuickAccessTile(
                label: 'Edge Functions Logs',
                subtitle: 'Real-time debugging & errors',
                icon: Icons.assignment_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LogsScreen(projectName: widget.projectName)),
                  );
                },
              ),
              _buildQuickAccessTile(
                label: 'API Settings',
                subtitle: 'Project URL and Keys',
                icon: Icons.api_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.secondary.withOpacity(0.5),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      children: [
        _buildMetricChart('CPU Usage', '15.4%', [0.1, 0.2, 0.15, 0.3, 0.25, 0.15, 0.18], AppTheme.accent),
        const SizedBox(height: 12),
        _buildMetricChart('Memory Usage', '1.2GB', [0.4, 0.45, 0.42, 0.48, 0.46, 0.5, 0.47], Colors.blueAccent),
        const SizedBox(height: 12),
        _buildMetricChart('Database I/O', '8.2 ops/s', [0.2, 0.1, 0.6, 0.3, 0.2, 0.8, 0.4], Colors.orangeAccent),
      ],
    );
  }

  Widget _buildMetricChart(String label, String value, List<double> points, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomPaint(
              painter: SparklinePainter(points, color),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SupaButton(
      isLoading: isLoading,
      onPressed: onPressed,
      backgroundColor: color.withOpacity(0.05),
      foregroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        tileColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Icon(icon, color: AppTheme.accent, size: 20),
        ),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.2)),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  
  Color get sparklineColor => color;

  SparklinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (data.length - 1);

    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
    );

    canvas.drawPath(fillPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
