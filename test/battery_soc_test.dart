import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/models/inverter_data.dart';

void main() {
  group('battery SOC', () {
    test('lithium with BMS: the BMS value wins over the voltage estimate', () {
      // Real reading: BMS 97%, 53.1 V at rest (voltage table says 80%).
      expect(InverterData.getRealSoc(97, 53.1, bmsConnected: true), 97);
    });

    test('no BMS: an implausible reported value falls back to voltage', () {
      expect(InverterData.getRealSoc(100, 51.5), 30);
    });

    test('BMS reporting 0 is treated as missing data', () {
      expect(InverterData.getRealSoc(0, 53.1, bmsConnected: true), 80);
    });

    test('battery type detection', () {
      expect(InverterData.isLithiumWithBms({'value': 4, 'valueDisplay': 'LIC'}),
          isTrue);
      expect(InverterData.isLithiumWithBms({'value': 3}), isTrue);
      expect(InverterData.isLithiumWithBms({'value': 0, 'valueDisplay': 'AGM'}),
          isFalse);
      expect(InverterData.isLithiumWithBms({'valueDisplay': 'LI4'}), isTrue);
      expect(InverterData.isLithiumWithBms(null), isFalse);
    });

    test('fromJson uses the BMS SOC for the real device payload', () {
      final data = InverterData.fromJson({
        'deviceAttributeState': {
          'fields': {
            'batteryCapacity': {'value': 97},
            'batteryVoltage': {'value': 53.1},
            'batteryChargingCurrent': {'value': 0},
            'batteryDischargeCurrent': {'value': 0},
            'batteryType': {'value': 4, 'valueDisplay': 'LIC'},
          },
        },
      }, 'sn', '');
      expect(data.batterySoc, 97);
    });
  });
}
