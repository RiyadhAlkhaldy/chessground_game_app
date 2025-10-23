import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const int defaultThinkingTimeMs = 1300;
const int minThinkingTimeMs = 100;
const int middleThinkingTimeMs = 5000;
const int maxThinkingTimeMs = 10000;

///
const kProvisionalDeviation = 110;
const kClueLessDeviation = 230;

// UI
const double kCupertinoBarBlurSigma = 30.0;
const double kCupertinoBarOpacity = 0.8;

const kDefaultSeedColor = Color.fromARGB(255, 191, 128, 29);

const kGoldenRatio = 1.61803398875;

/// Flex golden ratio base (flex has to be an int).
const kFlexGoldenRatioBase = 100000000000;

/// Flex golden ratio (flex has to be an int).
const kFlexGoldenRatio = 161803398875;

/// Use same box shadows as material widgets with elevation 1.
final List<BoxShadow> boardShadows =
    defaultTargetPlatform == TargetPlatform.iOS
        ? <BoxShadow>[]
        : kElevationToShadow[1]!;

const kMaxClockTextScaleFactor = 1.94;
const kEmptyWidget = SizedBox.shrink();
const kEmptyFen = '8/8/8/8/8/8/8/8 w - - 0 1';
const kTabletBoardTableSidePadding = 16.0;
const kBottomBarHeight = 56.0;
const kMaterialPopupMenuMaxWidth = 500.0;

/// The threshold to detect screens with a small remaining height minus board.
const kSmallHeightMinusBoard = 170;

// annotations
class _AllowedWidgetReturn {
  const _AllowedWidgetReturn();
}

/// Use to annotate a function that is allowed to return a Widget
const allowedWidgetReturn = _AllowedWidgetReturn();
