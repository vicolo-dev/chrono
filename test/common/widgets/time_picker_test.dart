import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('time picker test', (WidgetTester tester) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  PickerResult<TimeOfDay>? result = await showTimePickerDialog(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (result != null) {
                    selectedTime = result.value;
                  }
                  // await showTimePicker(
                  //     context: context, initialTime: selectedTime);
                },
                child: Text('Open Time Picker'),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open Time Picker'));
    await tester.pumpAndSettle();
    // expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    // expect(selectedTime,
    //     TimeOfDay(hour: 12, minute: 0).replacing(hour: DateTime.now().hour));
  });
}
