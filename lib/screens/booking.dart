import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class RoomsScreen extends StatelessWidget {
  final String id;
  const RoomsScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final s = stayById(id), p = context.p;
    return ListenableBuilder(
        listenable: AppState.i,
        builder: (c, _) => ScreenBox(
            title: 'Choose room',
            bottom: Btn('Continue', () => context.push('/booking')),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Txt(s.name, size: 13, color: p.grey),
              gap(8),
              for (final r in s.rooms)
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                        onTap: () => AppState.i.update(() => AppState.i.dRoom = r),
                        child: Box(
                            border: AppState.i.dRoom?.name == r.name ? kTeal : null,
                            bw: AppState.i.dRoom?.name == r.name ? 2 : 1,
                            child: Row(children: [
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Txt(r.name, size: 15, w: kB),
                                gap(2),
                                Txt(r.info, size: 12, color: p.grey),
                                gap(8),
                                Price(r.price),
                              ])),
                              RadioDot(AppState.i.dRoom?.name == r.name),
                            ])))),
            ])));
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  Future<void> _pick(BuildContext c, bool isIn) async {
    final s = AppState.i;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final r = await showDatePicker(
        context: c,
        initialDate: isIn ? s.dIn! : s.dOut!,
        firstDate: isIn ? today : s.dIn!.add(const Duration(days: 1)),
        lastDate: today.add(const Duration(days: 365)));
    if (r == null) return;
    s.update(() {
      if (isIn) {
        s.dIn = r;
        if (!s.dOut!.isAfter(r)) s.dOut = r.add(const Duration(days: 1));
      } else {
        s.dOut = r;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return ListenableBuilder(
        listenable: AppState.i,
        builder: (c, _) {
          final s = AppState.i;
          if (s.dStay == null || s.dRoom == null) {
            return ScreenBox(title: 'Confirm booking', child: Txt('Pick a stay first.', color: p.grey));
          }
          final b = Booking('draft', s.dStay!, s.dRoom!, s.dIn!, s.dOut!, s.dGuests, s.payment, 'Confirmed');
          Widget dt(String l, DateTime d, bool isIn) => Expanded(
              child: GestureDetector(
                  onTap: () => _pick(c, isIn),
                  child: Box(radius: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(l, size: 11, color: p.grey), gap(2), Txt(dShort(d), size: 15, w: kB)]))));
          Widget step(IconData i, VoidCallback f, bool fill) => GestureDetector(onTap: f, child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: fill ? kTeal : p.surface, border: Border.all(color: fill ? kTeal : p.border)), child: Icon(i, size: 20, color: fill ? Colors.white : p.text)));
          return ScreenBox(
              title: 'Confirm booking',
              bottom: Btn('Confirm booking - ${rs(b.total)}', () {
                if (s.payment == 'Card' && s.card == null) {
                  context.push('/pay-failed');
                  return;
                }
                s.confirm();
                context.go('/confirmed');
              }),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Box(padding: const EdgeInsets.all(10), child: Row(children: [
                  Photo(b.stay.tint, w: 64, h: 64, r: 12),
                  gapW(12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(b.stay.name, size: 15, w: kB, maxLines: 1), gap(2), Txt('${b.room.name}, ${b.stay.area}', size: 12, color: p.grey), gap(4), Rate(b.stay.rating, n: b.stay.reviewCount)])),
                ])),
                const SectionHeader('Dates'),
                Row(children: [dt('Check-in', b.checkIn, true), gapW(10), dt('Check-out', b.checkOut, false)]),
                gap(10),
                Box(radius: 14, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
                  const Expanded(child: Txt('Guests', w: kSB)),
                  step(Icons.remove, () { if (s.dGuests > 1) s.update(() => s.dGuests--); }, false),
                  SizedBox(width: 40, child: Txt('${s.dGuests}', w: kB, align: TextAlign.center)),
                  step(Icons.add, () { if (s.dGuests < 6) s.update(() => s.dGuests++); }, true),
                ])),
                const SectionHeader('Price details'),
                Box(radius: 14, child: Column(children: [
                  KV('${rs(b.room.price)} x ${b.nights} nights${b.room.name.startsWith('Dorm') && s.dGuests > 1 ? ' x ${s.dGuests}' : ''}', rs(b.subtotal)),
                  if (b.discount > 0) KV('Student discount (${b.stay.discountPct}%)', '-${rs(b.discount)}', color: p.tealText),
                  gap(12),
                  Divider(color: p.border, height: 1),
                  Padding(padding: const EdgeInsets.only(top: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Txt('Total', size: 16, w: kXB), Txt(rs(b.total), size: 16, w: kXB, color: p.tealText)])),
                ])),
                SectionHeader('Payment', action: 'Manage', onAction: () => context.push('/payments')),
                Wrap(spacing: 8, runSpacing: 8, children: [for (final m in ['Pay at arrival', 'JazzCash', 'Card']) AppChip(m, on: s.payment == m, onTap: () => s.update(() => s.payment = m))]),
              ]));
        });
  }
}

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final b = AppState.i.last ?? AppState.i.bookings.first, p = context.p;
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  gap(32),
                  Container(width: 84, height: 84, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal), child: const Icon(Icons.check, size: 44, color: Colors.white)),
                  gap(20),
                  const Txt('Booking confirmed', size: 26, w: kXB),
                  gap(6),
                  Txt('Your stay is reserved. Show this booking ID at the front desk.', color: p.grey, align: TextAlign.center, height: 1.5),
                  gap(24),
                  Box(radius: 20, padding: const EdgeInsets.all(18), child: Column(children: [
                    Row(children: [Photo(b.stay.tint, w: 56, h: 56, r: 12), gapW(12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(b.stay.name, size: 15, w: kB), gap(2), Txt('${b.stay.area}, Islamabad', size: 12, color: p.grey)]))]),
                    gap(16),
                    Divider(color: p.border, height: 1),
                    KV('Booking ID', b.id),
                    KV('Dates', dRange(b.checkIn, b.checkOut)),
                    KV('Guests', '${b.guests}'),
                    KV('Payment', b.payment),
                    KV('Total', rs(b.total)),
                  ])),
                  const Spacer(),
                  Btn('View my trips', () {
                    AppState.i.update(() => AppState.i.tab = 2);
                    context.go('/home');
                  }),
                  gap(10),
                  Btn('Back to home', () {
                    AppState.i.update(() => AppState.i.tab = 0);
                    context.go('/home');
                  }, outline: true),
                ]))));
  }
}

class PayFailedScreen extends StatelessWidget {
  const PayFailedScreen({super.key});
  @override
  Widget build(BuildContext context) => SuccessView(
      icon: Icons.close, color: kRed, title: 'Payment failed',
      sub: 'We could not complete your payment. You have not been charged.',
      btn1: 'Try again', on1: () => Navigator.of(context).maybePop(),
      btn2: 'Choose another method', on2: () {
        AppState.i.update(() => AppState.i.payment = 'Pay at arrival');
        Navigator.of(context).maybePop();
      });
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final s = AppState.i;
        Widget m(IconData i, String t, String sub, String key) => RowTile(i, t, sub: sub, trailing: RadioDot(s.payment == key), onTap: () => s.update(() => s.payment = key));
        return ScreenBox(
            title: 'Payment methods',
            child: Column(children: [
              m(Icons.home_outlined, 'Pay at arrival', 'Pay cash at the front desk', 'Pay at arrival'),
              m(Icons.account_balance_wallet_outlined, 'JazzCash', '03XX XXXXXXX', 'JazzCash'),
              if (s.card != null) m(Icons.credit_card, 'Card', 'Ending in ${s.card}', 'Card'),
              gap(20),
              Btn('Add new method', () => context.push('/add-card'), outline: true),
            ]));
      });
}

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});
  @override
  State<AddCardScreen> createState() => _AddCardState();
}

class _AddCardState extends State<AddCardScreen> {
  final num = TextEditingController();
  bool save = true;
  @override
  void dispose() {
    num.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Add card',
      bottom: Btn('Save card', () {
        final d = num.text.replaceAll(RegExp(r'\D'), '');
        if (d.length < 12) {
          snack(context, 'Enter a valid card number');
          return;
        }
        AppState.i.update(() {
          AppState.i.card = d.substring(d.length - 4);
          AppState.i.payment = 'Card';
        });
        Navigator.of(context).maybePop();
      }),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Field(label: 'Card number', hint: '0000 0000 0000 0000', ctrl: num, type: TextInputType.number),
        const Row(children: [Expanded(child: Field(label: 'Expiry', hint: 'MM / YY')), SizedBox(width: 12), Expanded(child: Field(label: 'CVV', hint: '123', obscure: true))]),
        const Field(label: 'Name on card', hint: 'As printed on card'),
        gap(18),
        Row(children: [const Expanded(child: Txt('Save for next time', w: kSB)), Switch(value: save, activeTrackColor: kTeal, onChanged: (v) => setState(() => save = v))]),
      ]));
}

class BookingDetailsScreen extends StatelessWidget {
  final String id;
  const BookingDetailsScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final p = c.p;
        final list = AppState.i.bookings.where((x) => x.id == id).toList();
        if (list.isEmpty) return const ScreenBox(title: 'Booking details', child: Txt('Booking not found.'));
        final b = list.first;
        return ScreenBox(
            title: 'Booking details',
            child: Column(children: [
              Box(child: Row(children: [
                Photo(b.stay.tint, w: 56, h: 56, r: 12),
                gapW(12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(b.stay.name, size: 15, w: kB), gap(2), Txt('${b.stay.area}, Islamabad', size: 12, color: p.grey)])),
                Txt(b.status, size: 12, w: kB, color: b.status == 'Cancelled' ? kRed : p.tealText),
              ])),
              gap(12),
              Box(padding: const EdgeInsets.fromLTRB(14, 2, 14, 14), child: Column(children: [
                KV('Booking ID', b.id),
                KV('Check-in', dShort(b.checkIn)),
                KV('Check-out', dShort(b.checkOut)),
                KV('Room', b.room.name),
                KV('Guests', '${b.guests}'),
                KV('Payment', b.payment),
                KV('Total', rs(b.total)),
              ])),
              gap(16),
              if (b.upcoming) ...[
                Btn('Get directions', () => snack(c, 'Opening directions (demo)')),
                gap(10),
                Btn('Change dates', () => c.push('/change-dates/${b.id}'), outline: true),
                gap(10),
                Btn('Cancel booking', () => _cancel(c, b), outline: true, color: kRed),
              ],
            ]));
      });

  void _cancel(BuildContext c, Booking b) {
    String reason = 'Change of plans';
    showSheet<void>(c, StatefulBuilder(builder: (ctx, set) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Txt('Cancel this booking?', size: 20, w: kXB),
      gap(6),
      Txt('You can cancel for free up to 24 hours before check-in. Choose a reason (optional).', color: ctx.p.grey, height: 1.5),
      gap(16),
      Wrap(spacing: 8, runSpacing: 8, children: [for (final r in ['Change of plans', 'Found a cheaper stay', 'Dates changed']) AppChip(r, on: reason == r, onTap: () => set(() => reason = r))]),
      gap(20),
      Btn('Cancel booking', () {
        AppState.i.update(() => b.status = 'Cancelled');
        Navigator.of(ctx).pop();
        snack(c, 'Booking cancelled');
      }, color: kRed),
      gap(10),
      Btn('Keep booking', () => Navigator.of(ctx).pop(), outline: true),
    ])));
  }
}

class ChangeDatesScreen extends StatefulWidget {
  final String id;
  const ChangeDatesScreen({super.key, required this.id});
  @override
  State<ChangeDatesScreen> createState() => _ChangeState();
}

class _ChangeState extends State<ChangeDatesScreen> {
  late final Booking b = AppState.i.bookings.firstWhere((x) => x.id == widget.id, orElse: () => AppState.i.bookings.first);
  late DateTime month = DateTime(b.checkIn.year, b.checkIn.month);
  late DateTime? start = b.checkIn, end = b.checkOut;

  void _tap(DateTime d) => setState(() {
        if (start == null || end != null || d.isBefore(start!) || d == start) {
          start = d;
          end = null;
        } else {
          end = d;
        }
      });

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lead = DateTime(month.year, month.month, 1).weekday % 7;
    final days = DateTime(month.year, month.month + 1, 0).day;
    final nights = (start != null && end != null) ? end!.difference(start!).inDays : 0;
    final total = nights * b.room.price * (b.room.name.startsWith('Dorm') ? b.guests : 1);
    Widget cell(int d) {
      final day = DateTime(month.year, month.month, d);
      final edge = day == start || day == end;
      final mid = start != null && end != null && day.isAfter(start!) && day.isBefore(end!);
      final off = day.isBefore(today);
      return GestureDetector(
          onTap: off ? null : () => _tap(day),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: edge ? kTeal : (mid ? p.tint : null), borderRadius: BorderRadius.circular(12)),
              child: Text('$d', style: TextStyle(fontWeight: FontWeight.w600, color: edge ? Colors.white : (off ? p.grey.withAlpha(120) : p.text)))));
    }

    return ScreenBox(
        title: 'Change dates',
        bottom: Btn('Update dates', end == null ? null : () {
          AppState.i.update(() {
            b.checkIn = start!;
            b.checkOut = end!;
          });
          Navigator.of(context).maybePop();
          snack(context, 'Dates updated');
        }),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Txt('${b.stay.name}, Booking ${b.id}', size: 13, color: p.grey),
          gap(16),
          Box(child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)), icon: const Icon(Icons.chevron_left)),
              Txt('${kMonths[month.month - 1]} ${month.year}', size: 16, w: kXB),
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)), icon: const Icon(Icons.chevron_right)),
            ]),
            Row(children: [for (final w in 'SMTWTFS'.split('')) Expanded(child: Center(child: Txt(w, size: 12, color: p.grey)))]),
            gap(6),
            GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 7, childAspectRatio: 1.05, children: [
              for (var i = 0; i < lead; i++) const SizedBox(),
              for (var d = 1; d <= days; d++) cell(d),
            ]),
          ])),
          gap(16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Txt(end == null ? 'Pick your check-out date' : '$nights nights, ${dShort(start!)} - ${dShort(end!)}', size: 14, color: p.grey),
            if (end != null) Txt(rs(total), w: kB, color: p.tealText),
          ]),
        ]));
  }
}
