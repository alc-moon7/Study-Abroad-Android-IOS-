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
  late final TextEditingController _answerController;
  late final FocusNode _answerFocusNode;

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
    _answerController = TextEditingController();
    _answerFocusNode = FocusNode();
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
    _answerController.dispose();
    _answerFocusNode.dispose();
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
        resizeToAvoidBottomInset: false,
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
                    final keyboardInset =
                        MediaQuery.viewInsetsOf(context).bottom;
                    final keyboardVisible = keyboardInset > 0;
                    const transitionDuration = Duration(milliseconds: 320);
                    final foxSize = math
                        .min(width * 0.63, height * 0.33)
                        .clamp(210.0, 300.0)
                        .toDouble();
                    final bubbleWidth =
                        (width * 0.56).clamp(220.0, 248.0).toDouble();
                    final stageHeight =
                        math.min(height * 0.36, 300.0).toDouble();
                    final sectionGap =
                        (height * 0.03).clamp(16.0, 24.0).toDouble();
                    final bottomGap =
                        (height * 0.022).clamp(10.0, 18.0).toDouble();
                    final topBarTop = height * 0.012;
                    const topBarHeight = 44.0;
                    final stageTop = topBarTop + topBarHeight + height * 0.055;
                    final panelTopClosed = stageTop + stageHeight + sectionGap;
                    final panelBottomClosed = bottomGap + 34.0;
                    final panelHeightClosed = math.max(
                        150.0, height - panelTopClosed - panelBottomClosed);
                    final panelTopOpen = topBarTop + topBarHeight + 10.0;
                    final panelHeightOpen = math.max(
                      panelHeightClosed,
                      height - panelTopOpen - keyboardInset - 12.0,
                    );
                    final panelTop =
                        keyboardVisible ? panelTopOpen : panelTopClosed;
                    final panelHeight =
                        keyboardVisible ? panelHeightOpen : panelHeightClosed;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                              offset: Offset(0, lerpDouble(24, 0, entry)!),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: topBarTop,
                                    left: 0,
                                    right: 0,
                                    child: _TopBar(
                                      onBack: () =>
                                          Navigator.of(context).maybePop(),
                                    ),
                                  ),
                                  Positioned(
                                    top: stageTop,
                                    left: 0,
                                    right: 0,
                                    height: stageHeight,
                                    child: _AssistantStage(
                                      foxSize: foxSize,
                                      bubbleWidth: bubbleWidth,
                                      bubbleAnimationValue: bubble,
                                      compact: false,
                                      text:
                                          "\n                  Hi...!\n   Which Country would\n     you like to study in?",
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: transitionDuration,
                                    curve: Curves.easeOutCubic,
                                    top: panelTop,
                                    left: 0,
                                    right: 0,
                                    height: panelHeight,
                                    child: _PopularChoicesPanel(
                                      choices: _choices,
                                      height: panelHeight,
                                      keyboardVisible: keyboardVisible,
                                      controller: _answerController,
                                      focusNode: _answerFocusNode,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: transitionDuration,
                                    curve: Curves.easeOutCubic,
                                    left: 0,
                                    right: 0,
                                    bottom:
                                        keyboardVisible ? -20 : bottomGap * 0.5,
                                    child: IgnorePointer(
                                      ignoring: keyboardVisible,
                                      child: AnimatedOpacity(
                                        duration: transitionDuration,
                                        opacity: keyboardVisible ? 0 : 1,
                                        child: const Center(
                                          child: _ProgressDots(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

class _AssistantStage extends StatelessWidget {
  const _AssistantStage({
    required this.foxSize,
    required this.bubbleWidth,
    required this.bubbleAnimationValue,
    required this.compact,
    required this.text,
  });

  final double foxSize;
  final double bubbleWidth;
  final double bubbleAnimationValue;
  final bool compact;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: compact ? -16 : -43,
          bottom: compact ? -12 : -26,
          child: _StaticFoxAvatar(
            size: foxSize,
          ),
        ),
        Positioned(
          right: compact ? 0 : 5,
          top: compact ? 0 : -10,
          child: Transform.translate(
            offset: Offset(
              lerpDouble(18, 0, bubbleAnimationValue)!,
              lerpDouble(16, 0, bubbleAnimationValue)!,
            ),
            child: Transform.scale(
              scale: lerpDouble(
                0.95,
                1.0,
                bubbleAnimationValue,
              )!,
              alignment: Alignment.bottomLeft,
              child: _SpeechBubble(
                width: bubbleWidth,
                text: text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularChoicesPanel extends StatelessWidget {
  const _PopularChoicesPanel({
    required this.choices,
    required this.height,
    required this.keyboardVisible,
    required this.controller,
    required this.focusNode,
  });

  final List<_ChoiceChipData> choices;
  final double height;
  final bool keyboardVisible;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: keyboardVisible ? 12.8 : 14.2,
      letterSpacing: 0.9,
    );
    final cardRadius = BorderRadius.circular(30);
    const cardPadding = EdgeInsets.fromLTRB(18, 16, 18, 14);

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: cardRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: keyboardVisible ? 18 : 0,
            sigmaY: keyboardVisible ? 18 : 0,
          ),
          child: Container(
            padding: cardPadding,
            decoration: BoxDecoration(
              color: keyboardVisible
                  ? Colors.white.withOpacity(0.14)
                  : Colors.transparent,
              borderRadius: cardRadius,
              border: Border.all(
                color: keyboardVisible
                    ? Colors.white.withOpacity(0.18)
                    : Colors.transparent,
              ),
              boxShadow: keyboardVisible
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedPadding(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.only(top: keyboardVisible ? 0 : 6),
                  child: Text(
                    'POPULAR CHOICES',
                    style: titleStyle,
                  ),
                ),
                SizedBox(height: keyboardVisible ? 8 : 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      children: choices
                          .map(
                            (choice) => _ChoiceChip(
                              label: choice.label,
                              flag: choice.flag,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _InputDock(
                  controller: controller,
                  focusNode: focusNode,
                ),
              ],
            ),
          ),
        ),
      ),
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
    const bubbleAspectRatio = 959 / 662;
    final bubbleHeight = width / bubbleAspectRatio;

    final maxTextSize = (width * 0.068).clamp(14.0, 17.0).toDouble();
    final minTextSize = (width * 0.054).clamp(10.0, 12.0).toDouble();

    final leftPadding = (width * 0.08).clamp(10.0, 18.0).toDouble();
    final rightPadding = (width * 0.035).clamp(4.0, 10.0).toDouble();

    final topPadding = (bubbleHeight * 0.060).clamp(8.0, 14.0).toDouble();
    final bottomPadding = (bubbleHeight * 0.075).clamp(8.0, 14.0).toDouble();

    return SizedBox(
      width: width,
      height: bubbleHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/ui/cloud_comic_filled.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                leftPadding,
                topPadding,
                rightPadding,
                bottomPadding,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textStyle = _resolveBubbleTextStyle(
                    context,
                    text,
                    constraints,
                    maxFontSize: maxTextSize,
                    minFontSize: minTextSize,
                  );

                  return Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      text,
                      maxLines: 12,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.left,
                      style: textStyle,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _resolveBubbleTextStyle(
    BuildContext context,
    String text,
    BoxConstraints constraints, {
    required double maxFontSize,
    required double minFontSize,
  }) {
    const color = Color(0xFF151515);
    const fontWeight = FontWeight.w500;
    const lineHeight = 1.24;
    final direction = Directionality.of(context);

    for (double size = maxFontSize; size >= minFontSize; size -= 0.2) {
      final style = TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        height: lineHeight,
      );

      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: TextAlign.left,
        textDirection: direction,
        maxLines: 12,
      )..layout(maxWidth: constraints.maxWidth);

      if (!painter.didExceedMaxLines &&
          painter.height <= constraints.maxHeight + 0.5) {
        return style;
      }
    }

    return TextStyle(
      color: color,
      fontSize: minFontSize,
      fontWeight: fontWeight,
      height: lineHeight,
    );
  }
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
  const _InputDock({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    const minHeight = 68.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: const Color(0xFF8F8376),
                  style: const TextStyle(
                    color: Color(0xFF5B5044),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Type your answer....',
                    hintStyle: TextStyle(
                      color: Color(0xFF8C8177),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
