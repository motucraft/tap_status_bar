import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatusBarTapNotifier extends StatefulWidget {
  final Widget child;
  final VoidCallback onStatusBarTap;

  const StatusBarTapNotifier({super.key, required this.child, required this.onStatusBarTap});

  @override
  State<StatusBarTapNotifier> createState() => _StatusBarTapNotifierState();
}

class _StatusBarTapNotifierState extends State<StatusBarTapNotifier> {
  ScrollController? _primaryScrollController;
  _CustomScrollPositionWithSingleContext? _scrollPositionWithSingleContext;

  @override
  void initState() {
    super.initState();
    _primaryScrollController =
        PrimaryScrollController.maybeOf(Navigator.of(context).context) ?? PrimaryScrollController.maybeOf(context);

    if (_primaryScrollController != null) {
      _scrollPositionWithSingleContext = _CustomScrollPositionWithSingleContext(
        context: context,
        callback: widget.onStatusBarTap,
      );
      _primaryScrollController!.attach(_scrollPositionWithSingleContext!);
    }
  }

  @override
  void dispose() {
    if (_primaryScrollController != null) {
      _primaryScrollController!.detach(_scrollPositionWithSingleContext!);
    }
    if (_scrollPositionWithSingleContext != null) {
      _scrollPositionWithSingleContext!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(_) => widget.child;
}

class _CustomScrollPositionWithSingleContext extends ScrollPositionWithSingleContext {
  final VoidCallback _callback;

  _CustomScrollPositionWithSingleContext({
    required BuildContext context,
    required VoidCallback callback,
  })  : _callback = callback,
        super(physics: const NeverScrollableScrollPhysics(), context: _CustomScrollContext(context));

  @override
  Future<void> animateTo(_, {required duration, required curve}) async => _callback();
}

class _CustomScrollContext extends ScrollContext {
  _CustomScrollContext(this._context);

  final BuildContext _context;

  @override
  AxisDirection get axisDirection => AxisDirection.down;

  @override
  BuildContext get notificationContext => _context;

  @override
  void saveOffset(double offset) {}

  @override
  void setCanDrag(bool value) {}

  @override
  void setIgnorePointer(bool value) {}

  @override
  void setSemanticsActions(Set<SemanticsAction> actions) {}

  @override
  BuildContext get storageContext => _context;

  @override
  TickerProvider get vsync => _CustomTickerProvider();

  @override
  double get devicePixelRatio => MediaQuery.of(_context).devicePixelRatio;
}

class _CustomTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
