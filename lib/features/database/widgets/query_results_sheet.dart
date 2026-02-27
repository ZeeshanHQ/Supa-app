import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/json_tree_viewer.dart';
import 'package:supa_app/core/widgets/skeleton_loader.dart';
import 'package:supa_app/features/database/providers/sql_snippets_provider.dart';

class QueryResultsSheet extends ConsumerWidget {
  final String query;
  final String title;

  const QueryResultsSheet({
    super.key,
    required this.query,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final executionState = ref.watch(queryExecutionProvider(query));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle for swiping
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'QUERY RESULTS',
                          style: TextStyle(
                            color: AppTheme.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: executionState.when(
                data: (results) => _buildResults(results, scrollController),
                loading: () => _buildLoading(),
                error: (err, stack) => _buildError(err.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(List<Map<String, dynamic>> results, ScrollController scrollController) {
    if (results.isEmpty) {
      return const Center(child: Text('No results returned', style: TextStyle(color: AppTheme.secondary)));
    }

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: JsonTreeView(
              data: results.length == 1 ? results.first : results,
              initialExpanded: true,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          SkeletonLoader(width: double.infinity, height: 40),
          SizedBox(height: 12),
          SkeletonLoader(width: double.infinity, height: 40),
          SizedBox(height: 12),
          SkeletonLoader(width: double.infinity, height: 40),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Query Error',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.secondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
