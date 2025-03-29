import 'dart:async';
import 'dart:ui';

class StreamLanguage {
  const StreamLanguage._();

  static StreamController<Locale> languageStream = StreamController.broadcast();
}
