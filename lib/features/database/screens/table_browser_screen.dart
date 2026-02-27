import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/core/widgets/empty_state.dart';
import 'package:supa_app/features/database/screens/data_view_screen.dart';

class TableBrowserScreen extends StatefulWidget {
  const TableBrowserScreen({super.key});

  @override
  State<TableBrowserScreen> createState() => _TableBrowserScreenState();
}

class _TableBrowserScreenState extends State<TableBrowserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedIndex;

  final List<Map<String, dynamic>> _allTables = [
    {'name': 'profiles', 'description': 'Public user profile data', 'rows': 1242, 'type': 'BASE TABLE', 'size': '1.2 MB'},
    {'name': 'posts', 'description': 'Social media posts and content', 'rows': 8540, 'type': 'BASE TABLE', 'size': '4.8 MB'},
    {'name': 'comments', 'description': 'Post interactions and replies', 'rows': 42100, 'type': 'BASE TABLE', 'size': '12.4 MB'},
    {'name': 'settings', 'description': 'App-wide configuration flags', 'rows': 12, 'type': 'BASE TABLE', 'size': '16 KB'},
    {'name': 'nodes_raw', 'description': 'Raw infrastructure telemetry', 'rows': 120500, 'type': 'FOREIGN TABLE', 'size': 'N/A'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTables = _allTables
        .asMap()
        .entries
        .where((e) => e.value['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Tables', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: filteredTables.isEmpty
                ? EmptyState(
                    icon: Icons.table_bar_rounded,
                    title: 'No Tables Found',
                    description: 'No tables match your search query "$_searchQuery".',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    itemCount: filteredTables.length,
                    itemBuilder: (context, index) {
                      final e = filteredTables[index];
                      final table = e.value;
                      final originalIndex = e.key;
                      return _buildTableItem(context, originalIndex, table);
                    },
                  ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search tables...',
                      hintStyle: TextStyle(color: AppTheme.secondary.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.secondary, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildTableItem(BuildContext context, int index, Map<String, dynamic> table) {
    final isExpanded = _expandedIndex == index;

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isExpanded ? AppTheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? Colors.white.withOpacity(0.1) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Icon(
                Icons.table_rows_rounded, 
                color: isExpanded ? AppTheme.accent : AppTheme.secondary, 
                size: 20,
              ),
            ),
            title: Text(
              table['name'],
              style: TextStyle(
                fontWeight: FontWeight.w600, 
                fontSize: 16,
                color: isExpanded ? AppTheme.accent : Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${table['rows']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Text('rows', style: TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white24,
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  const SizedBox(height: 12),
                  Text(
                    table['description'],
                    style: TextStyle(color: AppTheme.secondary, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailBadge('TYPE', table['type']),
                      _buildDetailBadge('SIZE', table['size']),
                      SizedBox(
                        height: 32,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DataViewScreen(tableName: table['name']),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: AppTheme.accent.withOpacity(0.1),
                            foregroundColor: AppTheme.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('OPEN DATA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildDetailBadge(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.secondary.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
