import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';

import 'player_platform_interface.dart';

class Player extends FijkPlayer {
  static const asset_url_suffix = "asset:///";
  static const cache_switch = 'ijkio:cache:ffio:';

  static String _cachePath =
      '/storage/emulated/0/Android/data/com.ly.flutter.fluttertest/files';
  bool enableCache = false;

  static void setCachePath(String path) {
    _cachePath = path;
  }

  void setCommonDataSource(
    String url, {
    SourceType type = SourceType.net,
    bool autoPlay = false,
    bool showCover = false,
  }) {
    if (type == SourceType.asset && !url.startsWith(asset_url_suffix)) {
      url = asset_url_suffix + url;
    }
    print("ly-setCommonDataSource: $url");
    setDataSource(url, autoPlay: autoPlay, showCover: showCover);
  }

  @override
  Future<void> setDataSource(String path,
      {bool autoPlay = false, bool showCover = false}) async {
    var videoPath = getVideoCachePath(path, _cachePath);
    if (File(videoPath).existsSync()) {
      path = videoPath;
      print('ly- play cache video: $path');
    } else if (enableCache) {
      // 走三级缓存，并添加到二级缓存——本地磁盘中
      // 设置播放器缓存的步骤：
      // 1、增加视频path前缀
      path = '$cache_switch$path';
      // 2、通过setOption设置cache_file_path
      setOption(FijkOption.formatCategory, 'cache_file_path', videoPath);
      print('ly- play http with cache: $cache_switch$path');
    } else {
      print('ly- play http: $path');
    }
    super.setDataSource(path, autoPlay: autoPlay, showCover: showCover);
  }

  String getVideoCachePath(String url, String cachePath) {
    Uri uri = Uri.parse(url);
    String name = uri.pathSegments.last;
    var path = "$cache_switch/$name";
    return path;
  }

  Future<String?> getPlatformVersion() {
    return PlayerPlatform.instance.getPlatformVersion();
  }
}

enum SourceType { net, asset }
