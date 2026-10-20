import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppKeyboardShortcutHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;
  final VoidCallback? onExit;
  final VoidCallback? onSearch;
  final VoidCallback? onPrint;

  const AppKeyboardShortcutHandler({
    super.key,
    required this.child,
    this.onAdd,
    this.onEdit,
    this.onSave,
    this.onDelete,
    this.onCancel,
    this.onExit,
    this.onSearch,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final Map<ShortcutActivator, VoidCallback> bindings = {};

    return CallbackShortcuts(
      bindings: bindings,
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
