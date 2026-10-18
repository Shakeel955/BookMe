import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_state.dart';
import 'models.dart';
import 'theme.dart';

const kSB = FontWeight.w600, kB = FontWeight.w700, kXB = FontWeight.w800;

Widget gap(double h) => SizedBox(height: h);
Widget gapW(double w) => SizedBox(width: w);

class Txt extends StatelessWidget {
  final String s;
  final double size;
  final FontWeight w;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final double? height;
  const Txt(this.s, {super.key, this.size = 14, this.w = FontWeight.w500, this.color, this.align, this.maxLines, this.height});

  @override
  Widget build(BuildContext context) => Text(tr(s),
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(fontSize: size, fontWeight: w, color: color ?? context.p.text, height: height));
}

const kSamplePhotos = [
  'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1505691938895-1758d7FEB511?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=800&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&auto=format&fit=crop',
];

class Photo extends StatelessWidget {
  final int i;
  final double? w, h;
  final double r;
  final String? heroTag;
  final String? customUrl;
  const Photo(this.i, {super.key, this.w, this.h, this.r = 16, this.heroTag, this.customUrl});

  @override
  Widget build(BuildContext context) {
    final url = customUrl ?? kSamplePhotos[i.abs() % kSamplePhotos.length];
    final fallbackBg = kTints[i.abs() % kTints.length];

    Widget content = Image.network(
      url,
      width: w,
      height: h,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(color: context.p.tint, borderRadius: BorderRadius.circular(r)),
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: context.p.tealText),
            ),
          ),
        );
      },
      errorBuilder: (ctx, err, stack) => Container(
        width: w,
        height: h,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: fallbackBg, borderRadius: BorderRadius.circular(r)),
        child: const Icon(Icons.bed_outlined, color: Colors.white, size: 30),
      ),
    );

    if (r > 0) {
      content = ClipRRect(borderRadius: BorderRadius.circular(r), child: content);
    }

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(tag: heroTag!, child: content);
    }

    return content;
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color, border;
  final double radius, bw;
  const Box({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.color, this.border, this.radius = 18, this.bw = 1});
  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color ?? context.p.surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: border ?? context.p.border, width: bw)),
      child: child);
}

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool outline;
  final Color? color;
  final double h;
  const Btn(this.label, this.onTap, {super.key, this.outline = false, this.color, this.h = 52});
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    final child = Text(tr(label), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700));
    return SizedBox(
        width: double.infinity,
        height: h,
        child: outline
            ? OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(foregroundColor: color ?? context.p.text, side: BorderSide(color: color ?? context.p.border), shape: shape),
                child: child)
            : ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(backgroundColor: color ?? kTeal, foregroundColor: Colors.white, elevation: 0, shape: shape),
                child: child));
  }
}

class LinkBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const LinkBtn(this.label, this.onTap, {super.key, this.color});
  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(minimumSize: const Size(44, 44), foregroundColor: color ?? context.p.tealText),
      child: Text(tr(label), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)));
}

class AppChip extends StatelessWidget {
  final String label;
  final bool on;
  final VoidCallback? onTap;
  const AppChip(this.label, {super.key, this.on = false, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: on ? kTeal : context.p.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: on ? kTeal : context.p.border)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(tr(label), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: on ? Colors.white : context.p.text))
          ])));
}

class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final String? tip;
  const RoundIcon(this.icon, {super.key, this.onTap, this.color, this.tip});
  @override
  Widget build(BuildContext context) => Semantics(
      button: true,
      label: tip,
      child: GestureDetector(
          onTap: onTap,
          child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.p.surface, border: Border.all(color: context.p.border)),
              child: Icon(icon, size: 20, color: color ?? context.p.text))));
}

class BackBtn extends StatelessWidget {
  const BackBtn({super.key});
  @override
  Widget build(BuildContext context) => RoundIcon(Icons.arrow_back, tip: 'Back', onTap: () => Navigator.of(context).maybePop());
}

class HeartBtn extends StatelessWidget {
  final String id;
  const HeartBtn(this.id, {super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final on = AppState.i.saved.contains(id);
        return AnimatedScale(
            scale: on ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: RoundIcon(on ? Icons.favorite : Icons.favorite_border, color: on ? kRed : null, tip: 'Save', onTap: () => AppState.i.toggleSaved(id)));
      });
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: kTeal, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.bed_outlined, color: Colors.white, size: 20)),
        gapW(10),
        const Txt('BookMe', size: 20, w: kXB),
      ]);
}

class ScreenBox extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? bottom, trailing;
  final bool scroll;
  const ScreenBox({super.key, this.title, required this.child, this.bottom, this.trailing, this.scroll = true});
  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      if (title != null)
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [const BackBtn(), gapW(12), Expanded(child: Txt(title!, size: 20, w: kXB)), ?trailing])),
      Expanded(
          child: scroll
              ? SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), child: child)
              : Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: child)),
      if (bottom != null)
        Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(color: p.bg, border: Border(top: BorderSide(color: p.border))),
            child: bottom),
    ])));
  }
}

class Field extends StatelessWidget {
  final String label, hint;
  final bool obscure;
  final TextEditingController? ctrl;
  final TextInputType? type;
  final int lines;
  const Field({super.key, this.label = '', required this.hint, this.obscure = false, this.ctrl, this.type, this.lines = 1});
  @override
  Widget build(BuildContext context) {
    final p = context.p;
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
    return Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (label.isNotEmpty) ...[Txt(label, size: 13, w: kB), gap(6)],
          TextField(
              controller: ctrl,
              obscureText: obscure,
              keyboardType: type,
              minLines: lines,
              maxLines: lines,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: p.text),
              decoration: InputDecoration(
                  hintText: tr(hint),
                  hintStyle: TextStyle(color: p.grey),
                  filled: true,
                  fillColor: p.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  border: b(p.border),
                  enabledBorder: b(p.border),
                  focusedBorder: b(kTeal, 2))),
        ]));
  }
}

class Rate extends StatelessWidget {
  final double v;
  final int? n;
  const Rate(this.v, {super.key, this.n});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star, size: 14, color: kAmber),
        gapW(4),
        Txt('$v', size: 12, w: kB),
        if (n != null) Txt(' ($n)', size: 12, color: context.p.grey),
      ]);
}

class Price extends StatelessWidget {
  final int v;
  final bool big;
  const Price(this.v, {super.key, this.big = false});
  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(
      text: rs(v),
      style: TextStyle(fontSize: big ? 22 : 15, fontWeight: FontWeight.w800, color: context.p.tealText),
      children: [TextSpan(text: ' /night', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: context.p.grey))]));
}

class StayRow extends StatelessWidget {
  final Stay s;
  const StayRow(this.s, {super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => context.push('/stay/${s.id}'),
      child: Box(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Photo(s.tint, w: 96, h: 104, r: 12, heroTag: 'stay-photo-${s.id}'),
            gapW(12),
            Expanded(
                child: SizedBox(
                    height: 104,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Txt(tr(s.type.label).toUpperCase(), size: 11, w: kB, color: context.p.tealText),
                      Txt(s.name, size: 14, w: kB, maxLines: 1),
                      gap(2),
                      Txt(s.nearby, size: 12, color: context.p.grey, maxLines: 1),
                      const Spacer(),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Flexible(child: Rate(s.rating, n: s.reviewCount)), Price(s.price)]),
                    ]))),
          ])));
}

class StayCard extends StatelessWidget {
  final Stay s;
  final double w;
  const StayCard(this.s, {super.key, this.w = 168});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: w,
      child: GestureDetector(
          onTap: () => context.push('/stay/${s.id}'),
          child: Box(
              padding: const EdgeInsets.all(8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  Photo(s.tint, w: double.infinity, h: 120, r: 12, heroTag: 'stay-photo-${s.id}'),
                  if (s.badge != null)
                    Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
                            child: Text(s.badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))))),
                ]),
                gap(10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Txt(tr(s.type.label).toUpperCase(), size: 11, w: kB, color: context.p.tealText),
                      Txt(s.name, size: 14, w: kB, maxLines: 1),
                      Txt('${s.area}, Islamabad', size: 12, color: context.p.grey, maxLines: 1),
                      gap(8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Rate(s.rating), Flexible(child: Txt(rs(s.price), size: 13, w: kXB, color: context.p.tealText, maxLines: 1, align: TextAlign.end))]),
                    ])),
              ]))));
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Txt(title, size: 17, w: kXB),
        if (action != null) GestureDetector(onTap: onAction, child: Txt(action!, size: 13, w: kB, color: context.p.tealText)),
      ]));
}

class RowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? sub;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;
  const RowTile(this.icon, this.title, {super.key, this.sub, this.trailing, this.onTap, this.color});
  @override
  Widget build(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.p.border))),
          child: Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: context.p.tint, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 20, color: color ?? context.p.tealText)),
            gapW(14),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Txt(title, size: 14, w: kB, color: color),
              if (sub case final s?) Padding(padding: const EdgeInsets.only(top: 2), child: Txt(s, size: 12, color: context.p.grey)),
            ])),
            ?trailing,
          ])));
}

class SRow extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const SRow(this.title, {super.key, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.p.border))),
          child: Row(children: [Expanded(child: Txt(title, w: kSB)), ?trailing])));
}

Widget chevron(BuildContext c) => Icon(Icons.chevron_right, size: 20, color: c.p.grey);

class KV extends StatelessWidget {
  final String k, v;
  final Color? color;
  const KV(this.k, this.v, {super.key, this.color});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Txt(k, color: color ?? context.p.grey), Txt(v, w: kB, color: color)]));
}

class RadioDot extends StatelessWidget {
  final bool on;
  const RadioDot(this.on, {super.key});
  @override
  Widget build(BuildContext context) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: on ? kTeal : context.p.border, width: 2)),
      child: on ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal))) : null);
}

class Skel extends StatelessWidget {
  final double? w;
  final double h, r;
  const Skel({super.key, this.w, required this.h, this.r = 12});
  @override
  Widget build(BuildContext context) => Container(width: w, height: h, decoration: BoxDecoration(color: context.p.border, borderRadius: BorderRadius.circular(r)));
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, sub, label;
  final VoidCallback onTap;
  const EmptyState(this.icon, this.title, this.sub, this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 96, height: 96, decoration: BoxDecoration(shape: BoxShape.circle, color: context.p.tint), child: Icon(icon, size: 40, color: context.p.tealText)),
            gap(20),
            Txt(title, size: 20, w: kXB, align: TextAlign.center),
            gap(6),
            Txt(sub, color: context.p.grey, align: TextAlign.center, height: 1.5),
            gap(20),
            SizedBox(width: 200, child: Btn(label, onTap)),
          ])));
}

class SuccessView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, sub, btn1;
  final VoidCallback on1;
  final String? btn2;
  final VoidCallback? on2;
  const SuccessView({super.key, required this.icon, required this.color, required this.title, required this.sub, required this.btn1, required this.on1, this.btn2, this.on2});
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                gap(40),
                Container(width: 84, height: 84, decoration: BoxDecoration(shape: BoxShape.circle, color: color), child: Icon(icon, size: 44, color: Colors.white)),
                gap(20),
                Txt(title, size: 26, w: kXB, align: TextAlign.center),
                gap(6),
                Txt(sub, color: context.p.grey, align: TextAlign.center, height: 1.5),
                const Spacer(),
                Btn(btn1, on1),
                if (btn2 != null) ...[gap(10), Btn(btn2!, on2, outline: true)],
              ]))));
}

Future<T?> showSheet<T>(BuildContext context, Widget child) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.p.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: ctx.p.border, borderRadius: BorderRadius.circular(3)))),
          gap(16),
          Flexible(child: SingleChildScrollView(child: child)),
        ])));

void snack(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));
