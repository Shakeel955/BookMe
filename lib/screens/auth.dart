import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: kTeal,
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: const Icon(Icons.bed_outlined, size: 44, color: kTeal)),
        gap(16),
        const Txt('BookMe', size: 34, w: kXB, color: Colors.white),
        gap(8),
        const Txt('Stay smart. Travel easy.', color: Colors.white),
      ])));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnbState();
}

class _OnbState extends State<OnboardingScreen> {
  final pc = PageController();
  int k = 0;
  static const pages = [
    ('Know where you\'ll stay before you travel.', 'Compare hostels, hotels and guest houses by price, food and perks. Book from your phone and arrive stress-free.',
        [(Icons.bed_outlined, 'Student Nest Hostel', 'Rs 1,500 /night'), (Icons.restaurant, 'Food rated 4.4', 'Breakfast included'), (Icons.local_offer_outlined, '10% off with student ID', '')]),
    ('Compare before you book', 'See price, food quality, safety and perks for every stay side by side.',
        [(Icons.local_offer_outlined, 'Compare prices', 'Hostels from Rs 1,300'), (Icons.restaurant, 'Check the food', 'Ratings and meal info'), (Icons.shield_outlined, 'See safety info', 'CCTV and family friendly')]),
    ('Book in a few taps', 'Pick your dates, choose how to pay and get your booking ID instantly.',
        [(Icons.calendar_today_outlined, 'Pick your dates', '18 - 21 Oct'), (Icons.credit_card, 'Choose how to pay', 'Cash at arrival or JazzCash'), (Icons.check_circle_outline, 'Booking confirmed', 'Show your ID at the desk')]),
  ];

  @override
  void dispose() {
    pc.dispose();
    super.dispose();
  }

  Widget _float(BuildContext c, (IconData, String, String) d) => Box(
      padding: const EdgeInsets.all(12),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(d.$1, size: 22, color: c.p.tealText),
        gapW(10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Txt(d.$2, size: 13, w: kB),
          if (d.$3.isNotEmpty) Txt(d.$3, size: 12, color: c.p.grey),
        ]),
      ]));

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Logo(), LinkBtn('Skip', () => context.go('/login'), color: p.grey)]),
                  Expanded(
                      child: PageView(
                          controller: pc,
                          onPageChanged: (v) => setState(() => k = v),
                          children: [
                        for (final pg in pages)
                          SingleChildScrollView(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            gap(8),
                            Container(
                                height: 330,
                                decoration: BoxDecoration(color: p.tint, borderRadius: BorderRadius.circular(32)),
                                child: Stack(children: [
                                  Positioned(left: 18, top: 26, child: _float(context, pg.$3[0])),
                                  Positioned(right: 18, top: 140, child: _float(context, pg.$3[1])),
                                  Positioned(left: 34, bottom: 26, child: _float(context, pg.$3[2])),
                                ])),
                            gap(26),
                            Txt(pg.$1, size: 30, w: kXB, height: 1.15),
                            gap(12),
                            Txt(pg.$2, size: 15, color: p.grey, height: 1.5),
                          ])),
                      ])),
                  Row(children: [
                    for (var j = 0; j < 3; j++)
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsetsDirectional.only(end: 6),
                          width: j == k ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(color: j == k ? kTeal : p.border, borderRadius: BorderRadius.circular(4))),
                  ]),
                  gap(18),
                  Btn(k == 2 ? 'Get started' : 'Next', () {
                    if (k < 2) {
                      pc.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                    } else {
                      context.go('/login');
                    }
                  }),
                ]))));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void login() {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      snack(context, 'Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      snack(context, 'Password must be at least 6 characters');
      return;
    }

    setState(() => loading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => loading = false);
      AppState.i.update(() {
        AppState.i.loggedIn = true;
        AppState.i.email = email;
      });
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Logo(),
                  gap(40),
                  const Txt('Welcome back', size: 28, w: kXB),
                  gap(6),
                  Txt('Log in to see your trips and saved stays.', color: p.grey, height: 1.5),
                  Field(label: 'Email', hint: 'you@email.com', ctrl: emailCtrl, type: TextInputType.emailAddress),
                  Field(label: 'Password', hint: 'Enter password', ctrl: passwordCtrl, obscure: true),
                  Align(alignment: AlignmentDirectional.centerEnd, child: LinkBtn('Forgot password?', () => context.push('/forgot'))),
                  gap(6),
                  loading ? const Center(child: CircularProgressIndicator()) : Btn('Log in', login),
                  gap(20),
                  Row(children: [Expanded(child: Divider(color: p.border)), Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Txt('or', size: 12, color: p.grey)), Expanded(child: Divider(color: p.border))]),
                  gap(20),
                  Btn('Continue with Google', login, outline: true),
                  gap(24),
                  Center(child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [Txt('New to BookMe?', color: p.grey), LinkBtn('Create account', () => context.push('/signup'))])),
                ]))));
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  final name = TextEditingController(), email = TextEditingController(), phone = TextEditingController(), password = TextEditingController();
  String role = 'Student';
  bool loading = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    final n = name.text.trim();
    final e = email.text.trim();
    final ph = phone.text.trim();
    final pwd = password.text.trim();

    if (n.isEmpty) {
      snack(context, 'Please enter your full name');
      return;
    }
    if (e.isEmpty || !e.contains('@')) {
      snack(context, 'Please enter a valid email address');
      return;
    }
    if (ph.length < 7) {
      snack(context, 'Please enter a valid phone number');
      return;
    }
    if (pwd.length < 6) {
      snack(context, 'Password must be at least 6 characters');
      return;
    }

    setState(() => loading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => loading = false);
      AppState.i.update(() {
        AppState.i.name = n;
        AppState.i.email = e;
        AppState.i.phone = ph;
        AppState.i.role = role;
      });
      context.push('/otp?next=/home');
    });
  }

  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Create account',
      bottom: loading ? const Center(child: CircularProgressIndicator()) : Btn('Create account', submit),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Txt('Takes a minute. No payment needed to sign up.', color: context.p.grey),
        Field(label: 'Full name', hint: 'Your name', ctrl: name),
        Field(label: 'Email', hint: 'you@email.com', ctrl: email, type: TextInputType.emailAddress),
        Field(label: 'Phone', hint: '03XX XXXXXXX', ctrl: phone, type: TextInputType.phone),
        Field(label: 'Password', hint: 'At least 6 characters', ctrl: password, obscure: true),
        gap(16),
        const Txt('I am a', size: 13, w: kB),
        gap(8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final r in ['Student', 'Job seeker', 'Traveler']) AppChip(r, on: role == r, onTap: () => setState(() => role = r)),
        ]),
        gap(12),
        Txt('By continuing you agree to the Terms and Privacy Policy.', size: 12, color: context.p.grey),
      ]));
}

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});
  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Forgot password?',
      bottom: Btn('Send reset code', () => context.push('/otp?next=/newpass')),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Txt('Enter your email and we will send you a reset code.', color: context.p.grey, height: 1.5),
        const Field(label: 'Email', hint: 'you@email.com', type: TextInputType.emailAddress),
      ]));
}

class OtpScreen extends StatefulWidget {
  final String next;
  const OtpScreen({super.key, required this.next});
  @override
  State<OtpScreen> createState() => _OtpState();
}

class _OtpState extends State<OtpScreen> {
  final fs = List.generate(4, (_) => FocusNode());
  final cs = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (final f in fs) {
      f.dispose();
    }
    for (final c in cs) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.p;
    return ScreenBox(
        title: 'Verify your phone',
        bottom: Btn('Verify', () {
          if (cs.any((c) => c.text.isEmpty)) {
            snack(context, 'Enter the 4-digit code');
            return;
          }
          if (widget.next == '/home') AppState.i.update(() => AppState.i.loggedIn = true);
          context.go(widget.next);
        }),
        child: Column(children: [
          Txt('Enter the 4-digit code sent to your phone.', color: p.grey, align: TextAlign.center),
          gap(28),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < 4; i++)
              Container(
                  width: 64,
                  height: 72,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                      controller: cs[i],
                      focusNode: fs[i],
                      autofocus: i == 0,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: p.text),
                      decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: p.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: p.border)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kTeal, width: 2))),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 3) fs[i + 1].requestFocus();
                        if (v.isEmpty && i > 0) fs[i - 1].requestFocus();
                      })),
          ]),
          gap(20),
          Txt('Resend code in 0:30', size: 13, color: p.grey),
        ]));
  }
}

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => ScreenBox(
      title: 'Set new password',
      bottom: Btn('Update password', () => context.go('/reset-done')),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Txt('Choose a password you have not used before.', color: context.p.grey),
        const Field(label: 'New password', hint: 'At least 8 characters', obscure: true),
        const Field(label: 'Confirm password', hint: 'Repeat password', obscure: true),
      ]));
}

class ResetDoneScreen extends StatelessWidget {
  const ResetDoneScreen({super.key});
  @override
  Widget build(BuildContext context) => SuccessView(
      icon: Icons.check, color: kTeal, title: 'Password updated',
      sub: 'You can now log in with your new password.', btn1: 'Log in', on1: () => context.go('/login'));
}
