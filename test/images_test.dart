/// Generated by spider on 2020-07-26 11:57:32.903152

import 'dart:io';

import 'package:bookclub/resources/images.dart';
import 'package:test/test.dart';

void main() {
  test('images assets test', () {
    expect(true, File(Images.googleLogo).existsSync());
    expect(true, File(Images.logo).existsSync());
  });
}
