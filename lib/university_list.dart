import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  State<UniversityListScreen> createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _shortlistedIds = <String>{};

  static const List<_UniversityData> _universities = [
    _UniversityData(
      id: 'harvard',
      name: 'Harvard University',
      countryFlag: '\u{1F1FA}\u{1F1F8}',
      location: 'Cambridge, USA',
      rating: '4.8',
      reviews: '1,250 reviews',
      ranking: '#4 QS World Ranking',
      tuitionFee: '\$54,000',
      intake: 'Sep, Jan, May',
      logoKind: _UniversityLogoKind.harvard,
    ),
    _UniversityData(
      id: 'mit',
      name: 'MIT',
      countryFlag: '\u{1F1FA}\u{1F1F8}',
      location: 'Cambridge, USA',
      rating: '4.7',
      reviews: '980 reviews',
      ranking: '#1 QS World Ranking',
      tuitionFee: '\$55,878',
      intake: 'Sep, Feb',
      logoKind: _UniversityLogoKind.mit,
    ),
    _UniversityData(
      id: 'oxford',
      name: 'University of Oxford',
      countryFlag: '\u{1F1EC}\u{1F1E7}',
      location: 'Oxford, United Kingdom',
      rating: '4.6',
      reviews: '870 reviews',
      ranking: '#3 QS World Ranking',
      tuitionFee: '\u00A328,980',
      intake: 'Oct, Jan, Apr',
      logoKind: _UniversityLogoKind.oxford,
    ),
    _UniversityData(
      id: 'nus',
      name: 'National University of Singapore',
      countryFlag: '\u{1F1F8}\u{1F1EC}',
      location: 'Singapore',
      rating: '4.5',
      reviews: '760 reviews',
      ranking: '#8 QS World Ranking',
      tuitionFee: '\$17,550',
      intake: 'Aug, Jan',
      logoKind: _UniversityLogoKind.nus,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleShortlist(String id) {
    setState(() {
      if (_shortlistedIds.contains(id)) {
        _shortlistedIds.remove(id);
      } else {
        _shortlistedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.92, -1.0),
              end: Alignment(1.0, 1.0),
              colors: [
                Color(0xFFFFCB32),
                Color(0xFFFFAA1F),
                Color(0xFFFF9120),
              ],
              stops: [0.0, 0.68, 1.0],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _UniversityBackground(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 212,
                          child: Stack(
                            children: [
                              const _HeroSection(),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 20,
                                child: _SearchField(
                                  controller: _searchController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 204,
                        left: 0,
                        right: 0,
                        child: _FilterRow(),
                      ),
                      Positioned(
                        top: 264,
                        left: 0,
                        right: 0,
                        bottom: 108,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ..._universities.map(
                              (university) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _UniversityCard(
                                  data: university,
                                  shortlisted:
                                      _shortlistedIds.contains(university.id),
                                  onShortlistTap: () =>
                                      _toggleShortlist(university.id),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const _AdviceCard(),
                          ],
                        ),
                      ),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: _BottomBar(),
                      ),
                    ],
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

class _UniversityBackground extends StatelessWidget {
  const _UniversityBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -56,
            right: -86,
            child: Transform.rotate(
              angle: -0.34,
              child: Container(
                width: 430,
                height: 166,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(220),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.03),
                      Colors.white.withOpacity(0.16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: -20,
            child: Transform.rotate(
              angle: -0.32,
              child: Container(
                width: 306,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(220),
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
          ),
          Positioned(
            top: -72,
            left: -52,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x20FFFFFF),
                    Color(0x00FFFFFF),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final titleSize = (width * 0.094).clamp(25.5, 35.0).toDouble();
        final subtitleSize = (width * 0.043).clamp(12.6, 16.0).toDouble();

        return SizedBox(
          height: 164,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -8,
                bottom: -30,
                child: Image.asset(
                  'assets/icon/fox_search_header.png',
                  width: (width * 0.43).clamp(138.0, 178.0).toDouble(),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                left: 0,
                top: 10,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * 0.60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Universities',
                        style: TextStyle(
                          color: const Color(0xFF1E1A12),
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          height: 0.95,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '500+ trusted universities worldwide',
                        style: TextStyle(
                          color: const Color(0xFF4D3B16),
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: Color(0xFF303030),
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: const Color(0xFF8E8067),
              style: const TextStyle(
                color: Color(0xFF37332E),
                fontSize: 14.4,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search university, course or country...',
                hintStyle: TextStyle(
                  color: Color(0xFF7F7A72),
                  fontSize: 14.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    const filters = [
      _FilterData(
        icon: Icons.language_rounded,
        label: 'Country',
        trailingIcon: Icons.keyboard_arrow_down_rounded,
      ),
      _FilterData(
        icon: Icons.military_tech_outlined,
        label: 'QS Ranking',
        trailingIcon: Icons.keyboard_arrow_down_rounded,
      ),
      _FilterData(
        icon: Icons.menu_book_outlined,
        label: 'Programs',
        trailingIcon: Icons.keyboard_arrow_down_rounded,
      ),
      _FilterData(
        icon: Icons.filter_alt_outlined,
        label: 'More Filters',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final chipWidth =
            ((constraints.maxWidth - spacing * 3) / 4).clamp(74.0, 118.0);

        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: filters
              .map(
                (filter) => SizedBox(
                  width: chipWidth.toDouble(),
                  child: _FilterChip(data: filter),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.data});

  final _FilterData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDB8).withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.36),
        ),
      ),
      child: Row(
        children: [
          Icon(
            data.icon,
            size: 21,
            color: const Color(0xFF2B2B2B),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                data.label,
                style: const TextStyle(
                  color: Color(0xFF292826),
                  fontSize: 13.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (data.trailingIcon != null) ...[
            const SizedBox(width: 2),
            Icon(
              data.trailingIcon,
              size: 19,
              color: const Color(0xFF2B2B2B),
            ),
          ],
        ],
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  const _UniversityCard({
    required this.data,
    required this.shortlisted,
    required this.onShortlistTap,
  });

  final _UniversityData data;
  final bool shortlisted;
  final VoidCallback onShortlistTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.985),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A3F00).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final logoWidth =
              (constraints.maxWidth * 0.23).clamp(70.0, 84.0).toDouble();
          final statsWidth =
              (constraints.maxWidth * 0.285).clamp(88.0, 102.0).toDouble();
          final infoWidth = constraints.maxWidth - logoWidth - statsWidth - 33;
          final titleSize = data.name.length > 28 ? 14.0 : 15.8;
          final bodySize = infoWidth < 112 ? 11.8 : 12.6;

          return SizedBox(
            height: 146,
            child: Row(
              children: [
                SizedBox(
                  width: logoWidth,
                  child: _UniversityLogo(kind: data.logoKind),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: const Color(0xFFF1E8DC),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _UniversityInfo(
                    data: data,
                    titleSize: titleSize,
                    bodySize: bodySize,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: statsWidth,
                  child: _UniversityStats(
                    data: data,
                    shortlisted: shortlisted,
                    onShortlistTap: onShortlistTap,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UniversityInfo extends StatelessWidget {
  const _UniversityInfo({
    required this.data,
    required this.titleSize,
    required this.bodySize,
  });

  final _UniversityData data;
  final double titleSize;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF24212A),
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            height: 1.02,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${data.countryFlag}  ',
                style: TextStyle(fontSize: bodySize + 1.2),
              ),
              TextSpan(
                text: data.location,
                style: TextStyle(
                  color: const Color(0xFF87807B),
                  fontSize: bodySize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB400),
              size: 24,
            ),
            const SizedBox(width: 4),
            Text(
              data.rating,
              style: TextStyle(
                color: const Color(0xFF292736),
                fontSize: bodySize + 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '(${data.reviews})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF4E4A57),
                  fontSize: bodySize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFBE8C1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            data.ranking,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF7A591A),
              fontSize: bodySize - 0.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _UniversityStats extends StatelessWidget {
  const _UniversityStats({
    required this.data,
    required this.shortlisted,
    required this.onShortlistTap,
  });

  final _UniversityData data;
  final bool shortlisted;
  final VoidCallback onShortlistTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 96;
        final labelStyle = TextStyle(
          color: const Color(0xFF908681),
          fontSize: compact ? 11.2 : 12.0,
          fontWeight: FontWeight.w500,
          height: 1.1,
        );
        final valueStyle = TextStyle(
          color: const Color(0xFF28242F),
          fontSize: compact ? 12.0 : 12.8,
          fontWeight: FontWeight.w700,
          height: 1.16,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onShortlistTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: compact ? 40 : 44,
                    height: compact ? 40 : 44,
                    decoration: BoxDecoration(
                      color: shortlisted
                          ? const Color(0xFFFFF2F0)
                          : const Color(0xFFFDFBF8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE7E1D8),
                      ),
                    ),
                    child: Icon(
                      shortlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: shortlisted
                          ? const Color(0xFFFF6B61)
                          : const Color(0xFF262626),
                      size: compact ? 20 : 22,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: compact ? 6 : 8),
            Text(
              'Tuition Fees',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: data.tuitionFee, style: valueStyle),
                  TextSpan(
                    text: ' / year',
                    style: TextStyle(
                      color: const Color(0xFF6F6761),
                      fontSize: compact ? 11.0 : 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              'Intake',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
            const SizedBox(height: 4),
            Text(
              data.intake,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: valueStyle,
            ),
          ],
        );
      },
    );
  }
}

class _UniversityLogo extends StatelessWidget {
  const _UniversityLogo({required this.kind});

  final _UniversityLogoKind kind;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 86,
        height: 112,
        child: switch (kind) {
          _UniversityLogoKind.harvard => const _HarvardLogo(),
          _UniversityLogoKind.mit => const _MitLogo(),
          _UniversityLogoKind.oxford => const _OxfordLogo(),
          _UniversityLogoKind.nus => const _NusLogo(),
        },
      ),
    );
  }
}

class _HarvardLogo extends StatelessWidget {
  const _HarvardLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 62,
          decoration: const ShapeDecoration(
            color: Color(0xFFB63239),
            shape: _ShieldBorder(),
          ),
          child: const Center(
            child: Text(
              'VE\nRI\nTAS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.8,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'HARVARD',
          style: TextStyle(
            color: Color(0xFF1F1C19),
            fontSize: 13.2,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            height: 1.0,
          ),
        ),
        const Text(
          'UNIVERSITY',
          style: TextStyle(
            color: Color(0xFF1F1C19),
            fontSize: 7.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _MitLogo extends StatelessWidget {
  const _MitLogo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'MIT',
          style: TextStyle(
            color: Color(0xFFC92D3B),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -2.2,
            height: 0.9,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Massachusetts\nInstitute of\nTechnology',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 10.2,
            fontWeight: FontWeight.w700,
            height: 1.12,
          ),
        ),
      ],
    );
  }
}

class _OxfordLogo extends StatelessWidget {
  const _OxfordLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF143D84),
            border: Border.all(
              color: const Color(0xFFE3B74A),
              width: 3,
            ),
          ),
          child: const Center(
            child: Text(
              'OX',
              style: TextStyle(
                color: Color(0xFFE7C36A),
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'UNIVERSITY OF',
          style: TextStyle(
            color: Color(0xFF21345B),
            fontSize: 6.8,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            height: 1.0,
          ),
        ),
        const Text(
          'OXFORD',
          style: TextStyle(
            color: Color(0xFF21345B),
            fontSize: 13.2,
            fontWeight: FontWeight.w500,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _NusLogo extends StatelessWidget {
  const _NusLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFEA9A27),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'N',
                    style: TextStyle(
                      color: Color(0xFFEA8914),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'NUS',
                style: TextStyle(
                  color: Color(0xFF163E87),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'National University\nof Singapore',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF294B7B),
            fontSize: 8.0,
            fontWeight: FontWeight.w600,
            height: 1.12,
          ),
        ),
      ],
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;

        return Container(
          padding: EdgeInsets.fromLTRB(
            compact ? 14 : 16,
            16,
            compact ? 14 : 16,
            16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 56 : 62,
                height: compact ? 56 : 62,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0CB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFF5B018),
                  size: 32,
                ),
              ),
              SizedBox(width: compact ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need help choosing the right university?',
                      style: TextStyle(
                        color: const Color(0xFF201C19),
                        fontSize: compact ? 13.8 : 15.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get personalized recommendations\nfrom our experts.',
                      style: TextStyle(
                        color: const Color(0xFF5B5550),
                        fontSize: compact ? 12.2 : 13.4,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 10 : 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 14 : 18,
                  vertical: compact ? 12 : 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8804),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  'Get Free Advice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 13.0 : 14.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.985),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomBarItem(
            icon: Icons.home_outlined,
            label: 'Home',
          ),
          _BottomBarItem(
            icon: Icons.school_rounded,
            label: 'Universities',
            active: true,
          ),
          _BottomBarItem(
            icon: Icons.favorite_border_rounded,
            label: 'Shortlist',
            badgeText: '3',
          ),
          _BottomBarItem(
            icon: Icons.description_outlined,
            label: 'Applications',
          ),
          _BottomBarItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.badgeText,
  });

  final IconData icon;
  final String label;
  final bool active;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        active ? const Color(0xFFFF8A1E) : const Color(0xFF5B5751);
    final textColor =
        active ? const Color(0xFFFF8A1E) : const Color(0xFF4E4A45);

    return SizedBox(
      width: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 29,
                color: iconColor,
              ),
              if (badgeText != null)
                Positioned(
                  right: -9,
                  top: -7,
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8B06),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        badgeText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 11.6,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterData {
  const _FilterData({
    required this.icon,
    required this.label,
    this.trailingIcon,
  });

  final IconData icon;
  final String label;
  final IconData? trailingIcon;
}

class _UniversityData {
  const _UniversityData({
    required this.id,
    required this.name,
    required this.countryFlag,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.ranking,
    required this.tuitionFee,
    required this.intake,
    required this.logoKind,
  });

  final String id;
  final String name;
  final String countryFlag;
  final String location;
  final String rating;
  final String reviews;
  final String ranking;
  final String tuitionFee;
  final String intake;
  final _UniversityLogoKind logoKind;
}

enum _UniversityLogoKind {
  harvard,
  mit,
  oxford,
  nus,
}

class _ShieldBorder extends ShapeBorder {
  const _ShieldBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width * 0.12, rect.top)
      ..lineTo(rect.right - rect.width * 0.12, rect.top)
      ..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + 8)
      ..lineTo(rect.right, rect.top + rect.height * 0.7)
      ..quadraticBezierTo(
        rect.right,
        rect.bottom - rect.height * 0.08,
        rect.center.dx,
        rect.bottom,
      )
      ..quadraticBezierTo(
        rect.left,
        rect.bottom - rect.height * 0.08,
        rect.left,
        rect.top + rect.height * 0.7,
      )
      ..lineTo(rect.left, rect.top + 8)
      ..quadraticBezierTo(
          rect.left, rect.top, rect.left + rect.width * 0.12, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
