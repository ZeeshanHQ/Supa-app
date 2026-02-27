import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/glass_card.dart';
import 'package:supa_app/core/widgets/skeleton_loader.dart';
import 'package:supa_app/features/project/screens/project_detail_screen.dart';
import 'package:supa_app/features/settings/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 40),
            color: AppTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.business_rounded, color: AppTheme.accent, size: 20),
            ),
            onSelected: (value) {
              HapticFeedback.mediumImpact();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'org1',
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch_rounded, size: 18, color: AppTheme.accent),
                    SizedBox(width: 12),
                    Text('Antigravity HQ', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'org2',
                child: Row(
                  children: [
                    Icon(Icons.layers_rounded, size: 18, color: AppTheme.secondary),
                    SizedBox(width: 12),
                    Text('Personal Stack', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, size: 18, color: Colors.white54),
                    SizedBox(width: 12),
                    Text('Add Organization', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        title: Text(
          'Infrastructure',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                SkeletonBentoCard(isLarge: true),
                SkeletonBentoCard(),
                SkeletonBentoCard(),
                SkeletonBentoCard(),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildListDelegate([
                      // Large Card: CPU Usage (Primary Focus)
                      _buildBentoCard(
                        context,
                        title: 'CPU USAGE',
                        value: '15.4%',
                        subtitle: 'Production DB',
                        icon: Icons.speed_rounded,
                        isLarge: true,
                        color: AppTheme.accent,
                      ),
                      // Medium Card: RAM
                      _buildBentoCard(
                        context,
                        title: 'MEMORY',
                        value: '1.2GB',
                        subtitle: 'Healthy',
                        icon: Icons.memory_rounded,
                        isLarge: false,
                      ),
                      // Medium Card: Nodes
                      _buildBentoCard(
                        context,
                        title: 'NODES',
                        value: '3 Items',
                        subtitle: 'Active',
                        icon: Icons.hub_rounded,
                        isLarge: false,
                      ),
                    ]),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildListDelegate([
                      // Small Cards: Regions/Status
                      _buildSmallBentoCard(context, 'REGION', 'Singapore', Icons.public_rounded),
                      _buildSmallBentoCard(context, 'STATUS', 'Running', Icons.check_circle_rounded, color: AppTheme.accent),
                      _buildSmallBentoCard(context, 'UPTIME', '12d 4h', Icons.timer_rounded),
                    ]),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  const SliverToBoxAdapter(
                    child: Text(
                      'ACTIVE PROJECTS',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildProjectCard(
                        context,
                        name: 'Staging Environment',
                        status: 'Taking a nap 😴',
                        cpu: '0.0%',
                        ram: '0.0GB',
                        nodeCount: 1,
                        isPaused: true,
                      ),
                      _buildProjectCard(
                        context,
                        name: 'Analytics API',
                        status: 'Breaking a sweat 🥵',
                        cpu: '91.2%',
                        ram: '7.8GB',
                        nodeCount: 5,
                        isPaused: false,
                        hasAlert: true,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.accent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add_rounded, color: AppTheme.background),
      ),
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    bool isLarge = false,
    Color? color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color ?? AppTheme.secondary.withOpacity(0.5), size: 20),
              if (isLarge)
                const Icon(Icons.show_chart_rounded, color: AppTheme.accent, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.secondary.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: isLarge ? 28 : 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.secondary.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildSmallBentoCard(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return GlassCard(
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color ?? AppTheme.secondary.withOpacity(0.5), size: 14),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 8, color: AppTheme.secondary.withOpacity(0.6), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String name,
    required String status,
    required String cpu,
    required String ram,
    required int nodeCount,
    required bool isPaused,
    bool hasAlert = false,
  }) {
    final statusColor = hasAlert
        ? AppTheme.error
        : isPaused
            ? AppTheme.secondary
            : AppTheme.accent;

    return Hero(
      tag: 'project_$name',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Dismissible(
          key: Key('project_dismissible_$name'),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            // Placeholder for action
          },
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_outlined, color: AppTheme.accent),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
          ),
          child: GlassCard(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.heavyImpact();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppTheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.refresh_rounded, color: Colors.orangeAccent),
                          title: const Text('Quick Restart', style: TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.copy_rounded, color: AppTheme.secondary),
                          title: const Text('Copy API URL', style: TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.share_rounded, color: AppTheme.accent),
                          title: const Text('Share Access', style: TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(projectName: name),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (!isPaused)
                                  BoxShadow(
                                    color: statusColor.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                          ).animate(onPlay: (controller) => controller.repeat()).scale(
                                duration: 1.5.seconds,
                                begin: const Offset(1, 1),
                                end: const Offset(1.3, 1.3),
                                curve: Curves.easeInOut,
                              ).then().scale(
                                duration: 1.5.seconds,
                                begin: const Offset(1.3, 1.3),
                                end: const Offset(1, 1),
                                curve: Curves.easeInOut,
                              ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$nodeCount Nodes',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTechnicalMetric('CPU', cpu, hasAlert),
                          _buildTechnicalMetric('RAM', ram, false),
                          _buildTechnicalMetric('STATUS', status.toUpperCase(), hasAlert, isStatus: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildTechnicalMetric(String label, String value, bool isCritical, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.secondary.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isCritical ? AppTheme.error : (isStatus ? AppTheme.accent : Colors.white),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
