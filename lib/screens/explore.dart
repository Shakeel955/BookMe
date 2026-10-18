import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

// ---------------- Areas ----------------
const _areas = [
  ('F-6', 'Near Jinnah Super Market', '8 stays'), ('F-7', 'Near F-7 Markaz', '6 stays'), ('G-11', 'Near G-11 Markaz', '5 stays'),
  ('I-14', 'Near Riphah University', '9 stays'), ('H-12', 'Near NUST', '11 stays'), ('Blue Area', 'Business district', '7 stays'), ('Bahria Town', 'Gated community', '4 stays'),
];

class AreasScreen extends StatefulWidget {
  const AreasScreen({super.key});
  @override
  State<AreasScreen> createState() => _AreasState();
}

class _AreasState extends State<AreasScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final list = _areas.where((a) => a.$1.toLowerCase().contains(q.toLowerCase()) || a.$2.toLowerCase().contains(q.toLowerCase())).toList();
    return ScreenBox(
        title: 'Choose area',
        child: Column(children: [
          SearchField(hint: 'Search area', onChanged: (v) => setState(() => q = v)),
          gap(8),
          for (final a in list)
            RowTile(Icons.place_outlined, a.$1, sub: a.$2, trailing: Txt(a.$3, size: 12, color: context.p.grey), onTap: () => context.push('/search?q=${Uri.encodeQueryComponent(a.$1)}')),
        ]));
  }
}

class SearchField extends StatelessWidget {
  final String hint;
  final String initial;
  final ValueChanged<String> onChanged;
  final TextEditingController? ctrl;
  const SearchField({super.key, required this.hint, required this.onChanged, this.initial = '', this.ctrl});
  @override
  Widget build(BuildContext context) {
    final p = context.p;
    final b = OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.border));
    return TextField(
        controller: ctrl,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: p.text),
        decoration: InputDecoration(
            hintText: tr(hint), hintStyle: TextStyle(color: p.grey), prefixIcon: Icon(Icons.search, size: 20, color: p.grey),
            filled: true, fillColor: p.surface, contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: b, enabledBorder: b, focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kTeal, width: 2))));
  }
}

// ---------------- Offers ----------------
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});
  @override
  State<OffersScreen> createState() => _OffersState();
}

class _OffersState extends State<OffersScreen> {
  String tab = 'All';
  @override
  Widget build(BuildContext context) {
    final p = context.p;
    final list = kStays.where((s) {
      if (s.offer == null) return false;
      if (tab == 'Student') return s.offer!.toLowerCase().contains('student');
      if (tab == 'Long stay') return s.offer!.contains('night');
      return true;
    }).toList();
    return ScreenBox(
        title: 'Offers',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, children: [for (final t in ['All', 'Student', 'Long stay']) AppChip(t, on: tab == t, onTap: () => setState(() => tab = t))]),
          gap(12),
          if (list.isEmpty) Padding(padding: const EdgeInsets.only(top: 40), child: Center(child: Txt('No offers in this category yet.', color: p.grey))),
          for (final s in list)
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                    onTap: () => context.push('/stay/${s.id}'),
                    child: Box(child: Row(children: [
                      Photo(s.tint, w: 64, h: 64, r: 12),
                      gapW(12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)), child: Text((s.badge ?? 'OFFER'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF92400E)))),
                        gap(6),
                        Txt(s.name, size: 14, w: kB, maxLines: 1),
                        gap(2),
                        Txt(s.offer!, size: 12, color: p.grey),
                      ])),
                    ])))),
        ]));
  }
}

// ---------------- Search + filters ----------------
class Filt {
  Set<StayType> types = {};
  RangeValues price = const RangeValues(1000, 20000);
  Set<String> perks = {};
  double minRating = 0;
  bool topRated = false;
  Filt copy() => Filt()..types = {...types}..price = price..perks = {...perks}..minRating = minRating..topRated = topRated;
  bool get active => types.isNotEmpty || price.start > 1000 || price.end < 20000 || perks.isNotEmpty || minRating > 0;
}

List<Stay> runSearch(String q, Filt f) {
  final t = q.trim().toLowerCase();
  final r = kStays.where((s) {
    if (t.isNotEmpty && !'${s.name} ${s.area} ${s.nearby} ${s.address}'.toLowerCase().contains(t)) return false;
    if (f.types.isNotEmpty && !f.types.contains(s.type)) return false;
    if (s.price < f.price.start || s.price > f.price.end) return false;
    if (s.rating < f.minRating) return false;
    for (final p in f.perks) {
      if (!s.hasPerk(p)) return false;
    }
    return true;
  }).toList();
  r.sort(f.topRated ? (a, b) => b.rating.compareTo(a.rating) : (a, b) => a.price.compareTo(b.price));
  return r;
}

class SearchScreen extends StatefulWidget {
  final String q;
  final bool filters;
  const SearchScreen({super.key, this.q = '', this.filters = false});
  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  late final TextEditingController c = TextEditingController(text: widget.q);
  Filt f = Filt();

  @override
  void initState() {
    super.initState();
    if (widget.filters) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    final r = await showSheet<Filt>(context, FilterSheet(initial: f, q: c.text));
    if (r != null) setState(() => f = r);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    final res = runSearch(c.text, f);
    void perk(String x) => setState(() => f.perks.contains(x) ? f.perks.remove(x) : f.perks.add(x));
    return ScreenBox(
        bottom: res.isEmpty ? null : Btn('Map view', () => context.push('/map')),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const BackBtn(), gapW(10), Expanded(child: SearchField(hint: 'Search', ctrl: c, onChanged: (_) => setState(() {})))]),
          gap(14),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            AppChip('Filters', on: f.active, onTap: _open),
            gapW(8),
            AppChip('Under Rs 2,000', on: f.price.end <= 2000, onTap: () => setState(() => f.price = f.price.end <= 2000 ? const RangeValues(1000, 20000) : const RangeValues(1000, 2000))),
            gapW(8),
            AppChip('Meals included', on: f.perks.contains('Meals included'), onTap: () => perk('Meals included')),
            gapW(8),
            AppChip('Family friendly', on: f.perks.contains('Family friendly'), onTap: () => perk('Family friendly')),
          ])),
          gap(16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Txt('${res.length} stays in Islamabad', w: kB),
            GestureDetector(onTap: () => setState(() => f.topRated = !f.topRated), child: Txt(f.topRated ? 'Top rated' : 'Lowest price', size: 13, color: p.tealText, w: kB)),
          ]),
          gap(12),
          if (res.isEmpty)
            Padding(padding: const EdgeInsets.only(top: 40), child: EmptyState(Icons.search, 'No stays found', 'Try a different area or remove some filters.', 'Clear filters', () => setState(() { f = Filt(); c.clear(); })))
          else
            for (final s in res) Padding(padding: const EdgeInsets.only(bottom: 12), child: StayRow(s)),
        ]));
  }
}

class FilterSheet extends StatefulWidget {
  final Filt initial;
  final String q;
  const FilterSheet({super.key, required this.initial, required this.q});
  @override
  State<FilterSheet> createState() => _FilterState();
}

class _FilterState extends State<FilterSheet> {
  late Filt f = widget.initial.copy();
  Widget _h(String t) => Padding(padding: const EdgeInsets.only(top: 18, bottom: 10), child: Txt(t, size: 15, w: kXB));
  @override
  Widget build(BuildContext context) {
    final n = runSearch(widget.q, f).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Txt('Filters', size: 20, w: kXB), LinkBtn('Reset', () => setState(() => f = Filt()))]),
      _h('Stay type'),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final t in StayType.values)
          AppChip(t.label, on: f.types.contains(t), onTap: () => setState(() => f.types.contains(t) ? f.types.remove(t) : f.types.add(t))),
      ]),
      _h('Price per night'),
      RangeSlider(values: f.price, min: 1000, max: 20000, divisions: 19, activeColor: kTeal, onChanged: (v) => setState(() => f.price = v)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Txt(rs(f.price.start.round()), size: 13, w: kB), Txt(rs(f.price.end.round()), size: 13, w: kB)]),
      _h('Perks'),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final x in ['Meals included', 'Wi-Fi', 'Study desk', 'CCTV', 'Family friendly'])
          AppChip(x, on: f.perks.contains(x), onTap: () => setState(() => f.perks.contains(x) ? f.perks.remove(x) : f.perks.add(x))),
      ]),
      _h('Minimum rating'),
      Wrap(spacing: 8, children: [for (final r in [3.0, 4.0, 4.5]) AppChip('$r+', on: f.minRating == r, onTap: () => setState(() => f.minRating = f.minRating == r ? 0 : r))]),
      gap(22),
      Btn('Show $n stays', () => Navigator.of(context).pop(f)),
    ]);
  }
}

// ---------------- Map (illustrated) ----------------
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapState();
}

class _MapState extends State<MapScreen> {
  int sel = 0;
  static const pos = [(0.1, 0.2), (0.5, 0.28), (0.6, 0.5), (0.12, 0.55), (0.35, 0.4)];
  @override
  Widget build(BuildContext context) {
    final p = context.p;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final stays = kStays.take(5).toList();
    return Scaffold(
        body: Stack(children: [
      Positioned.fill(child: Container(color: dark ? const Color(0xFF16263A) : const Color(0xFFE0F2FE))),
      Positioned(left: 0, right: 0, top: 300, height: 14, child: Container(color: p.surface)),
      Positioned(left: 150, top: 0, bottom: 0, width: 14, child: Container(color: p.surface)),
      Positioned(left: 0, right: 0, top: 560, height: 10, child: Container(color: p.surface)),
      Positioned(left: 290, top: 0, bottom: 0, width: 10, child: Container(color: p.surface)),
      Positioned.fill(child: LayoutBuilder(builder: (c, box) => Stack(children: [
        for (var i = 0; i < stays.length; i++)
          Positioned(
              left: box.maxWidth * pos[i].$1,
              top: box.maxHeight * pos[i].$2,
              child: GestureDetector(
                  onTap: () => setState(() => sel = i),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: i == sel ? kTeal : p.surface, borderRadius: BorderRadius.circular(999), border: Border.all(color: i == sel ? kTeal : p.border)),
                      child: Text(rs(stays[i].price), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: i == sel ? Colors.white : p.text))))),
      ]))),
      SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [const BackBtn(), gapW(10), Expanded(child: Container(height: 44, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.border)), child: Row(children: [Icon(Icons.search, size: 18, color: p.grey), gapW(8), const Txt('Islamabad')]))), gapW(10), RoundIcon(Icons.tune, onTap: () => context.push('/search?filters=1'))]))),
      Positioned(left: 20, right: 20, bottom: 24, child: SafeArea(child: StayRow(stays[sel]))),
    ]));
  }
}

// ---------------- Details ----------------
class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  Widget _tile(BuildContext c, IconData i, String v, String l) => Expanded(
      child: Box(radius: 14, padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(i, size: 20, color: c.p.tealText),
        gap(6),
        Txt(v, size: 15, w: kXB),
        Txt(l, size: 11, color: c.p.grey),
      ])));

  @override
  Widget build(BuildContext context) {
    final s = stayById(id);
    final p = context.p;
    return Scaffold(
        bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(color: p.surface, border: Border(top: BorderSide(color: p.border))),
            child: SafeArea(top: false, child: Row(children: [
              Expanded(child: Price(s.price, big: true)),
              SizedBox(width: 170, child: Btn('Book now', () {
                AppState.i.startDraft(s);
                context.push('/rooms/${s.id}');
              })),
            ]))),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: p.surface,
              leading: const Padding(padding: EdgeInsets.all(8), child: BackBtn()),
              actions: [Padding(padding: const EdgeInsets.all(8), child: HeartBtn(s.id))],
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () => context.push('/gallery/${s.id}'),
                  child: Photo(s.tint, w: double.infinity, h: 280, r: 0, heroTag: 'stay-photo-${s.id}'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                  decoration: BoxDecoration(color: p.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Txt(tr(s.type.label).toUpperCase(), size: 11, w: kB, color: p.tealText),
                      GestureDetector(onTap: () => context.push('/reviews/${s.id}'), child: Rate(s.rating, n: s.reviewCount)),
                    ]),
                    gap(6),
                    Txt(s.name, size: 24, w: kXB),
                    gap(6),
                    Row(children: [Icon(Icons.place_outlined, size: 16, color: p.grey), gapW(6), Expanded(child: Txt(s.address, size: 13, color: p.grey))]),
                    gap(16),
                    Row(children: [_tile(context, Icons.restaurant, '${s.food}', 'Food rating'), gapW(10), _tile(context, Icons.shield_outlined, s.cctv ? 'CCTV' : 'Basic', 'Safety'), gapW(10), _tile(context, Icons.family_restroom, s.family ? 'Yes' : 'Solo', 'Family friendly')]),
                    if (s.offer != null) ...[
                      gap(14),
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.local_offer_outlined, size: 20, color: Color(0xFF92400E)), gapW(10), Expanded(child: Txt(s.offer!, size: 13, w: kB, color: const Color(0xFF92400E)))])),
                    ],
                    gap(16),
                    Txt(s.description, color: p.grey, height: 1.5),
                    gap(16),
                    const Txt('Amenities', size: 15, w: kXB),
                    gap(10),
                    Wrap(spacing: 8, runSpacing: 8, children: [for (final a in s.amenities) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: p.bg, borderRadius: BorderRadius.circular(999)), child: Txt(a, size: 12, w: kSB))]),
                    gap(16),
                    const Txt('Food and meals', size: 15, w: kXB),
                    gap(6),
                    Txt(s.foodInfo, size: 13, color: p.grey, height: 1.5),
                    gap(16),
                    const Txt('Perks', size: 15, w: kXB),
                    gap(6),
                    for (final x in s.perks) Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.check, size: 16, color: kTeal), gapW(8), Expanded(child: Txt(x, size: 13))])),
                    gap(16),
                    Btn('See all reviews', () => context.push('/reviews/${s.id}'), outline: true, h: 46),
                    gap(24),
                  ])),
            ),
          ],
        ));
  }
}

class GalleryScreen extends StatefulWidget {
  final String id;
  const GalleryScreen({super.key, required this.id});
  @override
  State<GalleryScreen> createState() => _GalleryState();
}

class _GalleryState extends State<GalleryScreen> {
  final pc = PageController();
  int k = 0;
  @override
  void dispose() {
    pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = stayById(widget.id);
    return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RoundIcon(Icons.close, tip: 'Close', onTap: () => Navigator.of(context).maybePop()),
            Text('${k + 1} / 8', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ])),
          Expanded(child: PageView.builder(controller: pc, itemCount: 8, onPageChanged: (v) => setState(() => k = v), itemBuilder: (_, i) => Center(child: Photo(s.tint + i, w: double.infinity, h: 400, r: 0)))),
          SizedBox(height: 100, child: ListView.separated(padding: const EdgeInsets.all(20), scrollDirection: Axis.horizontal, itemCount: 8, separatorBuilder: (_, _) => gapW(10), itemBuilder: (_, i) => GestureDetector(onTap: () => pc.animateToPage(i, duration: const Duration(milliseconds: 250), curve: Curves.easeOut), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: i == k ? Colors.white : Colors.transparent, width: 3)), child: Photo(s.tint + i, w: 60, h: 60, r: 11))))),
        ])));
  }
}

// ---------------- Reviews ----------------
class ReviewsScreen extends StatelessWidget {
  final String id;
  const ReviewsScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final s = stayById(id), p = context.p;
    Widget bar(int n, double w) => Row(children: [SizedBox(width: 14, child: Txt('$n', size: 12)), gapW(8), Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: w, minHeight: 6, backgroundColor: p.border, color: kAmber)))]);
    return ScreenBox(
        title: 'Reviews',
        bottom: Btn('Write a review', () => context.push('/write-review/${s.id}')),
        child: Column(children: [
          Box(child: Row(children: [
            Column(children: [Txt('${s.rating}', size: 40, w: kXB), Txt('${s.reviewCount} reviews', size: 12, color: p.grey)]),
            gapW(20),
            Expanded(child: Column(children: [bar(5, .55), gap(6), bar(4, .25), gap(6), bar(3, .12), gap(6), bar(2, .05), gap(6), bar(1, .03)])),
          ])),
          for (final r in sampleReviews)
            Padding(padding: const EdgeInsets.only(top: 12), child: Box(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 40, height: 40, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: p.tint), child: Text(r.name[0], style: TextStyle(fontWeight: FontWeight.w800, color: p.tealText))),
                gapW(10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Txt(r.name, w: kB), Txt(r.date, size: 12, color: p.grey)])),
                Rate(r.rating),
              ]),
              gap(10),
              Txt(r.text, size: 13, height: 1.5),
            ]))),
        ]));
  }
}

class WriteReviewScreen extends StatefulWidget {
  final String id;
  const WriteReviewScreen({super.key, required this.id});
  @override
  State<WriteReviewScreen> createState() => _WriteState();
}

class _WriteState extends State<WriteReviewScreen> {
  int rating = 4;
  final tags = <String>{'Clean', 'Good food'};
  final text = TextEditingController();
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = stayById(widget.id), p = context.p;
    return ScreenBox(
        title: 'Write a review',
        bottom: Btn('Submit review', () => context.go('/review-done')),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Box(child: Row(children: [Photo(s.tint, w: 48, h: 48, r: 12), gapW(12), Expanded(child: Txt(s.name, size: 15, w: kB))])),
          gap(20),
          const Txt('Your rating', size: 15, w: kXB),
          gap(10),
          Row(children: [for (var i = 1; i <= 5; i++) GestureDetector(onTap: () => setState(() => rating = i), child: Padding(padding: const EdgeInsets.only(right: 6), child: Icon(Icons.star, size: 36, color: i <= rating ? kAmber : p.border)))]),
          gap(20),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final t in ['Clean', 'Good food', 'Safe', 'Value for money']) AppChip(t, on: tags.contains(t), onTap: () => setState(() => tags.contains(t) ? tags.remove(t) : tags.add(t)))]),
          gap(8),
          Field(hint: 'Tell others about your stay', ctrl: text, lines: 5),
        ]));
  }
}

class ReviewDoneScreen extends StatelessWidget {
  const ReviewDoneScreen({super.key});
  @override
  Widget build(BuildContext context) => SuccessView(
      icon: Icons.check, color: kTeal, title: 'Thanks for your review', sub: 'Your feedback helps other travelers choose where to stay.',
      btn1: 'Back to my trips', on1: () {
        AppState.i.update(() => AppState.i.tab = 2);
        context.go('/home');
      });
}
