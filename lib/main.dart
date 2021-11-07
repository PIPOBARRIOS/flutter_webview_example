import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp(key: UniqueKey()));
}

// Html para Embeber el codigo 
String getHtmlBody(String tcrCodeEmbed) => """
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            *{box-sizing: border-box;margin:0px; padding:0px;}
              #widget {
                        display: flex;
                        justify-content: center;
                        margin: 0 auto;
                        max-width:100%;
                    }      
          </style>
        </head>
        <body>
          <div id="widget">$tcrCodeEmbed</div>
        </body>
      </html>
    """;


//-------------------------------------------------
// Tiktok
//-------------------------------------------------
String getHtmlEmbedTikTok = "https://www.tiktok.com/@mybf98/video/7026812065767509253?is_copy_url=0&is_from_webapp=v1&sender_device=pc&sender_web_id=6893828658361845254";

//-------------------------------------------------
// Youtube
//-------------------------------------------------
// codigo del video - ejemplo: https://www.youtube.com/watch?v=VSzo940auvk 
String videoIdKeyYoutube = "VSzo940auvk";
String getHtmlEmbedYoutube(String tcrKeyVideo) => "https://www.youtube.com/embed/" + tcrKeyVideo;

//-------------------------------------------------
// Instagram embedded
//-------------------------------------------------
// link del video
String videoUrlInstagram =  "https://www.instagram.com/reel/CVwSuWXA3FG/?utm_source=ig_embed&amp;utm_campaign=loading"; 
// codigo html
String getHtmlEmbedInstagram(String tcrUrlVideo) => """
  <blockquote class="instagram-media" 
    data-instgrm-captioned data-instgrm-permalink="$tcrUrlVideo" 
    data-instgrm-version="12" 
    style=" background:#FFF; border:0; border-radius:3px; 
      box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); 
      margin: 1px; max-width:540px; min-width:326px; 
      padding:0; width:99.375%; 
      width:-webkit-calc(100% - 2px); width:calc(100% - 2px);">
    <div style="padding:16px;">
      <a href="$tcrUrlVideo" 
        style=" background:#FFFFFF; line-height:0; 
        padding:0 0; text-align:center; 
        text-decoration:none; width:100%;" target="_blank">
      </a>
    </div>
  </blockquote>
  <script type="text/javascript" src="https://www.instagram.com/embed.js"></script>
""";

//-------------------------------------------------
// Facebook embedded
//-------------------------------------------------
// link video
String videoUrlFaceBook = "https://www.facebook.com/watch/?v=340373467856175&ref=sharing"; 
// codigo html
String getHtmlEmbedFaceBook(String tcrUrlVideo) => """ 
  <div id="fb-root"></div><div class="fb-video" data-href="$tcrUrlVideo"></div>
  <script type="text/javascript" src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.2"></script>
"""; 



class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Embed WebView Example'),
          ),
          body: ListView(
            children: [
                const SizedBox(height: 20),

                // Video Youtube
                const Text("Video Youtube"),
                _buildWebView(getHtmlEmbedYoutube(videoIdKeyYoutube)),
                const SizedBox(height: 20),

                // Video Facebook
                const Text("Video FaceBook"),
                _buildWebView(getHtmlEmbedFaceBook(videoUrlFaceBook)),
                const SizedBox(height: 20),

                // Video Instagram
                const Text("Video Instagram"),
                _buildWebView(getHtmlEmbedInstagram(videoUrlInstagram)),
                const SizedBox(height: 20),

                const Text("Video Tiktok"),
                _buildWebView(getHtmlEmbedTikTok),
                const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWebView(String codeHtmlEmbed) {

    Completer<WebViewController>? _controller = Completer<WebViewController>();
    var _lcrHtmlCode = codeHtmlEmbed.contains("https://www.youtube.com") ||
                       codeHtmlEmbed.contains("https://www.tiktok.com")?
                                    codeHtmlEmbed : setEncodingHtmlToUri(getHtmlBody(codeHtmlEmbed));

    return SizedBox(
      height: 420,
      child: WebView(
        initialUrl: _lcrHtmlCode,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          if (_controller.isCompleted == false)
          {
            _controller.complete(webViewController);
          }
        }
      )
    );
  }

  // convertir en codigo valido para Url 
  String setEncodingHtmlToUri(String code) {
    return Uri.dataFromString(code,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

}