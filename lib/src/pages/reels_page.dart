import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../navigation/site_navigation.dart';
import '../widgets/reels_showcase.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  static const routeName = '/reels';

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late final PageController _pageController;
  late final List<VideoPlayerController> _controllers;
  late final List<ReelClipData> _reels;
  int _activeIndex = 0;
  bool _isMuted = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _reels = const [
      ReelClipData(
        title: 'Barakah bite\'s by Takdir',
        subtitle: 'A tighter opener that makes the value proposition land faster.',
        author: 'Jasper Atelier',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        accentColor: Color(0xFFFFB067),
        tag: 'Public',
        caption:
            'কবির বেশি লিখতে বললেই ছেলেদের মাথায় খারাপ হয়ে যায় মেয়েদের মেয়ের পরিবার লোভী কত কি যেন টাকাটা ওর সাথে সাথে দিয়ে দেয় ইচ্ছাটা গুলা বাংলাদেশে থ...',
        audioLabel: 'Stewart Eduri · Vaani Bati',
        likeCount: '18K',
        commentCount: '843',
        shareCount: '758',
      ),
      ReelClipData(
        title: 'Proof rhythm',
        subtitle: 'The flow keeps trust, motion, and copy in one tight frame.',
        author: 'Jasper Atelier',
        videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
        accentColor: Color(0xFF6788FF),
        tag: 'Public',
        caption:
            'A calmer proof-first frame that keeps the message visible while the reel feels like a living social feed.',
        audioLabel: 'Jasper Atelier · Motion Loop',
        likeCount: '9.4K',
        commentCount: '202',
        shareCount: '311',
      ),
      ReelClipData(
        title: 'Launch energy',
        subtitle: 'A final cut with stronger pacing and a more premium visual system.',
        author: 'Jasper Atelier',
        videoUrl: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
        accentColor: Color(0xFFFF679A),
        tag: 'Public',
        caption: 'The final reel keeps the interface sharp, minimal, and focused on a single vertical story at a time.',
        audioLabel: 'Jasper Atelier · Launch Mix',
        likeCount: '12K',
        commentCount: '411',
        shareCount: '502',
      ),
    ];
    _controllers = [
      for (final reel in _reels) VideoPlayerController.networkUrl(Uri.parse(reel.videoUrl)),
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

      await controller.setVolume(_isMuted ? 0 : 1);
      setState(() {});
      if (index == _activeIndex && _isPlaying) {
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

  void _syncPlayback() {
    for (var i = 0; i < _controllers.length; i++) {
      final controller = _controllers[i];
      if (!controller.value.isInitialized) {
        continue;
      }

      if (i == _activeIndex && _isPlaying) {
        controller.setVolume(_isMuted ? 0 : 1);
        controller.play();
      } else {
        controller.pause();
      }
    }
  }

  void _setActiveIndex(int index) {
    setState(() => _activeIndex = index);
    _syncPlayback();
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _syncPlayback();
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    _syncPlayback();
  }

  void _nextReel() {
    final nextIndex = (_activeIndex + 1) % _reels.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
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
    final current = _reels[_activeIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 900;
            final stageWidth = isCompact ? constraints.maxWidth : constraints.maxWidth * 0.42;
            final videoWidth = stageWidth.clamp(320.0, 460.0);
            final videoHeight = (videoWidth * 1.78).clamp(540.0, constraints.maxHeight - 170);

            return Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.0, -0.25),
                          radius: 1.1,
                          colors: [
                            Color(0x331F2A3A),
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  top: 6,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => navigateToRoute(context, '/'),
                        borderRadius: BorderRadius.circular(999),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close, color: Colors.white, size: 26),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Reels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _TopProfileBadge(
                              title: current.title,
                              subtitle: current.tag,
                            ),
                            const SizedBox(width: 18),
                            _TopIconButton(
                              icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                              onTap: _togglePlayPause,
                            ),
                            _TopIconButton(
                              icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                              onTap: _toggleMute,
                            ),
                            _TopIconButton(
                              icon: Icons.more_horiz,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: videoWidth,
                      height: videoHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.vertical,
                            physics: const PageScrollPhysics(),
                            itemCount: _reels.length,
                            onPageChanged: _setActiveIndex,
                            itemBuilder: (context, index) {
                              return _ReelCanvas(
                                reel: _reels[index],
                                controller: _controllers[index],
                                active: index == _activeIndex,
                                isMuted: _isMuted,
                              );
                            },
                          ),
                          Positioned(
                            right: -34,
                            top: videoHeight * 0.44,
                            child: InkWell(
                              onTap: _nextReel,
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black87,
                                  size: 34,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: isCompact ? 12 : 28,
                  bottom: isCompact ? 132 : 146,
                  child: _ActionRail(data: current),
                ),
                Positioned(
                  left: isCompact ? 18 : 70,
                  right: isCompact ? 92 : 150,
                  bottom: isCompact ? 20 : 24,
                  child: _CaptionDock(reel: current),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 1,
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReelCanvas extends StatelessWidget {
  const _ReelCanvas({
    required this.reel,
    required this.controller,
    required this.active,
    required this.isMuted,
  });

  final ReelClipData reel;
  final VideoPlayerController controller;
  final bool active;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
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
                        reel.accentColor.withValues(alpha: 0.28),
                        Colors.black,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
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
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.04),
                  Colors.black.withValues(alpha: 0.72),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: reel.accentColor.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reel.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.public, size: 10, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          'Public',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 12,
          right: 12,
          child: AnimatedOpacity(
            opacity: active ? 1 : 0.72,
            duration: const Duration(milliseconds: 180),
            child: Text(
              reel.subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.5,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 12),
                ],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (controller.value.isInitialized)
          Positioned(
            right: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.26),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isMuted ? 'Muted' : 'Sound on',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TopProfileBadge extends StatelessWidget {
  const _TopProfileBadge({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.public, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 18),
      splashRadius: 18,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({required this.data});

  final ReelClipData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailAction(icon: Icons.thumb_up_alt_outlined, label: data.likeCount),
        const SizedBox(height: 18),
        _RailAction(icon: Icons.mode_comment_outlined, label: data.commentCount),
        const SizedBox(height: 18),
        _RailAction(icon: Icons.reply_outlined, label: data.shareCount),
      ],
    );
  }
}

class _RailAction extends StatelessWidget {
  const _RailAction({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CaptionDock extends StatelessWidget {
  const _CaptionDock({required this.reel});

  final ReelClipData reel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reel.caption ?? reel.subtitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.45,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.graphic_eq, color: Colors.white, size: 14),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                reel.audioLabel ?? '${reel.author} • ${reel.title}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
