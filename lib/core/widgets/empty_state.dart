import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/supa_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.title = 'No Data Found',
    this.description = 'Try adjusting your filters or adding new records.',
    this.icon = Icons.search_off_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accent.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppTheme.accent.withOpacity(0.5),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .moveY(begin: -10, end: 10, duration: 3.seconds, curve: Curves.easeInOut)
             .shimmer(delay: 1.seconds, duration: 2.seconds, color: AppTheme.accent.withOpacity(0.2)),
            const SizedBox(height: 32),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.secondary.withOpacity(0.8),
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 40),
              SupaButton(
                onPressed: onAction!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
