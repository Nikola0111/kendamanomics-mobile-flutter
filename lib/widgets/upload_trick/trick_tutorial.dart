import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/providers/upload_trick_provider.dart';
import 'package:kendamanomics_mobile/widgets/custom_loading_indicator.dart';
import 'package:kendamanomics_mobile/widgets/text_icon_link.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrickTutorial extends StatefulWidget {
  final String? trickTutorialUrl;
  const TrickTutorial({super.key, required this.trickTutorialUrl});

  @override
  State<TrickTutorial> createState() => _TrickTutorialState();
}

class _TrickTutorialState extends State<TrickTutorial> {
  WebViewController? _webviewController;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeWebviewController();
  }

  void _initializeWebviewController() async {
    if (widget.trickTutorialUrl != null) {
      _webviewController = WebViewController();
      _webviewController?.setJavaScriptMode(JavaScriptMode.unrestricted);
      _webviewController?.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!_isLoaded && progress == 100) {
              setState(() {
                _isLoaded = true;
              });
            }
          },
        ),
      );
      await _webviewController?.loadRequest(Uri.parse('${widget.trickTutorialUrl!}?autoplay=1&autohide=1&controls=1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_webviewController != null && _isLoaded) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: WebViewWidget(
                    controller: _webviewController!,
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (widget.trickTutorialUrl == null) return;
                      final uri = Uri.parse(widget.trickTutorialUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                    child: Container(),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextIconLink(
            title: 'upload_trick.upload'.tr(),
            onPressed: context.read<UploadTrickProvider>().goToSubmission,
            iconPosition: IconPosition.leading,
            icon: Transform.rotate(
              angle: pi / 2,
              child: Image.asset('assets/icon/icon_arrow.png', height: 12, width: 12),
            ),
          ),
        ],
      );
    }

    return CustomLoadingIndicator(customColor: CustomColors.of(context).primary);
  }
}
