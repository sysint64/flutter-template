import 'package:drivers/currency_money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ethCurrencyMeta = CryptoCurrencyMeta(
    decimals: 18,
    rounding: 6,
  );

  test('test double', () async {
    final value = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 10);
    expect(value.toDouble(), 10.0);
  });

  test('test hex', () async {
    final value = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 10);
    expect(value.toHex(), '0x8ac7230489e80000');
  });

  test('test rounding', () async {
    final value =
        CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 10.66666666666666);
    expect(value.toString(), '10.666667');
  });

  test('test + operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 10.5);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 0.5);
    expect((a + b).toString(), '11');
  });

  test('test - operator', () async {
    final a =
        CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 10.66666666666666);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 0.66666666666666);
    expect((a - b).toString(), '10');
  });

  test('test > operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 5);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    expect(a > b, true);
  });

  test('test < operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 5);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    expect(b < a, true);
  });

  test('test <= operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    final d = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 5);

    expect(b <= a, true);
    expect(a <= b, true);
    expect(a <= d, true);
    expect(d <= a, false);
  });

  test('test >= operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    final d = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 5);

    expect(b >= a, true);
    expect(a >= b, true);
    expect(d >= a, true);
    expect(a >= d, false);
  });

  test('test == operator', () async {
    final a = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    final b = CryptoCurrencyMoney.fromDouble(ethCurrencyMeta, 4);
    expect(b == a, true);
    expect(a == b, true);
  });
}
