import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidgetView extends StatefulWidget {
  const WebViewWidgetView({super.key, required this.url, this.onPop});
  final String url;
  final Function(WebViewController)? onPop;
  @override
  State<WebViewWidgetView> createState() => _WebViewWidgetViewState();
}

class _WebViewWidgetViewState extends State<WebViewWidgetView> {
  late final WebViewController _controller;

  bool isError = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url)).then((value) => setState(() {
              _isLoading = false;
            }));
    } catch (e) {
      setState(() {
        _isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return WebView(
    //   debuggingEnabled: true,
    //   javascriptMode: JavascriptMode.unrestricted,
    //   initialUrl: widget.url,
    // );
    if (_isLoading) {
      return const Center(child: CustomLoadingWidget());
    } else if (isError) {
      return Center(
        child: CustomErrorWidget(
            isNoData: true,
            isShowRetriyButton: false,
            onRetry: () {},
            isShowCustomMessage: true,
            text: "Something went wrong!"),
      );
    } else {
      return WebViewWidget(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        controller: _controller,
      );
    }
  }
}

class WebViewWidgetViewForIFrame extends StatefulWidget {
  const WebViewWidgetViewForIFrame({super.key, required this.wisatiaID});
  final String wisatiaID;
  @override
  State<WebViewWidgetViewForIFrame> createState() =>
      _WebViewWidgetViewForIFrameState();
}

class _WebViewWidgetViewForIFrameState
    extends State<WebViewWidgetViewForIFrame> {
  late final WebViewController _controller;

  bool isError = false;
  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.dataFromString('''
              <iframe src="https://fast.wistia.net/embed/iframe/${widget.wisatiaID}?seo=true&videoFoam=false&resumable=true" title="Lenny's Halloween Costume Video" allow="autoplay; fullscreen" allowtransparency="true" frameborder="0" scrolling="no" class="wistia_embed" name="wistia_embed" msallowfullscreen width="100%" height="100%"></iframe>
              <script src="https://fast.wistia.net/assets/external/E-v1.js" async></script>
                            ''', mimeType: 'text/html'),
        );
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Center(
        child: CustomErrorWidget(
            isNoData: true,
            isShowRetriyButton: false,
            onRetry: () {},
            isShowCustomMessage: true,
            text: "Something went wrong!"),
      );
    } else {
      return WebViewWidget(
        controller: _controller,
      );
    }
  }
}

class WistiaChanelWebview extends StatefulWidget {
  const WistiaChanelWebview({super.key, required this.wisatiaID});
  final String wisatiaID;
  @override
  State<WistiaChanelWebview> createState() => _WistiaChanelWebviewState();
}

class _WistiaChanelWebviewState extends State<WistiaChanelWebview> {
  late final WebViewController _controller;

  bool isError = false;
  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.dataFromString(widget.wisatiaID, mimeType: 'text/html'),
        );
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Center(
        child: CustomErrorWidget(
            isNoData: true,
            isShowRetriyButton: false,
            onRetry: () {},
            isShowCustomMessage: true,
            text: "Something went wrong!"),
      );
    } else {
      return WebViewWidget(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        controller: _controller,
      );
    }
  }
}
