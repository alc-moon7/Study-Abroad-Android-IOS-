import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AssistantFlowAction = Future<void> Function(
  BuildContext context,
  String? answer,
);

PageRoute<void> buildAssistantFlowRoute(Widget child) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0.04, 0.0),
        end: Offset.zero,
      ).animate(fade);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
  );
}

class AssistantChoiceData {
  const AssistantChoiceData({
    required this.label,
    required this.trailing,
  });

  final String label;
  final String trailing;
}

class AssistantQuestionScreen extends StatefulWidget {
  const AssistantQuestionScreen({
    super.key,
    required this.questionText,
    required this.choices,
    required this.stepIndex,
    required this.totalSteps,
    this.onNext,
    this.onSkip,
  });

  final String questionText;
  final List<AssistantChoiceData> choices;
  final int stepIndex;
  final int totalSteps;
  final AssistantFlowAction? onNext;
  final AssistantFlowAction? onSkip;

  @override
  State<AssistantQuestionScreen> createState() =>
      _AssistantQuestionScreenState();
}

class _AssistantQuestionScreenState extends State<AssistantQuestionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bubbleController;
  late final AnimationController _entryController;
  late final TextEditingController _answerController;
  late final FocusNode _answerFocusNode;

  bool _isTransitioning = false;

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

  Future<void> _runFlowAction(
    AssistantFlowAction? action, {
    String? answer,
  }) async {
    if (action == null || _isTransitioning) {
      return;
    }

    setState(() {
      _isTransitioning = true;
    });

    try {
      await action(context, answer?.trim().isEmpty ?? true ? null : answer);
    } finally {
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
      }
    }
  }

  Future<void> _handleChoiceTap(AssistantChoiceData choice) async {
    _answerController
      ..text = choice.label
      ..selection = TextSelection.collapsed(offset: choice.label.length);
    FocusScope.of(context).unfocus();
    await _runFlowAction(
      widget.onNext,
      answer: choice.label,
    );
  }

  Future<void> _handleSubmitted([String? answer]) async {
    await _runFlowAction(
      widget.onNext,
      answer: answer ?? _answerController.text,
    );
  }

  Future<void> _handleSkip() async {
    FocusScope.of(context).unfocus();
    await _runFlowAction(
      widget.onSkip,
      answer: _answerController.text,
    );
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
                      150.0,
                      height - panelTopClosed - panelBottomClosed,
                    );
                    final panelTopOpen = topBarTop + topBarHeight + 10.0;
                    final panelHeightOpen = math.max(
                      panelHeightClosed,
                      height - panelTopOpen - keyboardInset - 12.0,
                    );
                    final panelTop =
                        keyboardVisible ? panelTopOpen : panelTopClosed;
                    final panelHeight =
                        keyboardVisible ? panelHeightOpen : panelHeightClosed;
                    final baseHorizontalPadding =
                        (width * 0.06).clamp(16.0, 24.0).toDouble();
                    final panelSideExpansion =
                        (width * 0.035).clamp(8.0, 16.0).toDouble();

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: baseHorizontalPadding,
                      ),
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
                                      isBusy: _isTransitioning,
                                      onBack: () =>
                                          Navigator.of(context).maybePop(),
                                      onSkip: _handleSkip,
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
                                      text: widget.questionText,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: transitionDuration,
                                    curve: Curves.easeOutCubic,
                                    top: panelTop,
                                    left: -panelSideExpansion,
                                    right: -panelSideExpansion,
                                    height: panelHeight,
                                    child: _PopularChoicesPanel(
                                      choices: widget.choices,
                                      height: panelHeight,
                                      keyboardVisible: keyboardVisible,
                                      controller: _answerController,
                                      focusNode: _answerFocusNode,
                                      onChoiceTap: _handleChoiceTap,
                                      onSubmitted: _handleSubmitted,
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
                                        child: Center(
                                          child: _ProgressDots(
                                            activeIndex: widget.stepIndex,
                                            totalSteps: widget.totalSteps,
                                          ),
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
  const _TopBar({
    required this.isBusy,
    required this.onBack,
    required this.onSkip,
  });

  final bool isBusy;
  final VoidCallback onBack;
  final Future<void> Function() onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isBusy ? null : onBack,
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
          onPressed: isBusy ? null : onSkip,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withOpacity(0.78),
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
    required this.text,
  });

  final double foxSize;
  final double bubbleWidth;
  final double bubbleAnimationValue;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -43,
          bottom: -26,
          child: _StaticFoxAvatar(
            size: foxSize,
          ),
        ),
        Positioned(
          right: 5,
          top: -10,
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
    required this.onChoiceTap,
    required this.onSubmitted,
  });

  final List<AssistantChoiceData> choices;
  final double height;
  final bool keyboardVisible;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<AssistantChoiceData> onChoiceTap;
  final ValueChanged<String> onSubmitted;

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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 12.0;
                      final chipWidth = ((constraints.maxWidth - spacing) / 2)
                          .clamp(126.0, 190.0)
                          .toDouble();

                      return Align(
                        alignment: Alignment.topCenter,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: spacing,
                          runSpacing: 12,
                          children: choices
                              .map(
                                (choice) => SizedBox(
                                  width: math.min(
                                    chipWidth,
                                    constraints.maxWidth,
                                  ),
                                  child: _ChoiceChip(
                                    label: choice.label,
                                    trailing: choice.trailing,
                                    expand: true,
                                    onTap: () => onChoiceTap(choice),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _InputDock(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: onSubmitted,
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
    required this.trailing,
    this.expand = false,
    required this.onTap,
  });

  final String label;
  final String trailing;
  final bool expand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: expand
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF363636),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                trailing,
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
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

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
                  textInputAction: TextInputAction.done,
                  onSubmitted: onSubmitted,
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSubmitted(controller.text),
                  borderRadius: BorderRadius.circular(19),
                  child: Ink(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7B24B),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
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
  const _ProgressDots({
    required this.activeIndex,
    required this.totalSteps,
  });

  final int activeIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          return const SizedBox(width: 8);
        }

        final step = index ~/ 2;
        if (step == activeIndex) {
          return Container(
            width: 24,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
