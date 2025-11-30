import 'package:dartchess/dartchess.dart';

abstract class CheckMateInterface {
  checkMate();
}

abstract class StaleMateInterface {
  staleMate();
}

abstract class DrawInterface {
  draw();
}

abstract class ResignInterface {
  resign(Side side);
}

abstract class AgreeDrawInterface {
  agreeDraw();
}

abstract class TimeOutInterface {
  timeOut();
}

abstract class InsufficientMaterialInterface {
  insufficientMaterial();
}

abstract class ThreefoldRepetitionInterface {
  threefoldRepetition();
}

abstract class FiftyMoveRuleInterface {
  fiftyMoveRule();
}
