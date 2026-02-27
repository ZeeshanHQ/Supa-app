import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/empty_state.dart';
import 'package:supa_app/core/widgets/json_tree_viewer.dart';
import 'package:supa_app/core/widgets/supa_button.dart';

class DataViewScreen extends StatefulWidget {
  final String tableName;
  const DataViewScreen({super.key, required this.tableName});

  @override
  State<DataViewScreen> createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<int> _mockData = List.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    // Filter logic for mock data
    final filteredData = _mockData.where((index) {
      final username = 'user_dev_${index + 1}';
      final email = 'dev${index + 1}@example.supabase.com';
      return username.contains(_searchQuery.toLowerCase()) || 
             email.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.tableName, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search records...',
                hintStyle: TextStyle(color: AppTheme.secondary.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.secondary, size: 20),
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
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
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
            }, 
            icon: const Icon(Icons.tune_rounded, size: 20),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
            }, 
            icon: const Icon(Icons.add_rounded, size: 20),
          ),
        ],
      ),
      body: filteredData.isEmpty
          ? EmptyState(
              icon: Icons.layers_clear_rounded,
              title: 'No Records Found',
              description: 'No data matches visibility filters for "$_searchQuery".',
              actionLabel: 'Clear Search',
              onAction: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return _buildDataCard(filteredData[index], index);
              },
            ),
    );
  }

  Widget _buildDataCard(int dataIndex, int listIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => HapticFeedback.selectionClick(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ID: ${100 + dataIndex}',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppTheme.secondary),
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: Colors.white24, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            _buildField('username', 'user_dev_${dataIndex + 1}'),
            const SizedBox(height: 12),
            _buildField('email', 'dev${dataIndex + 1}@example.supabase.com'),
            const SizedBox(height: 12),
            _buildField('is_active', 'true', isBoolean: true),
            const SizedBox(height: 12),
            _buildField('created_at', '2024-02-22 14:02:30'),
            const SizedBox(height: 20),
            SupaButton(
              onPressed: () => _showJsonViewer(context, dataIndex),
              backgroundColor: AppTheme.accent.withOpacity(0.05),
              foregroundColor: AppTheme.accent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code_rounded, size: 16),
                  SizedBox(width: 8),
                  Text('View Raw JSON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, delay: (listIndex * 50).ms);
  }

  void _showJsonViewer(BuildContext context, int index) {
    final mockJson = {
      'id': 100 + index,
      'username': 'user_dev_${index + 1}',
      'email': 'dev${index + 1}@example.supabase.com',
      'is_active': true,
      'metadata': {
        'last_login': '2024-02-22T14:02:30Z',
        'roles': ['developer', 'admin'],
        'preferences': {
          'theme': 'dark',
          'notifications': true,
        }
      },
      'stats': {
        'queries_run': 154,
        'uptime_pct': 99.9,
      }
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RAW RECORD DATA',
                    style: TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: JsonTreeView(
                    data: mockJson,
                    initialExpanded: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String key, String value, {bool isBoolean = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key.toUpperCase(),
          style: TextStyle(
            color: AppTheme.secondary.withOpacity(0.5),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isBoolean ? AppTheme.accent : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
