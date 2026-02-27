import 'package:flutter/material.dart';
import 'package:supa_app/core/theme/app_theme.dart';

class SqlEditor extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onExecute;

  const SqlEditor({
    super.key,
    this.initialValue = '',
    this.onChanged,
    this.onExecute,
  });

  @override
  State<SqlEditor> createState() => _SqlEditorState();
}

class _SqlEditorState extends State<SqlEditor> {
  late SqlEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SqlEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 8,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              color: Colors.white70,
            ),
            cursorColor: AppTheme.accent,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(20),
              border: InputBorder.none,
              hintText: 'Enter SQL query...',
              hintStyle: TextStyle(color: Colors.white24),
            ),
          ),
          if (widget.onExecute != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: widget.onExecute,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('RUN QUERY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SqlEditingController extends TextEditingController {
  SqlEditingController({super.text});

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final List<TextSpan> children = [];
    
    // Simple Regex for SQL Keywords
    final keywords = RegExp(
      r'\b(SELECT|FROM|WHERE|INSERT|UPDATE|DELETE|JOIN|ON|GROUP BY|ORDER BY|LIMIT|OFFSET|HAVING|AND|OR|IN|NOT|NULL|IS|AS|CREATE|TABLE|DROP|ALTER|TRUNCATE|DATABASE|SCHEMA|VIEW|INDEX|PROCEDURE|FUNCTION|TRIGGER)\b',
      caseSensitive: false,
    );

    final values = RegExp(r"'.*?'|\b\d+\b");

    text.splitMapJoin(
      RegExp('${keywords.pattern}|${values.pattern}'),
      onMatch: (m) {
        final match = m[0]!;
        if (keywords.hasMatch(match)) {
          children.add(TextSpan(text: match, style: style?.copyWith(color: AppTheme.accent, fontWeight: FontWeight.bold)));
        } else if (values.hasMatch(match)) {
          children.add(TextSpan(text: match, style: style?.copyWith(color: Colors.orangeAccent)));
        } else {
          children.add(TextSpan(text: match, style: style));
        }
        return '';
      },
      onNonMatch: (n) {
        children.add(TextSpan(text: n, style: style));
        return '';
      },
    );

    return TextSpan(children: children, style: style);
  }
}
