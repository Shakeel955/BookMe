import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'account.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final s = AppState.i;
        const items = [(Icons.home_outlined, 'Explore'), (Icons.favorite_border, 'Saved'), (Icons.calendar_today_outlined, 'Trips'), (Icons.person_outline, 'Profile')];
        return Scaffold(
            body: SafeArea(bottom: false, child: IndexedStack(index: s.tab, children: const [HomeTab(), SavedTab(), TripsTab(), ProfileTab()])),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(color: c.p.surface, border: Border(top: BorderSide(color: c.p.border))),
                child: SafeArea(
                    top: false,
                    child: Row(children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => s.update(() => s.tab = i),
                                child: SizedBox(
                                    height: 64,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Icon(items[i].$1, size: 22, color: i == s.tab ? c.p.tealText : c.p.grey),
                                      gap(4),
                                      Txt(items[i].$2, size: 11, w: kSB, color: i == s.tab ? c.p.tealText : c.p.grey),
                                    ])))),
                    ]))));
      });
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeState();
}

class _HomeState extends State<HomeTab> {
  bool loading = true;
  StayType? cat;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    if (loading) {
      return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Skel(w: 120, h: 14),
            gap(12),
            const Skel(w: 240, h: 28),
            gap(12),
            const Skel(h: 52, r: 14),
            gap(12),
            Row(children: [const Skel(w: 60, h: 44, r: 22), gapW(8), const Skel(w: 80, h: 44, r: 22), gapW(8), const Skel(w: 80, h: 44, r: 22)]),
            gap(12),
            const Skel(h: 110, r: 20),
            gap(12),
            const Row(children: [Expanded(child: Skel(h: 210, r: 18)), SizedBox(width: 12), Expanded(child: Skel(h: 210, r: 18))]),
          ]));
    }
    final list = kStays.where((s) => cat == null || s.type == cat).take(8).toList();
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Txt('Assalam o Alaikum', size: 13, color: p.grey),
              gap(2),
              const Txt('Where will you\nstay in Islamabad?', size: 24, w: kXB, height: 1.2),
            ])),
            RoundIcon(Icons.notifications_none, tip: 'Notifications', onTap: () => context.push('/notifications')),
            gapW(8),
            RoundIcon(Icons.person_outline, tip: 'Profile', onTap: () => AppState.i.update(() => AppState.i.tab = 3)),
          ]),
          gap(18),
          Row(children: [
            Expanded(child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.border)),
                    child: Row(children: [Icon(Icons.search, size: 20, color: p.grey), gapW(10), Expanded(child: Txt('Hostel, area or university', color: p.grey, maxLines: 1))])))),
            gapW(10),
            GestureDetector(
                onTap: () => context.push('/search?filters=1'),
                child: Container(width: 52, height: 52, decoration: BoxDecoration(color: kTeal, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.tune, color: Colors.white))),
          ]),
          gap(16),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            AppChip('All', on: cat == null, onTap: () => setState(() => cat = null)),
            gapW(8),
            AppChip('Hotels', on: cat == StayType.hotel, onTap: () => setState(() => cat = StayType.hotel)),
            gapW(8),
            AppChip('Hostels', on: cat == StayType.hostel, onTap: () => setState(() => cat = StayType.hostel)),
            gapW(8),
            AppChip('Guest Houses', on: cat == StayType.guestHouse, onTap: () => setState(() => cat = StayType.guestHouse)),
          ])),
          gap(20),
          GestureDetector(
              onTap: () => context.push('/offers'),
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [kTeal, Color(0xFF0369A1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: kTeal.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_offer_outlined, color: Colors.white)),
                    gapW(12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Txt('Student & Job-Seeker Deals', size: 15, w: kXB, color: Colors.white),
                      SizedBox(height: 2),
                      Txt('Up to 15% off near universities and offices', size: 12, color: Colors.white70),
                    ])),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                  ]))),
          SectionHeader('Featured stays', action: 'See all', onAction: () => context.push('/search')),
          SizedBox(height: 285, child: ListView(scrollDirection: Axis.horizontal, children: [for (final s in list) Padding(padding: const EdgeInsetsDirectional.only(end: 12), child: StayCard(s))])),
          SectionHeader('Browse by area', action: 'See all', onAction: () => context.push('/areas')),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in ['F-6', 'F-7', 'I-14', 'H-12', 'G-11']) AppChip(a, onTap: () => context.push('/search?q=${Uri.encodeQueryComponent(a)}')),
          ]),
        ]));
  }
}

class SavedTab extends StatelessWidget {
  const SavedTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final list = kStays.where((s) => AppState.i.saved.contains(s.id)).toList();
        return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Txt('Saved', size: 26, w: kXB),
              gap(4),
              if (list.isNotEmpty) Txt('${list.length} stays you liked', size: 13, color: c.p.grey),
              gap(16),
              Expanded(
                  child: list.isEmpty
                      ? EmptyState(Icons.favorite_border, 'Nothing saved yet', 'Tap the heart on any stay to save it for later.', 'Explore stays', () => AppState.i.update(() => AppState.i.tab = 0))
                      : ListView.separated(itemCount: list.length, separatorBuilder: (_, _) => gap(12), itemBuilder: (_, i) => StayRow(list[i]))),
            ]));
      });
}

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});
  @override
  State<TripsTab> createState() => _TripsState();
}

class _TripsState extends State<TripsTab> {
  bool upcoming = true;

  Widget _card(BuildContext c, Booking b) {
    final p = c.p;
    final st = {'Confirmed': (kGreen, const Color(0xFFDCFCE7)), 'Pending': (const Color(0xFF92400E), const Color(0xFFFEF3C7)), 'Completed': (p.grey, p.border), 'Cancelled': (kRed, const Color(0xFFFEE2E2))}[b.status]!;
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
            onTap: () => c.push('/booking/${b.id}'),
            child: Box(radius: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Photo(b.stay.tint, w: 56, h: 56, r: 12),
                gapW(12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(b.stay.name, size: 15, w: kB, maxLines: 1), gap(2), Txt('Booking ${b.id}', size: 12, color: p.grey)])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: st.$2, borderRadius: BorderRadius.circular(999)), child: Text(b.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: st.$1))),
              ]),
              gap(14),
              Row(children: [Icon(Icons.calendar_today_outlined, size: 18, color: p.tealText), gapW(8), Txt('${dRange(b.checkIn, b.checkOut)}, ${b.nights} nights', size: 13, w: kSB)]),
              gap(14),
              Row(children: [
                Expanded(child: Btn(b.status == 'Completed' ? 'Book again' : 'View details', () => b.status == 'Completed' ? c.push('/stay/${b.stay.id}') : c.push('/booking/${b.id}'), outline: true, h: 44)),
                gapW(10),
                Expanded(child: Btn(b.status == 'Completed' ? 'Write a review' : 'Directions', () => b.status == 'Completed' ? c.push('/write-review/${b.stay.id}') : snack(c, 'Opening directions (demo)'), h: 44)),
              ]),
            ]))));
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final list = AppState.i.bookings.where((b) => b.upcoming == upcoming).toList();
        return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Txt('My trips', size: 26, w: kXB),
              gap(14),
              Row(children: [AppChip('Upcoming', on: upcoming, onTap: () => setState(() => upcoming = true)), gapW(8), AppChip('Past', on: !upcoming, onTap: () => setState(() => upcoming = false))]),
              gap(12),
              Expanded(
                  child: list.isEmpty
                      ? EmptyState(Icons.calendar_today_outlined, 'No trips yet', 'Your bookings will show up here.', 'Find a stay', () => AppState.i.update(() => AppState.i.tab = 0))
                      : ListView(children: [for (final b in list) _card(c, b)])),
            ]));
      });
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final s = AppState.i, p = c.p;
        Widget stat(String v, String l) => Expanded(child: Column(children: [Txt(v, size: 20, w: kXB), Txt(l, size: 12, color: p.grey)]));
        final initials = s.name.trim().split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
        return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Txt('Profile', size: 26, w: kXB),
              gap(18),
              Row(children: [
                Container(width: 64, height: 64, alignment: Alignment.center, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal), child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
                gapW(14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Txt(s.name, size: 18, w: kXB),
                  gap(2),
                  Txt(s.email, size: 13, color: p.grey),
                  gap(6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: p.tint, borderRadius: BorderRadius.circular(999)), child: Text(s.role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.tealText))),
                ])),
              ]),
              gap(20),
              Box(padding: const EdgeInsets.symmetric(vertical: 14), child: Row(children: [stat('${s.bookings.length}', 'Trips'), stat('${s.saved.length}', 'Saved'), stat('2', 'Reviews')])),
              gap(12),
              RowTile(Icons.person_outline, 'Personal details', trailing: chevron(c), onTap: () => c.push('/edit-profile')),
              RowTile(Icons.credit_card, 'Payment methods', trailing: chevron(c), onTap: () => c.push('/payments')),
              RowTile(Icons.notifications_none, 'Notifications', trailing: chevron(c), onTap: () => c.push('/notifications')),
              RowTile(Icons.language, 'Settings', sub: s.urdu ? 'اردو' : 'English', trailing: chevron(c), onTap: () => c.push('/settings')),
              RowTile(Icons.help_outline, 'Help and support', trailing: chevron(c), onTap: () => c.push('/help')),
              RowTile(Icons.logout, 'Log out', color: kRed, onTap: () => confirmLogout(c)),
            ]));
      });
}
