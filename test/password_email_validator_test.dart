
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/validator/myvalidator.dart';

void main(){
  test('empty email test', () {
    String result = MyValidator.emailValidator('');
    expect(result, 'Please enter email');
  });

  test('valid email test', () {
    String result = MyValidator.emailValidator('tony@starkindustries.com');
    expect(result, 'email is valid');
  });

  test('empty password test', () {
    String result = MyValidator.passwordValidator('abcd');
    expect(result, 'Please enter password');
  });

  test('valid password test', () {
    String result = MyValidator.passwordValidator('abcdefghijk');
  });
}