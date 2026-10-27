import 'package:flutter/widgets.dart';

class AtlasRadius {
  const AtlasRadius._();

  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius md = BorderRadius.all(Radius.circular(13));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius bubble = BorderRadius.all(Radius.circular(20));
  static const BorderRadius composer = BorderRadius.all(Radius.circular(28));
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(24),
  );
}
