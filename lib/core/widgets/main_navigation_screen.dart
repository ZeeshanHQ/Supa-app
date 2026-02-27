import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supa_app/core/theme/app_theme.dart';
import 'package:supa_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:supa_app/features/database/screens/table_browser_screen.dart';
import 'package:supa_app/features/project/screens/ai_query_screen.dart';

import 'package:supa_app/features/database/screens/sql_snippets_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    TableBrowserScreen(),
    SqlSnippetsScreen(), // New Library tab
    AIQueryScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppTheme.background,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.secondary.withOpacity(0.5),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dns_outlined, size: 22),
              activeIcon: Icon(Icons.dns_rounded, size: 22),
              label: 'Infra',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_rows_outlined, size: 22),
              activeIcon: Icon(Icons.table_rows_rounded, size: 22),
              label: 'Tables',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.terminal_outlined, size: 22),
              activeIcon: Icon(Icons.terminal_rounded, size: 22),
              label: 'SQL',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined, size: 22),
              activeIcon: Icon(Icons.auto_awesome_rounded, size: 22),
              label: 'AI AI',
            ),
          ],
        ),
      ),
    );
  }
}
