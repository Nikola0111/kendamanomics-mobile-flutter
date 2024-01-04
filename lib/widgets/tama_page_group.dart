import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/premium_tamas_group.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/providers/tamas_provider.dart';
import 'package:kendamanomics_mobile/widgets/tama_widget.dart';
import 'package:video_player/video_player.dart';

class TamaPageGroup extends StatefulWidget {
  final TamasGroup group;
  final TamasProviderState state;
  final bool showPromotionOverlay;
  final void Function(String? tamaID) onTamaPressed;
  final void Function(String? tamaID) onBuyPressed;
  const TamaPageGroup({
    super.key,
    required this.group,
    required this.state,
    required this.showPromotionOverlay,
    required this.onTamaPressed,
    required this.onBuyPressed,
  });

  @override
  State<TamaPageGroup> createState() => _TamaPageGroupState();
}

class _TamaPageGroupState extends State<TamaPageGroup> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.group is PremiumTamasGroup && widget.showPromotionOverlay) {
      _initVideoController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            widget.group.name ?? 'default_titles.tama_group'.tr(),
            style: CustomTextStyles.of(context).regular25.apply(color: CustomColors.of(context).primary),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (!widget.showPromotionOverlay)
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (var playerTama in widget.group.playerTamas) ...[
                          TamaWidget(
                            playerTama: playerTama,
                            state: widget.state,
                            onTap: () {
                              widget.onTamaPressed(playerTama.tama.id);
                            },
                          ),
                          if (widget.group.playerTamas.indexOf(playerTama) != widget.group.playerTamas.length - 1)
                            const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
              if (widget.showPromotionOverlay) ...[
                Positioned.fill(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      if (_initialized)
                        Expanded(
                          child: GestureDetector(
                            onTap: _playPauseVideo,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              ),
                            ),
                          ),
                        ),
                      if (!_initialized) const Expanded(child: CupertinoActivityIndicator(animating: true, radius: 20)),
                      InkWell(
                        onTap: () => widget.onBuyPressed(widget.group.formatIdForPayment),
                        child: Image.asset('assets/icon/icon_buy_premium.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  void _initVideoController() async {
    final group = widget.group as PremiumTamasGroup;
    _controller = VideoPlayerController.networkUrl(Uri.parse(group.videoUrl));
    _controller!.initialize().then((value) {
      _initialized = true;
      setState(() {});
      _playPauseVideo();
    }).onError((error, stackTrace) {
      _initVideoController();
    });
  }

  void _playPauseVideo() async {
    if (_controller == null) return;
    if (_isPlaying) {
      _isPlaying = false;
      _controller!.pause();
    } else {
      _isPlaying = true;
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
