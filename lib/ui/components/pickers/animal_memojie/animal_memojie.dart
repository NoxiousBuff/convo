import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'animalmemojie_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_memojis.dart';
import 'package:hint/services/chat_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AnimalMemoji extends StatelessWidget {

  AnimalMemoji({Key? key, }) : super(key: key);

  final hiveBox = HiveApi.hiveBoxEmojies;
  final ChatService chatService = ChatService();
  final delegate = const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4);

  Widget tabMemoji(String memoji) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CachedNetworkImage(
        imageUrl: memoji,
        height: 30,
        width: 30,
      ),
    );
  }

  Widget downloadingButton({
    required String hiveKey,
    required String packName,
    required bool isDownloading,
    required MemojiViewModel model,
    required void Function()? onPressed,
  }) {
    return Center(
      child: CupertinoButton(
        color: activeBlue,
        onPressed: onPressed,
        child: !isDownloading
            ? Text(
                'Download $packName Pack',
                style: const TextStyle(color: systemBackground),
              )
            : const CircularProgressIndicator(backgroundColor: systemBackground),
      ),
    );
  }

  Widget memojiGrid({
    required MemojiViewModel model,
    required String hiveKey,
    required List<String> memojies,
    required int itemCount,
  }) {
    return Consumer(
      builder: (context, watch, child) {
        //final value = context.read(getValueProvider);
        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: delegate,
          padding: EdgeInsets.zero,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  if (!model.isRecentContain(memojies[i])) {
                    model.addToRecent(memojies[i], hiveKey);
                  }
                  // await chatService.addMessage(
                  //     type: emojiType,
                  //     context: context,
                  //     urlsType: ['image'],
                  //     urlsList: [memojies[i]],
                  //     receiverUid: receiverUid);
                  // await hiveApi.saveInHive(hiveBox, hiveKey, memojies[i]);
                  // final name = DateTime.now().microsecondsSinceEpoch;
                  // final downloadUrl = await viewModel.uploadAndProgress(
                  //     filePath: memojies[i],
                  //     folderName: 'images/IMG-$name.jpeg');
                  // await viewModel.updateAProperty(
                  //   messageUid: value.messageUid!,
                  //   data: {
                  //     "urlsList": [downloadUrl]
                  //   },
                  // );
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Image.file(File(memojies[i])),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool hiveBool(String key) => Hive.box(hiveBox).containsKey(key);
  @override
  Widget build(BuildContext context) {
    const boarKey = 'boarKey';
    const pandaKey = 'pandaKey';
    const monkeyKey = 'monkayKey';
    const unicornKey = 'unicornKey';
    const recentKey = 'memojieRecent';
    return ViewModelBuilder<MemojiViewModel>.reactive(
      viewModelBuilder: () => MemojiViewModel(),
      onModelReady: (model) {
        final recentList = Hive.box(hiveBox).get(recentKey);
        if (recentList != null) {
          model.getRecentMemojies(recentList);
        }
        model.changePandaDownloading(false);
        model.changeMonkeyDownloading(false);
        model.changeBoarDownloading(false);
        model.changeUnicornDownloading(false);

        model.changePandaHive(hiveBool(pandaKey));
        model.changeMonkeyHive(hiveBool(monkeyKey));
        model.changeBoarHive(hiveBool(boarKey));
        model.changeUnicornHive(hiveBool(unicornKey));

        if (model.containRecent) {
          final recent = Hive.box(hiveBox).get(recentKey);
          model.getRecentMemojies(recent);
        }

        if (model.containPanda) {
          List<String> pandaList = Hive.box(hiveBox).get(pandaKey);
          model.getPandaHive(pandaList);
        }
        if (model.containMonkey) {
          final monkeyList = Hive.box(hiveBox).get(monkeyKey);
          model.getMonkeyHive(monkeyList);
        }
        if (model.containBoar) {
          final boarList = Hive.box(hiveBox).get(boarKey);
          model.getBoarHive(boarList);
        }
        if (model.containUnicorn) {
          final unicornList = Hive.box(hiveBox).get(unicornKey);
          model.getUnicornHive(unicornList);
        }
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
                indicatorWeight: 2.0,
                indicatorColor: inactiveGray,
                unselectedLabelColor: inactiveGray,
                automaticIndicatorColorAdjustment: true,
                tabs: [
                  IconButton(
                    icon: const Icon(
                      Icons.restore,
                      size: 20,
                      color: inactiveGray,
                    ),
                    onPressed: () {},
                  ),
                  tabMemoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/memojies%2FPanda%2Fpanda01.webp?alt=media&token=be8186a3-2442-4980-9b28-e298fbe55353'),
                  tabMemoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/memojies%2FMonkey%2Fmemoji31.webp?alt=media&token=0c24d9c5-07bf-491b-be72-b529034a1994'),
                  tabMemoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/memojies%2FBoar%2Fboar01.webp?alt=media&token=86418133-070a-4483-ba96-1e1869748d5a'),
                  tabMemoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/memojies%2FUnicorn%2Funicorn01.webp?alt=media&token=4f943d95-b9da-4f01-9096-2760a51cfc61'),
                ],
              ),
              Flexible(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    model.containRecent
                        ? memojiGrid(
                            model: model,
                            hiveKey: recentKey,
                            memojies: model.recents,
                            itemCount: model.recents.length)
                        : const SizedBox.shrink(),
                    model.containPanda
                        ? memojiGrid(
                            model: model,
                            hiveKey: pandaKey,
                            memojies: model.pandaList,
                            itemCount: model.pandaList.length)
                        : downloadingButton(
                            model: model,
                            packName: 'Panda',
                            hiveKey: pandaKey,
                            isDownloading: model.isPandaDownloading,
                            onPressed: () async {
                              await model.downloadPanda(
                                  key: pandaKey,
                                  emojiesList: panda,
                                  emojiFolder: 'Panda');
                              model.changePandaHive(true);
                            }),
                    model.containMonkey
                        ? memojiGrid(
                            model: model,
                            hiveKey: monkeyKey,
                            memojies: model.monkeyList,
                            itemCount: model.monkeyList.length)
                        : downloadingButton(
                            hiveKey: monkeyKey,
                            packName: 'Monkey',
                            isDownloading: model.isMonkeyDownloading,
                            model: model,
                            onPressed: () async {
                              await model.downloadMonkeys(
                                  key: monkeyKey,
                                  emojiFolder: 'Monkey',
                                  emojiesList: monkeyList);
                              model.changeMonkeyHive(true);
                            }),
                    model.containBoar
                        ? memojiGrid(
                            model: model,
                            hiveKey: boarKey,
                            memojies: model.boarList,
                            itemCount: model.boarList.length)
                        : downloadingButton(
                            hiveKey: boarKey,
                            packName: 'Boar',
                            isDownloading: model.isBoarDownloading,
                            model: model,
                            onPressed: () async {
                              await model.downloadBoar(
                                  key: boarKey,
                                  emojiFolder: 'Boar',
                                  emojiesList: wildBoar);
                              model.changeBoarHive(true);
                            }),
                    model.containUnicorn
                        ? memojiGrid(
                            model: model,
                            hiveKey: unicornKey,
                            memojies: model.unicornList,
                            itemCount: model.unicornList.length)
                        : downloadingButton(
                            hiveKey: unicornKey,
                            packName: 'Unicorn',
                            isDownloading: model.isUnicornDownloading,
                            model: model,
                            onPressed: () async {
                              await model.downloadUnicorn(
                                  key: unicornKey,
                                  emojiFolder: 'Unicorn',
                                  emojiesList: unicorn);
                              model.changeUnicornHive(true);
                            }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
