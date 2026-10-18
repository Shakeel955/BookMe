import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_me/main.dart';
import 'package:book_me/models.dart';
import 'package:book_me/app_state.dart';

void main() {
  group('BookMe QA Unit & Widget Tests', () {
    test('Booking calculations test', () {
      final stay = kStays.first; // Student Nest Hostel, price 1500, discountPct 10
      final room = stay.rooms.first; // Dorm bed, 4 beds, price 1500
      final checkIn = DateTime(2026, 10, 1);
      final checkOut = DateTime(2026, 10, 4); // 3 nights
      final booking = Booking('test_1', stay, room, checkIn, checkOut, 2, 'Pay at arrival', 'Confirmed');

      expect(booking.nights, 3);
      // Room price 1500 * 3 nights * 2 guests = 9000 subtotal
      expect(booking.subtotal, 9000);
      // Student discount 10% of 9000 = 900
      expect(booking.discount, 900);
      // Total = 9000 - 900 = 8100
      expect(booking.total, 8100);
      expect(booking.upcoming, true);
    });

    test('AppState state management test', () {
      final state = AppState.i;
      
      // Test save toggle
      state.saved.clear();
      expect(state.saved.contains('stay_1'), false);
      state.toggleSaved('stay_1');
      expect(state.saved.contains('stay_1'), true);
      state.toggleSaved('stay_1');
      expect(state.saved.contains('stay_1'), false);

      // Test tab switching
      state.update(() {
        state.tab = 2;
      });
      expect(state.tab, 2);

      // Test draft booking start
      state.startDraft(kStays[1]);
      expect(state.dStay, kStays[1]);
      expect(state.dRoom, isNotNull);
      expect(state.dGuests, 1);
    });

    testWidgets('Full app smoke test & navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const BookMeApp());
      // Pump initial splash duration
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
