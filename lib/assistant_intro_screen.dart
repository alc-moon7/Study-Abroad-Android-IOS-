import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssistantIntroScreen extends StatefulWidget {
  const AssistantIntroScreen({super.key});

  @override
  State<AssistantIntroScreen> createState() => _AssistantIntroScreenState();
}

class _AssistantIntroScreenState extends State<AssistantIntroScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bubbleController;
  late final AnimationController _entryController;

  final List<_ChoiceChipData> _choices = const [
    _ChoiceChipData(label: 'USA', flag: '\u{1F1FA}\u{1F1F8}'),
    _ChoiceChipData(label: 'UK', flag: '\u{1F1EC}\u{1F1E7}'),
    _ChoiceChipData(label: 'Canada', flag: '\u{1F1E8}\u{1F1E6}'),
    _ChoiceChipData(label: 'Australia', flag: '\u{1F1E6}\u{1F1FA}'),
    _ChoiceChipData(label: 'Europe', flag: '\u{1F1EA}\u{1F1FA}'),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _runEntrance();
  }

  Future<void> _runEntrance() async {
    try {
      await _entryController.forward();
      if (!mounted) {
        return;
      }

      await _bubbleController.forward();
    } on TickerCanceled {
      // Animation was disposed while a sequence step was in flight.
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.92, -1.0),
              end: Alignment(1.0, 1.0),
              colors: [
                Color(0xFFFFCF22),
                Color(0xFFFF8100),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.05, -0.05),
                    radius: 1.08,
                    colors: [
                      Color(0x28FFFFFF),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  child: Container(
                    height: 176,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0x00FFFFFF),
                          const Color(0x4DE35A00).withOpacity(0.42),
                          const Color(0xB5451300).withOpacity(0.64),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;
                    final foxSize = math
                        .min(width * 0.63, height * 0.33)
                        .clamp(210.0, 300.0)
                        .toDouble();
                    final bubbleWidth =
                        (width * 0.46).clamp(182.0, 220.0).toDouble();
                    final stageHeight =
                        math.min(height * 0.42, 360.0).toDouble();
                    final sectionGap =
                        (height * 0.03).clamp(16.0, 24.0).toDouble();
                    final bottomGap =
                        (height * 0.022).clamp(10.0, 18.0).toDouble();

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.012),
                          _TopBar(
                            onBack: () => Navigator.of(context).maybePop(),
                          ),
                          SizedBox(height: height * 0.03),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: Listenable.merge([
                                _entryController,
                                _bubbleController,
                              ]),
                              builder: (context, child) {
                                final entry = Curves.easeOutCubic.transform(
                                  _entryController.value,
                                );
                                final bubble = Curves.easeOutBack.transform(
                                  _bubbleController.value,
                                );

                                return Opacity(
                                  opacity: entry,
                                  child: Transform.translate(
                                    offset:
                                        Offset(0, lerpDouble(24, 0, entry)!),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height * 0.02),
                                        SizedBox(
                                          height: stageHeight,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                left: 0,
                                                bottom: 0,
                                                child: _StaticFoxAvatar(
                                                  size: foxSize,
                                                ),
                                              ),
                                              Positioned(
                                                right: width * 0.005,
                                                top: 0,
                                                child: Transform.translate(
                                                  offset: Offset(
                                                    lerpDouble(10, 0, bubble)!,
                                                    lerpDouble(18, 0, bubble)!,
                                                  ),
                                                  child: Transform.scale(
                                                    scale: lerpDouble(
                                                      0.92,
                                                      1.0,
                                                      bubble,
                                                    )!,
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: _SpeechBubble(
                                                      width: bubbleWidth,
                                                      text:
                                                          "Hi, I'm your counselor kaka. An AI assistant. Which Country would you like study in?",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: sectionGap),
                                        Text(
                                          'POPULAR CHOICES',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: (width * 0.035)
                                                .clamp(13.0, 15.0)
                                                .toDouble(),
                                            letterSpacing: 0.9,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.018),
                                        Wrap(
                                          spacing: 14,
                                          runSpacing: 12,
                                          children: _choices
                                              .map(
                                                (choice) => _ChoiceChip(
                                                  label: choice.label,
                                                  flag: choice.flag,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        const Spacer(),
                                        const _InputDock(),
                                        SizedBox(height: bottomGap),
                                        const Center(
                                          child: _ProgressDots(),
                                        ),
                                        SizedBox(height: bottomGap * 0.5),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticFoxAvatar extends StatelessWidget {
  const _StaticFoxAvatar({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/fox_full_character.png',
      width: size * 0.9,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'NEW ASSISTANT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.65,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Skip'),
        ),
      ],
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({
    required this.width,
    required this.text,
  });

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textSize = (width * 0.080).clamp(14.2, 15.4).toDouble();
    final horizontalPadding = (width * 0.118).clamp(20.0, 26.0).toDouble();
    final minHeight = (width * 0.61).clamp(126.0, 152.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
            ),
            child: CustomPaint(
              painter: const _ThoughtBubblePainter(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  22,
                  horizontalPadding - 2,
                  26,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: const Color(0xFF151515),
                    fontSize: textSize,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 18,
          bottom: -2,
          child: _ThoughtCircle(size: 46),
        ),
        const Positioned(
          left: -6,
          bottom: -22,
          child: _ThoughtCircle(size: 26),
        ),
        const Positioned(
          left: -24,
          bottom: -38,
          child: _ThoughtCircle(size: 15),
        ),
      ],
    );
  }
}

class _ThoughtCircle extends StatelessWidget {
  const _ThoughtCircle({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final strokeWidth = (size * 0.12).clamp(2.4, 5.2).toDouble();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF101010),
          width: strokeWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

class _ThoughtBubblePainter extends CustomPainter {
  const _ThoughtBubblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Path bubblePath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.12, size.height * 0.53),
          width: size.width * 0.24,
          height: size.height * 0.36,
        ),
      );

    final lobes = <Rect>[
      Rect.fromCenter(
        center: Offset(size.width * 0.28, size.height * 0.27),
        width: size.width * 0.34,
        height: size.height * 0.28,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.17),
        width: size.width * 0.40,
        height: size.height * 0.30,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.24),
        width: size.width * 0.34,
        height: size.height * 0.27,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.90, size.height * 0.48),
        width: size.width * 0.26,
        height: size.height * 0.38,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.80, size.height * 0.72),
        width: size.width * 0.34,
        height: size.height * 0.29,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.80),
        width: size.width * 0.38,
        height: size.height * 0.31,
      ),
      Rect.fromCenter(
        center: Offset(size.width * 0.29, size.height * 0.72),
        width: size.width * 0.32,
        height: size.height * 0.27,
      ),
    ];

    for (final rect in lobes) {
      bubblePath = Path.combine(
        PathOperation.union,
        bubblePath,
        Path()..addOval(rect),
      );
    }

    canvas.drawShadow(
      bubblePath,
      Colors.black.withOpacity(0.18),
      16,
      false,
    );

    final fillPaint = Paint()..color = Colors.white;
    final strokePaint = Paint()
      ..color = const Color(0xFF101010)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.shortestSide * 0.040).clamp(5.0, 8.0)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(bubblePath, fillPaint);
    canvas.drawPath(bubblePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.flag,
  });

  final String label;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF363636),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                flag,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputDock extends StatelessWidget {
  const _InputDock();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0EA),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: Color(0xFF5B5044),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Type your answer....',
                  style: TextStyle(
                    color: Color(0xFF8C8177),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EDEA),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Color(0xFF8F8376),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 8),
        _buildDot(),
        const SizedBox(width: 8),
        _buildDot(),
        const SizedBox(width: 8),
        _buildDot(opacity: 0.45),
      ],
    );
  }

  Widget _buildDot({double opacity = 0.75}) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ChoiceChipData {
  const _ChoiceChipData({
    required this.label,
    required this.flag,
  });

  final String label;
  final String flag;
}
