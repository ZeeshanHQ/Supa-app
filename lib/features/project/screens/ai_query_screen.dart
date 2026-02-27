import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/supa_button.dart';
import 'package:supa_app/core/widgets/skeleton_loader.dart';

class AIQueryScreen extends StatefulWidget {
  const AIQueryScreen({super.key});

  @override
  State<AIQueryScreen> createState() => _AIQueryScreenState();
}

class _AIQueryScreenState extends State<AIQueryScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnalyzing = false;
  String? _result;

  void _runAIQuery() async {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    // Simulate AI analysis and SQL generation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _result = '-- Generated SQL Recommendation\n'
            '-- Based on: "${_controller.text}"\n\n'
            'SELECT *\n'
            'FROM auth.users\n'
            'WHERE last_sign_in_at < NOW() - INTERVAL \'30 days\'\n'
            'ORDER BY created_at DESC;';
      });
    }
  }

  final List<Map<String, String>> _savedSnippets = [
    {
      'title': 'Recent Signups',
      'query': 'SELECT * FROM auth.users ORDER BY created_at DESC LIMIT 10;'
    },
    {
      'title': 'Active Sessions',
      'query': 'SELECT count(*) FROM auth.sessions WHERE last_sign_in_at > NOW() - INTERVAL \'24 hours\';'
    },
    {
      'title': 'Storage Cleanup',
      'query': 'DELETE FROM storage.objects WHERE created_at < NOW() - INTERVAL \'30 days\';'
    },
  ];

  void _loadSnippet(String query) {
    HapticFeedback.lightImpact();
    setState(() {
      _controller.text = query;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('AI Assistant', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionLabel(label: 'SAVED SNIPPETS LIBRARY'),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _savedSnippets.length + 1,
                itemBuilder: (context, index) {
                  if (index == _savedSnippets.length) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: const Icon(Icons.add_rounded, color: AppTheme.secondary),
                    );
                  }

                  final snippet = _savedSnippets[index];
                  return GestureDetector(
                    onTap: () => _loadSnippet(snippet['query']!),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.terminal_rounded, size: 16, color: AppTheme.accent.withOpacity(0.7)),
                          const Spacer(),
                          Text(
                            snippet['title']!,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            snippet['query']!,
                            style: TextStyle(color: AppTheme.secondary.withOpacity(0.5), fontSize: 10, fontFamily: 'monospace'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const _SectionLabel(label: 'INTENT DESCRIPTION OR SQL'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                hintText: 'Describe the data you want to retrieve or manipulate...',
                hintStyle: TextStyle(color: AppTheme.secondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SupaButton(
              isLoading: _isAnalyzing, 
              onPressed: _runAIQuery,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 18),
                  SizedBox(width: 12),
                  Text('Generate SQL Command'),
                ],
              ),
            ),
            if (_isAnalyzing) ...[
              const SizedBox(height: 40),
              const _SectionLabel(label: 'ANALYZING INTENT...'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonLoader(width: 200, height: 14),
                    SizedBox(height: 12),
                    SkeletonLoader(width: double.infinity, height: 14),
                    SizedBox(height: 8),
                    SkeletonLoader(width: 250, height: 14),
                    SizedBox(height: 8),
                    SkeletonLoader(width: 180, height: 14),
                  ],
                ),
              ).animate().fadeIn(),
            ],
            if (_result != null) ...[
              const SizedBox(height: 40),
              const _SectionLabel(label: 'GENERATED OUTPUT'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D0D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    _result!,
                    style: const TextStyle(
                      fontFamily: 'monospace', 
                      color: AppTheme.accent,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withOpacity(0.05)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy SQL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SupaButton(
                      onPressed: () {},
                      isFullWidth: false,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Execute'),
                        ],
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppTheme.secondary.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}
