import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:PiliPalaX/models/model_owner.dart';
import 'package:PiliPalaX/models/search/hot.dart';
import 'package:PiliPalaX/models/user/info.dart';
import 'global_data.dart';

class GStorage {
  static late final Box<dynamic> userInfo;
  static late final Box<dynamic> historyWord;
  static late final Box<dynamic> localCache;
  static late final Box<dynamic> setting;
  static late final Box<dynamic> video;
  static late final Box<dynamic> onlineCache;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    regAdapter();
    // 登录用户信息
    userInfo = await Hive.openBox(
      'userInfo',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 2;
      },
    );
    // 本地缓存
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 4;
      },
    );
    // 设置
    setting = await Hive.openBox('setting');
    // 搜索历史
    historyWord = await Hive.openBox(
      'historyWord',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 10;
      },
    );
    // 视频设置
    video = await Hive.openBox('video');
    onlineCache = await Hive.openBox('onlineCache');
    GlobalData().imgQuality =
        setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10); // 设置全局变量
  }

  // 特殊处理playerGestureActionMap的逻辑
  // json不支持Map<int, int>，需要使用Map<String, int>中介
  static String specialKey = SettingBoxKey.playerGestureActionMap;

  static Map toEncodableManually(Map data) {
    if (data.containsKey(specialKey)) {
      data[specialKey] =
          data[specialKey].map((key, value) => MapEntry(key.toString(), value));
    }
    return data;
  }

  static Map fromEncodableManually(Map data) {
    if (data.containsKey(specialKey)) {
      data[specialKey] =
          data[specialKey].map((key, value) => MapEntry(int.parse(key), value));
    }
    return data;
  }

  static Future<String> exportAllSettings() async {
    return jsonEncode({
      setting.name: toEncodableManually(setting.toMap()),
      video.name: video.toMap(),
    });
  }

  static Future<void> importAllSettings(String data) async {
    final Map<String, dynamic> map = jsonDecode(data);
    await setting.clear();
    await video.clear();
    await setting.putAll(fromEncodableManually(map[setting.name]));
    await video.putAll(map[video.name]);
  }

  static void regAdapter() {
    Hive.registerAdapter(OwnerAdapter());
    Hive.registerAdapter(UserInfoDataAdapter());
    Hive.registerAdapter(LevelInfoAdapter());
    Hive.registerAdapter(HotSearchModelAdapter());
    Hive.registerAdapter(HotSearchItemAdapter());
  }

  static Future<void> close() async {
    // user.compact();
    // user.close();
    userInfo.compact();
    userInfo.close();
    historyWord.compact();
    historyWord.close();
    localCache.compact();
    localCache.close();
    setting.compact();
    setting.close();
    video.compact();
    video.close();
    onlineCache.compact();
    onlineCache.close();
  }
}

class SettingBoxKey {
  /// 播放器
  static const String btmProgressBehavior = 'btmProgressBehavior',
      defaultVideoSpeed = 'defaultVideoSpeed',
      autoUpgradeEnable = 'autoUpgradeEnable',
      feedBackEnable = 'feedBackEnable',
      defaultVideoQa = 'defaultVideoQa',
      defaultAudioQa = 'defaultAudioQa',
      autoPlayEnable = 'autoPlayEnable',
      fullScreenMode = 'fullScreenMode',
      defaultDecode = 'defaultDecode',
      secondDecode = 'secondDecode',
      danmakuEnable = 'danmakuEnable',
      defaultToastOp = 'defaultToastOp',
      defaultPicQa = 'defaultPicQa',
      enableHA = 'enableHA',
      useOpenSLES = 'useOpenSLES',
      expandBuffer = 'expandBuffer',
      hardwareDecoding = 'hardwareDecoding',
      videoSync = 'videoSync',
      enableVerticalExpand = 'enableVerticalExpand',
      enableOnlineTotal = 'enableOnlineTotal',
      enableAutoEnter = 'enableAutoEnter',
      enableAutoExit = 'enableAutoExit',
      enableLongShowControl = 'enableLongShowControl',
      allowRotateScreen = 'allowRotateScreen',
      horizontalScreen = 'horizontalScreen',
      p1080 = 'p1080',
      CDNService = 'CDNService',
      disableAudioCDN = 'disableAudioCDN',
      // enableCDN = 'enableCDN',
      autoMiniPlayer = 'autoMiniPlayer',
      autoPiP = 'autoPiP',
      pipNoDanmaku = 'pipNoDanmaku',
      enableKeepLastSpeed = 'enableKeepLastSpeed',
      enableAutoLongPressSpeed = 'enableAutoLongPressSpeed',
      enableLongPressSpeedIncrease = 'enableLongPressSpeedIncrease',
      subtitlePreference = 'subtitlePreference',
      playerGestureActionMap = 'playerGestureActionMap',
      // youtube 双击快进快退
      enableQuickDouble = 'enableQuickDouble',
      enableAdjustBrightnessVolume = 'enableAdjustBrightnessVolume',
      enableExtraButtonOnFullScreen = 'enableExtraButtonOnFullScreen',
      // fullScreenGestureReverse = 'fullScreenGestureReverse',
      // enableFloatingWindowGesture = 'enableFloatingWindowGesture',
      enableShowDanmaku = 'enableShowDanmaku',
      enableBackgroundPlay = 'enableBackgroundPlay',
      continuePlayInBackground = 'continuePlayInBackground',
      setSystemBrightness = 'setSystemBrightness',

      /// 隐私
      anonymity = 'anonymity',

      /// 推荐
      enableRcmdDynamic = 'enableRcmdDynamic',
      defaultRcmdType = 'defaultRcmdType',
      enableSaveLastData = 'enableSaveLastData',
      minDurationForRcmd = 'minDurationForRcmd',
      minLikeRatioForRecommend = 'minLikeRatioForRecommend',
      exemptFilterForFollowed = 'exemptFilterForFollowed',
      banWordForRecommend = 'banWordForRecommend',
      //filterUnfollowedRatio = 'filterUnfollowedRatio',
      applyFilterToRelatedVideos = 'applyFilterToRelatedVideos',
      disableRelatedVideos = 'disableRelatedVideos',

      /// 其他
      autoUpdate = 'autoUpdate',
      autoClearCache = 'autoClearCache',
      defaultShowComment = 'defaultShowComment',
      defaultExpandIntroduction = 'defaultExpandIntroduction',
      replySortType = 'replySortType',
      defaultDynamicType = 'defaultDynamicType',
      enableHotKey = 'enableHotKey',
      enableQuickFav = 'enableQuickFav',
      enableWordRe = 'enableWordRe',
      enableSearchWord = 'enableSearchWord',
      enableSystemProxy = 'enableSystemProxy',
      enableAi = 'enableAi',
      disableLikeMsg = 'disableLikeMsg',
      defaultHomePage = 'defaultHomePage',

      // 弹幕相关设置 权重（云屏蔽） 屏蔽类型 显示区域 透明度 字体大小 弹幕时间 描边粗细 字体粗细 海量模式
      danmakuWeight = 'danmakuWeight',
      danmakuBlockType = 'danmakuBlockType',
      danmakuShowArea = 'danmakuShowArea',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontScale = 'danmakuFontScale',
      danmakuDuration = 'danmakuDuration',
      strokeWidth = 'strokeWidth',
      fontWeight = 'fontWeight',
      danmakuMassiveMode = 'danmakuMassiveMode',
      convertToScrollDanmaku = 'convertToScrollDanmaku',

      // 代理host port
      systemProxyHost = 'systemProxyHost',
      systemProxyPort = 'systemProxyPort';

  /// 外观
  static const String themeMode = 'themeMode',
      defaultTextScale = 'textScale',
      dynamicColor = 'dynamicColor', // bool
      customColor = 'customColor', // 自定义主题色
      schemeVariant = 'schemeVariant',
      enableSingleRow = 'enableSingleRow', // 首页单列
      displayMode = 'displayMode',
      maxRowWidth = 'maxRowWidth', // 首页列最大宽度（dp）
      videoPlayerRemoveSafeArea = 'videoPlayerRemoveSafeArea', // 视频播放器移除安全边距
      videoPlayerShowStatusBarBackgroundColor =
          'videoPlayerShowStatusBarBackgroundColor', // 播放页状态栏显示为背景色
      dynamicsWaterfallFlow = 'dynamicsWaterfallFlow', // 动态瀑布流
      upPanelPosition = 'upPanelPosition', // up主面板位置
      dynamicsShowAllFollowedUp = 'dynamicsShowAllFollowedUp', // 动态显示全部关注up
      // useSideBar = 'useSideBar',
      sideBarPosition = 'sideBarPosition',
      enableMYBar = 'enableMYBar',
      hideSearchBar = 'hideSearchBar', // 收起顶栏
      hideTabBar = 'hideTabBar', // 收起底栏
      tabbarSort = 'tabbarSort', // 首页tabbar
      dynamicBadgeMode = 'dynamicBadgeMode',
      hiddenSettingUnlocked = 'hiddenSettingUnlocked',
      enableGradientBg = 'enableGradientBg';
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause',

      // access_key
      accessKey = 'accessKey',

      //
      wbiKeys = 'wbiKeys',
      timeStamp = 'timeStamp';
}

class VideoBoxKey {
  // 视频比例
  static const String videoFit = 'videoFit',
      // 亮度
      // videoBrightness = 'videoBrightness',
      // 倍速
      videoSpeed = 'videoSpeed',
      // 播放顺序
      playRepeat = 'playRepeat',
      // 默认倍速
      playSpeedDefault = 'playSpeedDefault',
      // 默认长按倍速
      longPressSpeedDefault = 'longPressSpeedDefault',
      // 自定义倍速集合
      customSpeedsList = 'customSpeedsList',
      // 画面填充比例
      cacheVideoFit = 'cacheVideoFit',
      // 字幕字体大小
      subtitleFontSize = 'subtitleFontSize',
      // 字幕距底边距
      subtitleBottomPadding = 'subtitleBottomPadding';
}

class OnlineCacheKey {
  static const String
      // 隐私设置-黑名单管理
      blackMidsList = 'blackMidsList',
      // 弹幕屏蔽规则
      danmakuFilterRule = 'danmakuFilterRule';
}
