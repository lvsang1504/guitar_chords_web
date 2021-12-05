import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guitar_chords_web/src/components/animation_route.dart';
import 'package:guitar_chords_web/src/components/loading_widget.dart';
import 'package:guitar_chords_web/src/components/menu.dart';
import 'package:guitar_chords_web/src/components/text.dart';
import 'package:guitar_chords_web/src/components/typography.dart';
import 'package:guitar_chords_web/src/controller/lyric_contronler.dart';
import 'package:guitar_chords_web/src/models/lyric.dart';
import 'package:guitar_chords_web/src/pages/detail_page/detail_page.dart';
import 'package:guitar_chords_web/src/pages/genre_page/component/genre_card.dart';

const String listItemTitleText = "A BETTER BLOG FOR WRITING";
const String listItemPreviewText =
    "Sed elementum tempus egestas sed sed risus. Mauris in aliquam sem fringilla ut morbi tincidunt. Placerat vestibulum lectus mauris ultrices eros. Et leo duis ut diam. Auctor neque vitae tempus […]";

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: <Widget>[
                  MenuBar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hot trong tuần",
                      style: bodyTextStyle,
                    ),
                  ),
                  FutureBuilder<List<Lyric>>(
                      future: LyricController().getLyric(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: 1000,
                            child: LoadingListPage(),
                          );
                        }
                        List<Lyric> lyrics = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: lyrics.length,
                          itemBuilder: (context, int index) {
                            return GenreCard(
                              function: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(lyric: lyrics[index])))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              index: index,
                              lyric: lyrics[index],
                              isRank: true,
                              songs: [],
                            );
                          },
                        );
                      }),
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
