import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/widgets/weather_icon.dart';

void main() {
  test('WMO codes map to weather groups', () {
    expect(weatherKindFor(0), WeatherKind.clear);
    expect(weatherKindFor(2), WeatherKind.partlyCloudy);
    expect(weatherKindFor(3), WeatherKind.overcast);
    expect(weatherKindFor(45), WeatherKind.fog);
    expect(weatherKindFor(53), WeatherKind.drizzle);
    expect(weatherKindFor(63), WeatherKind.rain);
    expect(weatherKindFor(81), WeatherKind.rain);
    expect(weatherKindFor(75), WeatherKind.snow);
    expect(weatherKindFor(95), WeatherKind.thunderstorm);
    expect(weatherKindFor(42), isNull);
  });
}
