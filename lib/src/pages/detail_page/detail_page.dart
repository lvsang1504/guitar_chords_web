import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guitar_chords_web/src/components/components.dart';
import 'package:guitar_chords_web/src/components/load_asset.dart';
import 'package:guitar_chords_web/src/models/lyric.dart';
import 'package:guitar_chords_web/src/pages/detail_page/component/card_guide.dart';
import 'package:guitar_chords_web/src/pages/detail_page/component/display_item.dart';
import 'component/regex_text_highlight.dart';

const int maxFailedLoadAttempts = 3;

class DetailPage extends StatefulWidget {
  final Lyric lyric;

  DetailPage({
    Key? key,
    required this.lyric,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  Lyric? lyric;
  RegExp regex = RegExp(r'/(\[[A-G].*?\])/');
  Future<void>? _launched;

  OptionChord display = OptionChord.vertical;

  late int option = 1;

  double ratingLyric = 0;
  late ChangeTone changeTone = ChangeTone.origin;
  final ScrollController _scrollController = ScrollController();
  bool scroll = false;
  int speedFactor = 10;
  bool isOpenAutoScroll = false;
  late AnimationController animationController;

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent - 100,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    lyric = widget.lyric;
    lyric!.content = lyric!.content.replaceAll("'", "\'");
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String colum1 = "";
    String colum2 = "";
    String lyricString = lyric!.contentChangeTone == ""
        ? lyric!.content
        : lyric!.contentChangeTone;
    if (lyric!.content.length > 1000) {
      lyricString.indexOf('\n', 1000);
      colum1 = lyricString.substring(0, lyricString.indexOf('\n', 1000));
      colum2 = lyricString.substring(lyricString.indexOf('\n', 1000));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: buildFloatingButton(),
      body: Stack(
        children: [
          NotificationListener(
            onNotification: (notif) {
              if (notif is ScrollEndNotification && scroll) {
                Timer(const Duration(seconds: 1), () {
                  _scroll();
                });
              }
              return true;
            },
            child: ListView(
              controller: _scrollController,
              children: [
                MenuBar(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Text(
                          lyric!.title,
                          style: headlineTextStyle,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Text(
                          lyric!.singer,
                          style: bodyTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            " Tông chuẩn: [${lyric!.tone}]",
                            style: bodyTextStyle,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${lyric!.beat}",
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    lyric!.guide!.isNotEmpty
                        ? CardGuide(
                            guide: lyric!.guide,
                          )
                        : const SizedBox(),
                    Divider(
                      height: 4,
                      color: Colors.grey,
                    ),
                    colum2.isEmpty || lyricString.length > 2000
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: SizedBox(
                                width: 400,
                                child: RegexTextHighlight(
                                  option: display,
                                  text: formatContent(lyricString),
                                  highlightRegex: RegExp(r'\[[A-G].*?\]'),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: RegexTextHighlight(
                                    option: display,
                                    text: formatContent(colum1),
                                    highlightRegex: RegExp(r'\[[A-G].*?\]'),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: RegexTextHighlight(
                                    option: display,
                                    text: formatContent(colum2),
                                    highlightRegex: RegExp(r'\[[A-G].*?\]'),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
                Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildFloatingButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _showModalBottomSheetDisplay(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.font_download_sharp,
                  size: 18,
                  color: Colors.black,
                ),
                Text(
                  "Hiển thị",
                  style: bodyTextStyle,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _toggleScrolling(),
            child: Icon(
              !scroll ? Icons.play_circle : Icons.pause_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => onChangeToneUp(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "+",
                    style: headlineSecondaryTextStyle.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onResetTone(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.restore,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onChangeToneDown(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "-",
                    style: headlineSecondaryTextStyle.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showModalBottomSheetDisplay(BuildContext context) async {
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        elevation: 10,
        backgroundColor: Color(0xFFEDF0F2),
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Divider(
                    height: 3,
                  ),
                  DisplayItem(
                    title: "Hiện hợp âm theo chiều dọc",
                    icon: Icons.slideshow,
                    onTap: () async {
                      setState(() {
                        display = OptionChord.vertical;
                        option = 1;
                        Navigator.pop(context);
                      });
                    },
                    isSelected: option == 1,
                  ),
                  const Divider(
                    height: 3,
                  ),
                  DisplayItem(
                    title: "Hiện hợp âm theo chiều ngang",
                    icon: Icons.slideshow,
                    onTap: () async {
                      setState(() {
                        display = OptionChord.horizontal;
                        option = 2;
                        Navigator.pop(context);
                      });
                    },
                    isSelected: option == 2,
                  ),
                  const Divider(
                    height: 3,
                  ),
                  DisplayItem(
                    title: "Ẩn hợp âm",
                    icon: Icons.slideshow,
                    onTap: () async {
                      setState(() {
                        display = OptionChord.hide;
                        option = 3;
                        Navigator.pop(context);
                      });
                    },
                    isSelected: option == 3,
                  ),
                  const Divider(
                    height: 3,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  String formatContent(String? content) {
    content = content!.replaceAll(('\n'), ' \n');
    content = content.replaceAll(r"''", "'");

    return content;
  }

  Future<String> changeToneLyric(String lyric, ChangeTone changeTone) async {
    int start = 0;
    while (true) {
      String? highlight =
          RegExp(r'\[[A-G].*?\]').stringMatch(lyric.substring(start));
      if (highlight == null) {
        break;
      }

      final int indexOfHighlight = lyric.indexOf(highlight, start);
      String toneChange = highlight;
      if (changeTone == ChangeTone.up) {
        final chordMap =
            await parseJsonFromAssets("chords/change_chords_up.json");
        if (chordMap[highlight] != null) {
          String chords = chordMap[highlight];
          toneChange = chords;
        }
      } else if (changeTone == ChangeTone.down) {
        final chordMap =
            await parseJsonFromAssets("chords/change_chords_down.json");
        if (chordMap[highlight] != null) {
          String chords = chordMap[highlight];
          toneChange = chords;
        }
      }

      lyric = lyric.replaceFirst(highlight, toneChange, indexOfHighlight);

      if (indexOfHighlight == start) {
        start += toneChange.length;
      } else {
        start = indexOfHighlight + toneChange.length;
      }
    }
    return lyric;
  }

  onChangeToneUp() async {
    changeTone = ChangeTone.up;

    lyric!.contentChangeTone = await changeToneLyric(
        lyric!.contentChangeTone == ""
            ? lyric!.content
            : lyric!.contentChangeTone,
        changeTone);
    // await DbHelper.instance.updateToneUser(lyric!);
    setState(() {});
    // changeTone = ChangeTone.origin;
  }

  onChangeToneDown() async {
    changeTone = ChangeTone.down;

    lyric!.contentChangeTone = await changeToneLyric(
        lyric!.contentChangeTone == ""
            ? lyric!.content
            : lyric!.contentChangeTone,
        changeTone);
    //await DbHelper.instance.updateToneUser(lyric!);
    setState(() {});
  }

  onResetTone() async {
    changeTone = ChangeTone.origin;
    lyric!.contentChangeTone =
        await changeToneLyric(lyric!.content, changeTone);
    setState(() {});
  }
}
