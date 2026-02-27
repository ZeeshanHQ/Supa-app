import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';

class LogsScreen extends StatefulWidget {
  final String projectName;
  const LogsScreen({super.key, required this.projectName});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final List<Map<String, dynamic>> _logs = [
    {
      'timestamp': '2024-02-22 19:51:02.451',
      'level': 'INFO',
      'message': 'Edge Function "payment-hook" invoked successfully.',
      'detail': 'Duration: 142ms, Memory: 42MB'
    },
    {
      'timestamp': '2024-02-22 19:50:45.120',
      'level': 'ERROR',
      'message': 'Failed to fetch customer data from Stripe API.',
      'detail': 'StatusCode: 401, Reason: Invalid API Key'
    },
    {
      'timestamp': '2024-02-22 19:50:12.883',
      'level': 'WARNING',
      'message': 'Database connection pool reaching limit (85%).',
      'detail': 'Active sessions: 42/50'
    },
    {
      'timestamp': '2024-02-22 19:49:55.221',
      'level': 'INFO',
      'message': 'Cron job "daily-cleanup" started.',
      'detail': 'Target: auth.sessions, Criteria: deleted_at < NOW()'
    },
    {
      'timestamp': '2024-02-22 19:48:30.005',
      'level': 'ERROR',
      'message': 'Unhandled exception in "auth-proxy".',
      'detail': 'TypeError: Cannot read property \'id\' of undefined'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Function Logs', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 18)),
            Text(widget.projectName, style: TextStyle(color: AppTheme.secondary.withOpacity(0.5), fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: AppTheme.error),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          final bool isError = log['level'] == 'ERROR';
          final bool isWarning = log['level'] == 'WARNING';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isError 
                  ? AppTheme.error.withOpacity(0.05) 
                  : (isWarning ? Colors.orangeAccent.withOpacity(0.05) : Colors.transparent),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.03)),
                left: BorderSide(
                  color: isError 
                      ? AppTheme.error 
                      : (isWarning ? Colors.orangeAccent : Colors.transparent),
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isError 
                            ? AppTheme.error.withOpacity(0.2) 
                            : (isWarning ? Colors.orangeAccent.withOpacity(0.2) : Colors.white10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        log['level'],
                        style: TextStyle(
                          color: isError 
                              ? AppTheme.error 
                              : (isWarning ? Colors.orangeAccent : AppTheme.secondary),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    Text(
                      log['timestamp'],
                      style: TextStyle(color: AppTheme.secondary.withOpacity(0.4), fontSize: 10, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  log['message'],
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  log['detail'],
                  style: TextStyle(color: AppTheme.secondary.withOpacity(0.7), fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05, end: 0);
        },
      ),
    );
  }
}
