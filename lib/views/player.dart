import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_app/consts/colors.dart';
import 'package:music_player_app/consts/text_style.dart';
import 'package:music_player_app/controllers/player_controller.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;

  const Player({Key? key, required this.data}) : super(key: key);

  Future setRingtone(String filePath, BuildContext context) async {
    const platform = MethodChannel('abhi');
    try {
      await platform.invokeMethod('setRingtone', {'filePath': filePath,'mimeType': 'audio/x-wav'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ringtone set successfully!')),
      );
    } on PlatformException catch (e) {
      print("Failed to set ringtone: '${e.message}'.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to SetRingtone')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    void showRingtoneConfirmationDialog(String filePath) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Set as Ringtone'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Do you want to set this song as your ringtone?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Set as Ringtone'),
                onPressed: () {
                  setRingtone(filePath,context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              String? filePath = data[controller.playIndex.value].uri;
              showRingtoneConfirmationDialog(filePath!);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: Icon(
                    Icons.music_note,
                    size: 48,
                    color: whiteColor,
                  ),
                ),
              ),
            )),
            SizedBox(height: 13),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Obx(
                      () => Column(
                    children: [
                      Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: bold,
                          size: 14,
                        ),
                      ),
                      SizedBox(height: 13),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: regular,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 13),
                      Obx(
                            () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: slideColor,
                                inactiveColor: bgColor,
                                activeColor: slideColor,
                                min: Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(newValue.toInt());
                                  newValue = newValue;
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 13),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.playSong(data[controller.playIndex.value - 1].uri, controller.playIndex.value - 1);
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: bgDarkColor,
                            ),
                          ),
                          Obx(
                                () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgColor,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  onPressed: () {
                                    if (controller.isPlaying.value) {
                                      controller.audioPlayer.pause();
                                      controller.isPlaying(false);
                                    } else {
                                      controller.audioPlayer.play();
                                      controller.isPlaying(true);
                                    }
                                  },
                                  icon: controller.isPlaying.value
                                      ? Icon(
                                    Icons.pause,
                                    color: whiteColor,
                                  )
                                      : Icon(
                                    Icons.play_arrow_rounded,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.playSong(data[controller.playIndex.value + 1].uri, controller.playIndex.value + 1);
                            },
                            icon: Icon(Icons.skip_next_rounded, size: 40, color: bgDarkColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
