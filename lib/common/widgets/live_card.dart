import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/utils/utils.dart';

class LiveCard extends StatelessWidget {
  var liveItem;

  LiveCard({
    Key? key,
    required this.liveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(liveItem.roomid);

    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                double maxWidth = boxConstraints.maxWidth;
                double maxHeight = boxConstraints.maxHeight;
                double PR = MediaQuery.of(context).devicePixelRatio;
                return Stack(
                  children: [
                    Hero(
                      tag: heroTag,
                      child: NetworkImgLayer(
                        // 指定图片尺寸
                        // src: videoItem.pic + '@${(maxWidth * 2).toInt()}w',
                        src: liveItem.cover + '@.webp',
                        type: 'emote',
                        width: maxWidth,
                        height: maxHeight,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 200),
                        child: LiveStat(
                          // view: liveItem.stat.view,
                          // danmaku: liveItem.stat.danmaku,
                          // duration: liveItem.duration,
                          online: liveItem.online,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            LiveContent(liveItem: liveItem)
          ],
        ),
      ),
    );
  }
}

class LiveContent extends StatelessWidget {
  final liveItem;
  const LiveContent({Key? key, required this.liveItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      // 多列
      padding: const EdgeInsets.fromLTRB(8, 8, 6, 7),
      // 单列
      // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            liveItem.title,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            maxLines: Get.find<HomeController>().crossAxisCount,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              liveItem.uname,
              maxLines: 1,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStat extends StatelessWidget {
  final int? online;

  const LiveStat({Key? key, required this.online}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(top: 22, left: 8, right: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // StatView(
              //   theme: 'white',
              //   view: view,
              // ),
              // const SizedBox(width: 8),
              // StatDanMu(
              //   theme: 'white',
              //   danmu: danmaku,
              // ),
            ],
          ),
          Text(
            online.toString(),
            style: const TextStyle(fontSize: 11, color: Colors.white),
          )
        ],
      ),
    );
  }
}