import 'dart:html';

@TestOn('browser')
import 'package:test/test.dart';

void main() {
  group('Hello', () {
    setUp(() {});

    test('Browser Test', () {
      var currentLocation = window.location.href;

      print('----------------------------------------------------');
      print('CURRENT BROWSER LOCATION:\n  $currentLocation');
      print('----------------------------------------------------');
      print('BROWSER AGENT:\n  ${ window.navigator.userAgent }');
      print('----------------------------------------------------');

      expect(currentLocation, isNotEmpty);
    });
  });
}
