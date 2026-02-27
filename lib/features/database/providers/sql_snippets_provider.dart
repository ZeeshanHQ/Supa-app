import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supa_app/features/database/models/sql_snippet.dart';

class SqlSnippetsNotifier extends StateNotifier<List<SqlSnippet>> {
  SqlSnippetsNotifier() : super(_mockSnippets);

  static final List<SqlSnippet> _mockSnippets = [
    const SqlSnippet(
      id: '1',
      title: 'Get All Active Users',
      query: 'SELECT * FROM users WHERE status = \'active\' AND last_login > NOW() - INTERVAL \'7 days\' ORDER BY last_login DESC;',
      category: 'Users',
    ),
    const SqlSnippet(
      id: '2',
      title: 'Recent Audit Logs',
      query: 'SELECT action, user_id, created_at FROM audit_logs WHERE created_at > NOW() - INTERVAL \'24 hours\' LIMIT 50;',
      category: 'Security',
    ),
    const SqlSnippet(
      id: '3',
      title: 'Product Inventory Check',
      query: 'SELECT name, stock_quantity, price FROM products WHERE stock_quantity < 10 ORDER BY stock_quantity ASC;',
      category: 'Inventory',
    ),
    const SqlSnippet(
      id: '4',
      title: 'Monthly Revenue Report',
      query: 'SELECT SUM(amount) as total, category FROM transactions WHERE created_at >= date_trunc(\'month\', CURRENT_DATE) GROUP BY category;',
      category: 'Finance',
    ),
  ];

  void addSnippet(SqlSnippet snippet) {
    state = [...state, snippet];
  }

  void removeSnippet(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void updateSnippet(SqlSnippet snippet) {
    state = [
      for (final s in state)
        if (s.id == snippet.id) snippet else s
    ];
  }
}

final sqlSnippetsProvider = StateNotifierProvider<SqlSnippetsNotifier, List<SqlSnippet>>((ref) {
  return SqlSnippetsNotifier();
});

final queryExecutionProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));
  
  // Mock results based on query type
  if (query.toLowerCase().contains('users')) {
    return List.generate(5, (index) => {
      'id': index + 101,
      'username': 'dev_user_${index + 1}',
      'email': 'dev${index + 1}@example.com',
      'status': 'active',
      'last_login': '2024-02-22T10:00:00Z',
    });
  } else if (query.toLowerCase().contains('audit_logs')) {
    return List.generate(3, (index) => {
      'action': index % 2 == 0 ? 'LOGIN' : 'UPDATE_PROFILE',
      'user_id': 100 + index,
      'created_at': '2024-02-22T08:30:00Z',
    });
  }
  
  return [{'message': 'Query executed successfully', 'rows_affected': 0}];
});
