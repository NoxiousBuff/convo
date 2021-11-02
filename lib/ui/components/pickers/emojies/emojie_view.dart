import 'dart:io';
import 'emojie_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/constants/emojies.dart';
import 'package:hint/services/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EmojiesView extends StatelessWidget {

  EmojiesView({Key? key, })
      : super(key: key);

  final ChatService chatService = ChatService();
  final hiveBoxName = HiveApi.hiveBoxEmojies;
  final delegate =
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4);

  Widget tabEmoji(String memoji) {
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
    required EmojieViewModel model,
    required void Function() onPressed,
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
            : const CircularProgressIndicator(
                backgroundColor: systemBackground),
      ),
    );
  }

  bool hiveBool(String key) => Hive.box(hiveBoxName).containsKey(key);

  Widget emojiGrid({
    required String key,
    required int itemCount,
    required List<String> emojies,
    required EmojieViewModel model,
  }) {
    return GridView.builder(
      itemCount: itemCount,
      gridDelegate: delegate,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        return Consumer(
          builder: (context, watch, child) {
            //final valuePod = watch(getValueProvider);
            return GestureDetector(
              onTap: () async {
                if (!model.isContain(emojies[i])) {
                  model.addToRecentEmojies(emojies[i], key);
                } else {
                  getLogger('EmojieView').wtf('emojie already added in recent');
                }
                // await chatService.addMessage(
                //   type: emojiType,
                //   context: context,
                //   urlsType: ['image'],
                //   urlsList: [emojies[i]],
                //   receiverUid: receiverUid,
                // );
                // hiveApi.saveInHive(hiveBoxName, key, emojies[i]);
                // final name = DateTime.now().microsecondsSinceEpoch;
                // final downloadUrl = await viewModel.uploadAndProgress(
                //     filePath: emojies[i], folderName: 'images/IMG-$name.jpeg');
                // await viewModel.updateAProperty(
                //   messageUid: valuePod.messageUid!,
                //   data: {
                //     "urlsList": [downloadUrl]
                //   },
                // );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Image.file(File(emojies[i])),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String recentKey = 'recentKey';
    String smileyKey = 'smileyKey';
    String blackKey = 'blackEmojies';
    String emoji3DKey = 'emoji3DKey';
    String whiteKey = 'whiteEmojiesKey';
    String kolabangaKey = 'kolabangaKey';

    return ViewModelBuilder<EmojieViewModel>.reactive(
      viewModelBuilder: () => EmojieViewModel(),
      onModelReady: (model) {
        final recentList = Hive.box(hiveBoxName).get(recentKey);
        if (recentList != null) {
          model.getRecentEmojies(recentList);
        }

        model.getRecentHive(hiveBool(recentKey));
        model.changeBlackDownloading(false);
        model.changeKolabangaDownloading(false);
        model.changeWhiteDownloading(false);
        model.change3DEmojieDownloading(false);
        model.changeSmileyDownloading(false);

        model.changeBlackHive(hiveBool(blackKey));
        model.changeKolabangaHive(hiveBool(kolabangaKey));
        model.changeWhiteHive(hiveBool(whiteKey));
        model.change3DEmojieHive(hiveBool(emoji3DKey));
        model.change3DEmojieHive(hiveBool(smileyKey));

        if (model.containRecent) {
          final recents = Hive.box(hiveBoxName).get(recentKey);
          model.getRecentEmojies(recents);
        }

        if (model.containBlackEmojie) {
          final emojies = Hive.box(hiveBoxName).get(blackKey);
          model.getBlackHive(emojies);
        } else {
          getLogger('BlackEmojies').wtf("blackEmojies does not save in hive");
        }
        if (model.containKolabanga) {
          final hiveKolabangas = Hive.box(hiveBoxName).get(kolabangaKey);
          model.getKolabangaHive(hiveKolabangas);
        }
        if (model.containWhiteEmojies) {
          final whiteEmojies = Hive.box(hiveBoxName).get(whiteKey);
          model.getKolabangaHive(whiteEmojies);
        }
        if (model.contain3DEmoji) {
          final emojies3D = Hive.box(hiveBoxName).get(emoji3DKey);
          model.get3DHive(emojies3D);
        }
        if (model.containSmiley) {
          final smilies = Hive.box(hiveBoxName).get(smileyKey);
          model.get3DHive(smilies);
        }
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 6,
          child: Column(
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
                  tabEmoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/emojies%2FblackEmojies%2Femoji01.webp?alt=media&token=30ba4af0-8354-45a0-a8cb-3a345d02e5f4'),
                  tabEmoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/emojies%2Fkolabanga%2Fkolabanga%20(10).webp?alt=media&token=c84a6eed-386e-43ea-81f7-d99388f2ca79'),
                  tabEmoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/emojies%2FwhiteEmojies%2FwhiteEmoji%20(01).webp?alt=media&token=130893ae-7894-462f-883f-4db176160702'),
                  tabEmoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/emojies%2F3dEmojies%2Femoji%20(01).webp?alt=media&token=353da77b-9249-41a5-bfe9-10a39ba8aec5'),
                  tabEmoji(
                      'https://firebasestorage.googleapis.com/v0/b/octa-chat-223d4.appspot.com/o/emojies%2Fsmiley%2Fsmiley%20(01).webp?alt=media&token=2ca51b3d-2493-4206-87fa-5d42dc48ee49'),
                ],
              ),
              Flexible(
                child: Consumer(
                  builder: (_, reader, __) {
                    return TabBarView(
                      children: [
                        model.containRecent
                            ? emojiGrid(
                                model: model,
                                key: recentKey,
                                emojies: model.recentEmojies,
                                itemCount: model.recentEmojies.length)
                            : const SizedBox.shrink(),
                        model.containBlackEmojie
                            ? emojiGrid(
                                model: model,
                                key: blackKey,
                                emojies: model.blackEmojies,
                                itemCount: model.blackEmojies.length)
                            : downloadingButton(
                                model: model,
                                hiveKey: blackKey,
                                packName: 'BlackEmoji',
                                isDownloading: model.isBlackEmojieDownloading,
                                onPressed: () async {
                                  await model.downloadBlackEmojies(
                                    key: blackKey,
                                    emojiesList: blackEmoji,
                                    emojiFolder: "Black-Emojies",
                                  );
                                  model.changeBlackHive(true);
                                },
                              ),
                        model.containKolabanga
                            ? emojiGrid(
                                model: model,
                                key: kolabangaKey,
                                emojies: model.kolabangaEmojies,
                                itemCount: model.kolabangaEmojies.length)
                            : downloadingButton(
                                model: model,
                                hiveKey: kolabangaKey,
                                packName: 'Kolabanga',
                                isDownloading: model.isKolabangaDownloading,
                                onPressed: () async {
                                  await model.downloadKolabanga(
                                      key: kolabangaKey,
                                      emojiFolder: 'Kolabanga',
                                      emojiesList: kolabanga);
                                  model.changeKolabangaHive(true);
                                },
                              ),
                        model.containWhiteEmojies
                            ? emojiGrid(
                                model: model,
                                key: whiteKey,
                                emojies: model.whiteEmojies,
                                itemCount: model.whiteEmojies.length)
                            : downloadingButton(
                                model: model,
                                hiveKey: whiteKey,
                                packName: 'WhiteEmojies',
                                isDownloading: model.isWhiteDownloading,
                                onPressed: () async {
                                  await model.downloadWhiteEmojies(
                                      key: whiteKey,
                                      emojiFolder: 'White-Emojies',
                                      emojiesList: whiteEmoji);
                                  model.changeWhiteHive(true);
                                },
                              ),
                        model.contain3DEmoji
                            ? emojiGrid(
                                model: model,
                                key: emoji3DKey,
                                emojies: model.emojies3D,
                                itemCount: model.emojies3D.length)
                            : downloadingButton(
                                model: model,
                                hiveKey: emoji3DKey,
                                packName: 'Emojies',
                                isDownloading: model.is3DEmojieDownloading,
                                onPressed: () async {
                                  await model.download3DEmojies(
                                      key: emoji3DKey,
                                      emojiFolder: 'Emojies',
                                      emojiesList: emoji3D);
                                  model.change3DEmojieHive(true);
                                },
                              ),
                        model.containSmiley
                            ? emojiGrid(
                                model: model,
                                key: smileyKey,
                                emojies: model.smilies,
                                itemCount: model.smilies.length)
                            : downloadingButton(
                                model: model,
                                hiveKey: smileyKey,
                                packName: 'Smilies',
                                isDownloading: model.isSmileyDownloading,
                                onPressed: () async {
                                  await model.downloadSmilies(
                                      key: smileyKey,
                                      emojiesList: smiley,
                                      emojiFolder: 'Smilies');
                                  model.changeSmileyHive(true);
                                },
                              ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
