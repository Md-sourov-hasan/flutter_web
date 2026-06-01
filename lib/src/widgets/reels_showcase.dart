import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_theme.dart';
import 'section_widgets.dart';

class ReelsShowcase extends StatefulWidget {
  const ReelsShowcase({
    super.key,
    this.reels = const [
      ReelClipData(
        title: 'Positioning cut',
        subtitle: 'A tighter opener that makes the value proposition land faster.',
        author: 'Jasper Atelier',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        accentColor: Color(0xFFFFB067),
        tag: 'Strategy Reel',
      ),
      ReelClipData(
        title: 'Proof rhythm',
        subtitle: 'The flow keeps trust, motion, and copy in one tight frame.',
        author: 'Jasper Atelier',
        videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
        accentColor: Color(0xFF6788FF),
        tag: 'Design Reel',
      ),
      ReelClipData(
        title: 'Launch energy',
        subtitle: 'A final cut with stronger pacing and a more premium visual system.',
        author: 'Jasper Atelier',
        videoUrl: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
        accentColor: Color(0xFFFF679A),
        tag: 'Motion Reel',
      ),
    ],
  });

  final List<ReelClipData> reels;

  @override
  State<ReelsShowcase> createState() => _ReelsShowcaseState();
}

class _ReelsShowcaseState extends State<ReelsShowcase> {
  late final PageController _pageController;
  late final List<VideoPlayerController> _controllers;
  int _activeIndex = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = [
      for (final reel in widget.reels) VideoPlayerController.networkUrl(Uri.parse(reel.videoUrl)),
    ];

    for (var i = 0; i < _controllers.length; i++) {
      _prepareController(i);
    }
  }

  Future<void> _prepareController(int index) async {
    final controller = _controllers[index];

    try {
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted) {
        return;
      }

      await controller.setVolume(index == _activeIndex && !_isMuted ? 1 : 0);
      setState(() {});
      if (_activeIndex == index) {
        await controller.play();
      } else {
        await controller.pause();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  void _handlePageChanged(int index) {
    setState(() => _activeIndex = index);
    _syncPlayback();
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _syncPlayback();
  }

  void _syncPlayback() {
    for (var i = 0; i < _controllers.length; i++) {
      final controller = _controllers[i];
      if (!controller.value.isInitialized) {
        continue;
      }

      if (i == _activeIndex) {
        controller.setVolume(_isMuted ? 0 : 1);
        controller.play();
      } else {
        controller.setVolume(0);
        controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 860;
        final frameHeight = compact ? 700.0 : 760.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PillLabel(label: 'Reels Feed'),
                      const SizedBox(height: 12),
                      Text(
                        'Scroll inside the frame to jump to the next clip, like a Facebook Reels stack.',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: compact ? 22 : 26,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppTheme.lineDark),
                      ),
                      child: Text(
                        '${_activeIndex + 1}/${widget.reels.length}',
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleMute,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppTheme.lineDark),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                size: 14,
                                color: AppTheme.textDark,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isMuted ? 'Muted' : 'Sound on',
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Three short cuts live inside one tall frame, so the section behaves like a compact reel feed instead of a normal gallery.',
              style: const TextStyle(
                color: AppTheme.textDarkMuted,
                fontSize: 15,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: frameHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: AppTheme.lineDark),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1B07111F),
                    blurRadius: 26,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const PageScrollPhysics(),
                  itemCount: widget.reels.length,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (context, index) {
                    return _ReelSlide(
                      reel: widget.reels[index],
                      controller: _controllers[index],
                      index: index,
                      total: widget.reels.length,
                      active: index == _activeIndex,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ReelHintChip(
                  icon: Icons.swipe_up,
                  label: 'Swipe to switch reels',
                ),
                _ReelHintChip(
                  icon: Icons.volume_up,
                  label: 'Sound on active reel',
                ),
                _ReelHintChip(
                  icon: Icons.play_circle_outline,
                  label: 'Current reel auto-plays',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ReelSlide extends StatelessWidget {
  const _ReelSlide({
    required this.reel,
    required this.controller,
    required this.index,
    required this.total,
    required this.active,
  });

  final ReelClipData reel;
  final VideoPlayerController controller;
  final int index;
  final int total;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                reel.accentColor.withValues(alpha: 0.25),
                const Color(0xFF142036),
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: controller.value.isInitialized
              ? FittedBox(
                  key: ValueKey('video-${reel.title}'),
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                )
              : Container(
                  key: ValueKey('loading-${reel.title}'),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        reel.accentColor.withValues(alpha: 0.32),
                        const Color(0xFF162235),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.16),
                  Colors.black.withValues(alpha: 0.72),
                ],
                stops: const [0, 0.58, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: 18,
          left: 18,
          right: 18,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Text(
                  reel.tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                ),
                child: Text(
                  '${index + 1}/$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 18,
          child: AnimatedOpacity(
            opacity: active ? 1 : 0.82,
            duration: const Duration(milliseconds: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reel.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.02,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  reel.subtitle,
                  style: const TextStyle(
                    color: Color(0xFFE9EEF7),
                    fontSize: 14,
                    height: 1.55,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.bolt, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      reel.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                      ),
                      child: const Text(
                        'Scroll for next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!controller.value.isInitialized)
          Positioned(
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Loading reel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ReelHintChip extends StatelessWidget {
  const _ReelHintChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.lineDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textDark),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ReelClipData {
  const ReelClipData({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.videoUrl,
    required this.accentColor,
    required this.tag,
  });

  final String title;
  final String subtitle;
  final String author;
  final String videoUrl;
  final Color accentColor;
  final String tag;
}
