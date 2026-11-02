import 'package:kontrol_protocol/kontrol_protocol.dart';
import 'package:test/test.dart';

void main() {
  test('default port is 7531', () {
    expect(kDefaultPort, 7531);
  });
}
