import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guitar_chords_web/src/components/typography.dart';
import 'package:guitar_chords_web/src/models/lyric.dart';

class GenreCard extends StatefulWidget {
  final int index;
  final bool isRank;
  final Lyric lyric;
  final List<int> songs;
  final Function function;
  const GenreCard(
      {Key? key,
      this.isRank = false,
      required this.index,
      required this.lyric,
      required this.songs,
      required this.function})
      : super(key: key);

  @override
  _GenreCardState createState() => _GenreCardState();
}

class _GenreCardState extends State<GenreCard> {
  String formatContent(String? content) {
    content = content!.replaceAll(('\n'), ' ');
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return buildGenre();
  }

  Widget buildGenre() {
    return GestureDetector(
      onTap: () {
        widget.function();
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.index < 3 && widget.isRank
                  ? Colors.red
                  : Colors.transparent,
            )),
        color: Color(0xFFEDF0F2),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.index + 1}",
                style: widget.index < 3 && widget.isRank
                    ? headlineSecondaryTextStyle.copyWith(
                        color: Colors.red,
                        shadows: [
                          BoxShadow(
                              color: Colors.red[500]!,
                              offset: const Offset(4, 4),
                              blurRadius: 15.0,
                              spreadRadius: 1),
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 15.0,
                              spreadRadius: 1),
                        ],
                      )
                    : titleTextStyle.copyWith(fontSize: 18),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.lyric.title,
                              style: titleTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.lyric.singer,
                        style: bodyTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text(
                        formatContent(widget.lyric.content),
                        style: subtitleTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
