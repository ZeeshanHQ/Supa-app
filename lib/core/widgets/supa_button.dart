import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supa_app/core/theme/app_theme.dart';

class SupaButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isFullWidth;
  final bool isLoading;
  final OutlinedBorder? shape;

  const SupaButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isFullWidth = true,
    this.isLoading = false,
    this.shape,
  });

  @override
  State<SupaButton> createState() => _SupaButtonState();
}

class _SupaButtonState extends State<SupaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 100.ms,
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scale(_isPressed ? 0.96 : 1.0),
      child: SizedBox(
        width: widget.isFullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          onHover: (_) {},
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? AppTheme.accent,
            foregroundColor: widget.foregroundColor ?? AppTheme.background,
            shape: widget.shape,
            minimumSize: const Size(0, 48), // Enforce accessibility height
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
               if (states.contains(WidgetState.pressed)) {
                 return (widget.foregroundColor ?? AppTheme.background).withOpacity(0.1);
               }
               return null;
            }),
          ),
          child: GestureDetector(
            onPanDown: (_) => setState(() => _isPressed = true),
            onPanCancel: () => setState(() => _isPressed = false),
            onPanEnd: (_) => setState(() => _isPressed = false),
            child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.background),
                  ),
                )
              : widget.child,
          ),
        ),
      ),
    );
  }
}
