// ignore_for_file: unused_element

import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum BottomTab {
  home,
  puzzles,
  learn,
  watch,
  more;

  String label(AppLocalizations strings) {
    switch (this) {
      case BottomTab.home:
        return strings.mobileHomeTab;
      case BottomTab.puzzles:
        return strings.mobilePuzzlesTab;
      case BottomTab.learn:
        return strings.learnMenu;
      case BottomTab.watch:
        return strings.mobileWatchTab;
      case BottomTab.more:
        return strings.more;
    }
  }

  IconData get icon {
    switch (this) {
      case BottomTab.home:
        return Symbols.home_rounded;
      case BottomTab.puzzles:
        return Symbols.extension_rounded;
      case BottomTab.watch:
        return Symbols.live_tv_rounded;
      case BottomTab.learn:
        return Symbols.school_rounded;
      case BottomTab.more:
        return Symbols.menu_rounded;
    }
  }
}

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final puzzlesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'puzzles');
final learnNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'learn');
final watchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'watch');
final moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

final homeScrollController = ScrollController(debugLabel: 'HomeScroll');
final puzzlesScrollController = ScrollController(debugLabel: 'PuzzlesScroll');
final learnScrollController = ScrollController(debugLabel: 'learnScroll');
final watchScrollController = ScrollController(debugLabel: 'WatchScroll');
final moreScrollController = ScrollController(debugLabel: 'MoreScroll');

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver =
    RouteObserver<PageRoute<void>>();

/// A [ChangeNotifier] that can be used to notify when the Home tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final homeTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Puzzles tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final puzzlesTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the learn tab is tapped, and all the built interactions
/// (pop stack, scroll to top) are done.
final learnTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Watch tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final watchTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the More tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final moreTabInteraction = _BottomTabInteraction();

class _BottomTabInteraction extends ChangeNotifier {
  void notifyItemTapped() {
    notifyListeners();
  }
}

/// [InheritedWidget] providing [Scaffold] properties of the [MainTabScaffold].
class MainTabScaffoldProperties extends InheritedWidget {
  /// Constructs a new [MainTabScaffoldProperties].
  const MainTabScaffoldProperties({
    required super.child,
    required this.extendBody,
    super.key,
  });

  /// The value of [Scaffold.extendBody] defined in the [MainTabScaffold].
  final bool extendBody;

  @override
  bool updateShouldNotify(MainTabScaffoldProperties oldWidget) {
    return extendBody != oldWidget.extendBody;
  }

  /// Retrieve the [MainTabScaffoldProperties] background color from the context.
  static MainTabScaffoldProperties? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MainTabScaffoldProperties>();
  }

  /// Returns true if the [MainTabScaffold] has an extended body.
  static bool hasExtendedBody(BuildContext context) {
    final properties = maybeOf(context);
    return properties != null && properties.extendBody;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('extendBody', extendBody));
  }
}

// Code taken and adapted from
// https://github.com/flutter/flutter/blob/main/packages/flutter/lib/src/cupertino/bottom_tab_bar.dart#L60

// Standard iOS 10 tab bar height.
const double _kTabBarHeight = 50.0;

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4D000000),
  darkColor: Color(0x29000000),
);
const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;
