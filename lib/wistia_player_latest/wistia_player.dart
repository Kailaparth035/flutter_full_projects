import 'dart:convert';

import 'package:aspirevue/wistia_player_latest/enums/wistia_player_state.dart';
import 'package:aspirevue/wistia_player_latest/wistia_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'wistia_meta_data.dart';

// Import for Android features.

// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WistiaPlayerLatest extends StatefulWidget {
  final WistiaPlayerLatestController controller;

  final void Function(WistiaMetaData metaData)? onEnded;

  const WistiaPlayerLatest({super.key, this.onEnded, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _WistiaPlayerLatestState createState() => _WistiaPlayerLatestState();
}

class _WistiaPlayerLatestState extends State<WistiaPlayerLatest>
    with WidgetsBindingObserver {
  WistiaPlayerLatestController? controller;
  WistiaPlayerLatestState? _cachedPlayerState;
  bool _initialLoad = true;

  late final WebViewController _webViewController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    if (!widget.controller.hasDisposed) {
      controller = widget.controller..addListener(listener);
    }
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
            NavigationDelegate(onWebResourceError: _handleWebResourceError))
        ..addJavaScriptChannel("WistiaWebView",
            onMessageReceived: (JavaScriptMessage message) {
          Map<String, dynamic> jsonMessage = jsonDecode(message.message);
          switch (jsonMessage['method']) {
            case 'Ready':
              {
                controller
                    ?.updateValue(controller!.value.copyWith(isReady: true));
                break;
              }
            case 'getVideoTimeDuration':
              {
                debugPrint(" ===> timer called");
                break;
              }
            case 'Ended':
              {
                if (widget.onEnded != null) {
                  widget.onEnded!(WistiaMetaData.fromJson(jsonMessage));
                }
              }
          }
        })
        ..loadRequest(
          Uri.dataFromString(
            _buildWistiaHTML(controller!),
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ),
        )
        ..setOnConsoleMessage((message) {
          debugPrint("======console log=> ${message.message}");
        })
        ..clearCache();

      if (_webViewController.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (_webViewController.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      controller?.updateValue(
        controller!.value.copyWith(webViewController: _webViewController),
      );
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }
    super.initState();
  }

  void listener() async {
    if (controller == null) return;
    if (_initialLoad) {
      _initialLoad = false;
      controller?.updateValue(controller!.value.copyWith(
          autoPlay: controller?.options.autoPlay,
          controlsVisibleOnLoad: controller?.options.controlsVisibleOnLoad,
          copyLinkAndThumbnailEnabled:
              controller?.options.copyLinkAndThumbnailEnabled,
          doNotTrack: controller?.options.doNotTrack,
          email: controller?.options.email,
          endVideoBehavior: controller?.options.endVideoBehavior,
          fakeFullScreen: controller?.options.fakeFullScreen,
          fitStrategy: controller?.options.fitStrategy,
          fullscreenButton: controller?.options.fullscreenButton,
          fullscreenOnRotateToLandscape:
              controller?.options.fullscreenOnRotateToLandscape,
          googleAnalytics: controller?.options.googleAnalytics,
          playbackRateControl: controller?.options.playbackRateControl,
          playbar: controller?.options.playbar,
          playButton: controller?.options.playButton,
          playerColor: controller?.options.playerColor,
          playlistLinks: controller?.options.playlistLinks,
          playlistLoop: controller?.options.playlistLoop,
          playsinline: controller?.options.playsinline,
          playSuspendedOffScreen: controller?.options.playSuspendedOffScreen,
          preload: controller?.options.preload,
          qualityControl: controller?.options.qualityControl,
          qualityMax: controller?.options.qualityMax,
          qualityMin: controller?.options.qualityMin,
          resumable: controller?.options.resumable,
          seo: controller?.options.seo,
          settingsControl: controller?.options.settingsControl,
          silentAutoPlay: controller?.options.silentAutoPlay,
          smallPlayButton: controller?.options.smallPlayButton,
          stillUrl: controller?.options.stillUrl,
          time: controller?.options.time,
          thumbnailAltText: controller?.options.thumbnailAltText,
          videoFoam: controller?.options.videoFoam,
          volume: controller?.options.volume,
          volumeControl: controller?.options.volumeControl,
          wmode: controller?.options.wmode));
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    controller?.removeListener(listener);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_cachedPlayerState != null &&
            _cachedPlayerState == WistiaPlayerLatestState.playing) {
          controller?.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cachedPlayerState = controller?.value.playerState;
        controller?.pause();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // InkWell(
        //   onTap: () {
        //     controller!.callMethod("getVideoTimeDuration()");
        //   },
        //   child: Text("data"),
        // ),
        Flexible(
          child: WebViewWidget(
            controller: _webViewController,
          ),
        ),
      ],
    );
  }

  void _handleWebResourceError(WebResourceError error) {
    controller?.updateValue(
      controller!.value.copyWith(
          errorCode: error.errorCode, errorMessage: error.description),
    );
  }

  // JavascriptChannel _getJavascriptChannel() {
  //   return JavascriptChannel(
  //       name: 'WistiaWebView',
  //       onMessageReceived: (JavascriptMessage message) {
  //         Map<String, dynamic> jsonMessage = jsonDecode(message.message);
  //         switch (jsonMessage['method']) {
  //           case 'Ready':
  //             {
  //               controller
  //                   ?.updateValue(controller!.value.copyWith(isReady: true));
  //               break;
  //             }
  //           case 'Ended':
  //             {
  //               print('Video has ended');
  //               if (widget.onEnded != null) {
  //                 widget.onEnded!(WistiaMetaData.fromJson(jsonMessage));
  //               }
  //             }
  //         }
  //       });
  // }

  // void _onWebViewCreated(WebViewController webViewController) {
  //   webViewController.loadUrl(
  //     Uri.dataFromString(
  //       _buildWistiaHTML(controller!),
  //       mimeType: 'text/html',
  //       encoding: Encoding.getByName('utf-8'),
  //     ).toString(),
  //   );

  //   controller?.updateValue(
  //     controller!.value.copyWith(webViewController: webViewController),
  //   );
  // }

  String _buildWistiaHTML(WistiaPlayerLatestController controller) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
        <style>
          html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                opacity: 0
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
            }
            iframe, .player {
              display: block;
              width: 100%;
              height: 100%;
              border: none;
              }
            </style>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
        </head>
        <body>
           <script src="https//fast.wistia.com/embed/medias/${controller.videoId}.jsonp" async></script>
           <script src="https://fast.wistia.com/assets/external/E-v1.js" async></script>
           <div class="wistia_embed wistia_async_${controller.videoId} ${controller.options.toString()} player">&nbsp;</div>
          <script>
          var video1;
          window._wq = window._wq || []
          _wq.push({
            id: '${controller.videoId}',
             
            onReady: function(video) {
                video1 = video;
                if (video.hasData()) {
                  sendMessageToDart('Ready');
                }
                video.bind("play()", function() {
                  sendMessageToDart('Playing')
                })

                video.bind('pause()', function() {
                  sendMessageToDart('Paused')
                })
                video.bind("end", function(endTime) {
                  sendMessageToDart('Ended', { endTime: endTime });
                })

                video.bind("percentwatchedchanged", function(percent, lastPercent) {
                  sendMessageToDart('PercentChanged', { percent, percent, lastPercent: lastPercent })
                })

                video.bind("mutechange", function (isMuted) {
                  sendMessageToDart('MuteChange', { isMuted: isMuted })
                })

                video.bind("enterfullscreen", function() {
                  sendMessageToDart('EnterFullscreen')
                })

                video.bind("cancelfullscreen", function() {
                  sendMessageToDart('CancelFullscreen')
                })

                video.bind("beforeremove", function() {
                  return video.unbind
                })

                window.play = function play() {
                  return video.play();
                }
                window.pause = function pause() {
                  return video.pause();
                }
                window.isMuted = function isMuted() {
                  return video.isMuted()
                }

                window.inFullscreen = function inFullscreen() {
                  return video.inFullscreen()
                }

                window.hasData = function hasData() {
                  return video.hasData()
                }

                window.aspect = function aspect() {
                  return video.aspect()
                }

                window.mute = function mute() {
                  return video.mute()
                }

                window.unmute = function unmute() {
                  return video.unmute()
                }

                window.duration = function duration() {
                  return video.duration()
                }


              },
          });

          function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
              'method': methodName,
              'args': argsObject
            };
            WistiaWebView.postMessage(JSON.stringify(message));
          }

          function getVideoTimeDuration() {
            console.log("==> log ==> getVideoTimeDuration");
            video1.play();
          }
          </script>
        </body>
      </html>
    ''';
  }

  String? get userAgent => controller!.options.forceHD
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : null;
}
