import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

void confirmLogout(BuildContext c) {
  showSheet<void>(c, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Txt('Log out of BookMe?', size: 20, w: kXB),
    gap(6),
    Txt('Your trips and saved stays stay safe. You can log back in any time.', color: c.p.grey, height: 1.5),
    gap(18),
    Btn('Log out', () {
      Navigator.of(c).pop();
      AppState.i.update(() {
        AppState.i.loggedIn = false;
        AppState.i.tab = 0;
      });
      c.go('/login');
    }, color: kRed),
    gap(10),
    Btn('Stay logged in', () => Navigator.of(c).pop(), outline: true),
  ]));
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditState();
}

class _EditState extends State<EditProfileScreen> {
  final s = AppState.i;
  late final name = TextEditingController(text: s.name), email = TextEditingController(text: s.email), phone = TextEditingController(text: s.phone);
  late String role = s.role;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Edit profile',
      bottom: Btn('Save changes', () {
        final n = name.text.trim();
        final e = email.text.trim();
        final ph = phone.text.trim();

        if (n.isEmpty) {
          snack(context, 'Name cannot be empty');
          return;
        }
        if (e.isEmpty || !e.contains('@')) {
          snack(context, 'Please enter a valid email address');
          return;
        }
        if (ph.isNotEmpty && ph.length < 7) {
          snack(context, 'Please enter a valid phone number');
          return;
        }

        s.update(() {
          s.name = n;
          s.email = e;
          s.phone = ph;
          s.role = role;
        });
        Navigator.of(context).maybePop();
        snack(context, 'Profile updated successfully');
      }),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Column(children: [
          Container(width: 84, height: 84, alignment: Alignment.center, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal), child: const Icon(Icons.person, color: Colors.white, size: 40)),
          LinkBtn('Change photo', () => snack(context, 'Photo picker (demo)')),
        ])),
        Field(label: 'Full name', hint: 'Your name', ctrl: name),
        Field(label: 'Email', hint: 'you@email.com', ctrl: email, type: TextInputType.emailAddress),
        Field(label: 'Phone', hint: '03XX XXXXXXX', ctrl: phone, type: TextInputType.phone),
        gap(16),
        const Txt('I am a', size: 13, w: kB),
        gap(8),
        Wrap(spacing: 8, children: [for (final r in ['Student', 'Job seeker', 'Traveler']) AppChip(r, on: role == r, onTap: () => setState(() => role = r))]),
      ]));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: AppState.i,
      builder: (c, _) {
        final s = AppState.i, p = c.p;
        Widget sw(bool v, ValueChanged<bool> f) => Switch(value: v, activeTrackColor: kTeal, onChanged: f);
        return ScreenBox(
            title: 'Settings',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SectionHeader('Language'),
              Wrap(spacing: 8, children: [
                AppChip('English', on: !s.urdu, onTap: () => s.update(() => s.urdu = false)),
                AppChip('اردو', on: s.urdu, onTap: () => s.update(() => s.urdu = true)),
              ]),
              gap(16),
              SRow('Dark mode', trailing: sw(s.theme == ThemeMode.dark, (v) => s.update(() => s.theme = v ? ThemeMode.dark : ThemeMode.light))),
              SRow('Push notifications', trailing: sw(s.push, (v) => s.update(() => s.push = v))),
              SRow('Email offers', trailing: sw(s.emailOffers, (v) => s.update(() => s.emailOffers = v))),
              SRow('Terms of service', trailing: chevron(c), onTap: () => c.push('/terms')),
              SRow('Privacy policy', trailing: chevron(c), onTap: () => c.push('/privacy')),
              SRow('Check connection', trailing: chevron(c), onTap: () => c.push('/offline')),
              SRow('App version', trailing: Txt('1.0.0', color: p.grey)),
            ]));
      });
}

class DocScreen extends StatelessWidget {
  final String title;
  final List<(String, String)> items;
  const DocScreen({super.key, required this.title, required this.items});
  @override
  Widget build(BuildContext context) => ScreenBox(
      title: title,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Txt('Last updated 1 October 2026', size: 12, color: context.p.grey),
        for (final i in items) ...[gap(20), Txt(i.$1, size: 15, w: kXB), gap(6), Txt(i.$2, size: 13, color: context.p.grey, height: 1.6)],
      ]));
}

const termsItems = [
  ('1. Using BookMe', 'BookMe helps you find and book hotels, hostels and guest houses. You must give accurate details when you sign up.'),
  ('2. Bookings and payments', 'A booking is confirmed when you receive a booking ID. Payment is made as shown at checkout, including pay at arrival.'),
  ('3. Cancellations', 'You can cancel free of charge up to 24 hours before check-in. Later cancellations follow the stay\'s own policy.'),
  ('4. Reviews', 'Reviews must reflect your own stay. We may remove reviews that are abusive or false.'),
  ('5. Your account', 'Keep your password private. Tell us right away if you think someone else has used your account.'),
];
const privacyItems = [
  ('Information we collect', 'Your name, email, phone number, booking details and the reviews you write.'),
  ('How we use it', 'To confirm bookings, send trip updates and show offers that match your account type.'),
  ('Sharing', 'We share booking details only with the stay you book. We do not sell your personal data.'),
  ('Your choices', 'You can edit your details, turn off notifications or delete your account in Settings.'),
  ('Contact us', 'Reach our team any time from Help and support.'),
];

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  static const faq = [
    ('How do I cancel a booking?', 'Open My trips, choose your booking and tap Cancel booking. It is free up to 24 hours before check-in.'),
    ('Is paying at arrival safe?', 'Yes. You pay the stay directly at the front desk and receive a receipt.'),
    ('How do student discounts work?', 'Stays that offer a student discount apply it automatically in your price details.'),
    ('I did not receive my booking ID', 'Check My trips. Every confirmed booking is listed there with its ID.'),
    ('How do I change my dates?', 'Open the booking in My trips and tap Change dates.'),
  ];
  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Help and support',
      child: Column(children: [
        for (final f in faq)
          Theme(
              data: Theme.of(context).copyWith(dividerColor: context.p.border),
              child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 12),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Txt(f.$1, w: kSB),
                  children: [Txt(f.$2, size: 13, color: context.p.grey, height: 1.5)])),
        gap(20),
        Box(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Txt('Still need help?', size: 15, w: kXB),
          gap(4),
          Txt('Our team replies within a few hours.', size: 13, color: context.p.grey),
          gap(12),
          Btn('Chat with us', () => context.push('/chat')),
        ])),
      ]));
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  final msgs = <(String, bool)>[('Assalam o Alaikum! How can we help?', false)];
  final c = TextEditingController();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  void _send() {
    final t = c.text.trim();
    if (t.isEmpty) return;
    setState(() => msgs.add((t, true)));
    c.clear();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => msgs.add(('Thanks! Our team will get back to you shortly. You can also check Help and support for quick answers.', false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return ScreenBox(
        title: 'Support',
        trailing: Txt('Online', size: 12, w: kB, color: p.tealText),
        scroll: false,
        bottom: Row(children: [
          Expanded(child: Field(hint: 'Type a message', ctrl: c).paddingZero()),
          gapW(10),
          GestureDetector(onTap: _send, child: Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal), child: const Icon(Icons.send, color: Colors.white, size: 20))),
        ]),
        child: ListView(children: [
          for (final m in msgs)
            Align(
                alignment: m.$2 ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    constraints: const BoxConstraints(maxWidth: 270),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: m.$2 ? kTeal : p.surface, borderRadius: BorderRadius.circular(18), border: m.$2 ? null : Border.all(color: p.border)),
                    child: Text(m.$1, style: TextStyle(fontSize: 14, height: 1.5, color: m.$2 ? Colors.white : p.text)))),
        ]));
  }
}

extension on Widget {
  Widget paddingZero() => Transform.translate(offset: const Offset(0, -14), child: this);
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  static const items = [
    (Icons.check_circle_outline, 'Booking confirmed', 'Student Nest Hostel, 18 - 21 Oct', '2h', true),
    (Icons.local_offer_outlined, 'New offer', '15% off near NUST this week', '1d', true),
    (Icons.star_border, 'How was your stay?', 'Rate Green Valley Guest House', '3d', false),
    (Icons.notifications_none, 'Price drop', 'Backpackers Base is now Rs 1,300', '5d', false),
  ];
  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Notifications',
      child: Column(children: [
        for (final n in items)
          RowTile(n.$1, n.$2, sub: n.$3, trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Txt(n.$4, size: 11, color: context.p.grey),
            if (n.$5) Container(margin: const EdgeInsets.only(top: 6), width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: kTeal)),
          ])),
      ]));
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(child: Stack(children: [
        Padding(padding: const EdgeInsets.all(20), child: Align(alignment: AlignmentDirectional.topStart, child: const BackBtn())),
        EmptyState(Icons.wifi_off, 'No internet connection', 'Check your connection and try again.', 'Retry', () => snack(context, 'Still offline (demo)')),
      ])));
}
