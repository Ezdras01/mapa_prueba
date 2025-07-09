import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ResponsiveScaffold extends StatefulWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget tabletPortrait;
  final PreferredSizeWidget? appBar;

  const ResponsiveScaffold({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.tabletPortrait,
    this.appBar,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> with WidgetsBindingObserver {
  bool? _isTablet;
  bool _orientationLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lockInitialOrientation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  Future<void> _lockInitialOrientation() async {
    // 1. Bloqueo temporal inicial
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // 2. Obtenemos el PlatformDispatcher para acceder a las propiedades de la pantalla
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final physicalSize = platformDispatcher.views.first.physicalSize;
    final devicePixelRatio = platformDispatcher.views.first.devicePixelRatio;
    final shortestSide = physicalSize.shortestSide / devicePixelRatio;

    bool isTablet;
    if (Platform.isAndroid) {
      isTablet = shortestSide >= 600 || 
                (physicalSize.width >= 2000 && physicalSize.height >= 2000);
    } else {
      isTablet = shortestSide >= 600;
    }

    // 3. Aplicamos la orientación definitiva
    if (!isTablet) {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    if (mounted) {
      setState(() {
        _isTablet = isTablet;
        _orientationLocked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_orientationLocked || _isTablet == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: widget.appBar,
      body: _isTablet!
          ? OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.landscape
                    ? widget.tablet
                    : widget.mobile;
              },
            )
          : widget.mobile,
    );
  }
}