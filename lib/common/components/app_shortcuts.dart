import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppKeyboardShortcutHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onAdd;
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

    if (onAdd != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyA, alt: true)] = onAdd!;
      bindings[const SingleActivator(LogicalKeyboardKey.f2)] = onAdd!;
    }

    if (onSave != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyS, alt: true)] = onSave!;
      bindings[const SingleActivator(LogicalKeyboardKey.keyS, control: true)] = onSave!;
    }

    if (onDelete != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyD, alt: true)] = onDelete!;
    }

    if (onCancel != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyC, alt: true)] = onCancel!;
      bindings[const SingleActivator(LogicalKeyboardKey.keyR, alt: true)] = onCancel!;
      bindings[const SingleActivator(LogicalKeyboardKey.escape)] = onCancel!;
    }

    if (onExit != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyE, alt: true)] = onExit!;
    }

    if (onSearch != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyS, shift: true)] = onSearch!;
      bindings[const SingleActivator(LogicalKeyboardKey.keyF, control: true)] = onSearch!;
      bindings[const SingleActivator(LogicalKeyboardKey.f3)] = onSearch!;
    }

    if (onPrint != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.keyP, alt: true)] = onPrint!;
      bindings[const SingleActivator(LogicalKeyboardKey.keyP, control: true)] = onPrint!;
    }

    return CallbackShortcuts(
      bindings: bindings,
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
