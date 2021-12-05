import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:guitar_chords_web/src/components/components.dart';
import 'package:guitar_chords_web/src/components/load_asset.dart';
import 'package:guitar_chords_web/src/components/tap_guitar.dart';

enum OptionChord { vertical, horizontal, hide }
enum ChangeTone { up, down, origin }

class RegexTextHighlight extends StatelessWidget {
  String? text;
  final RegExp? highlightRegex;
  final TextStyle? nonHighlightStyle;
  final OptionChord option;

  RegexTextHighlight({
    @required this.text,
    @required this.highlightRegex,
    this.nonHighlightStyle,
    this.option = OptionChord.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) {
      return const Text("");
    }

    List<TextSpan> spans = [];
    int start = 0;
    while (true) {
      String? highlight = highlightRegex!.stringMatch(text!.substring(start));
      if (highlight == null) {
        // no highlight
        spans.add(_normalSpan(text!.substring(start)));
        break;
      }

      final int indexOfHighlight = text!.indexOf(highlight, start);

      if (option == OptionChord.vertical) {
        final String? remain =
            text!.substring(indexOfHighlight + highlight.length);
        final List<String> list = remain!.split(RegExp(r"[ .,]"));
        final String? nextWord = list.first;

        if (indexOfHighlight == start && nextWord != " ") {
          spans.add(_formatLyricSpan(nextWord!, highlight, context));
          start += highlight.length + nextWord.length;
        } else {
          spans.add(_normalSpan(text!.substring(start, indexOfHighlight)));
          spans.add(_formatLyricSpan(nextWord!, highlight, context));
          start = indexOfHighlight + highlight.length + nextWord.length;
        }
      } else if (option == OptionChord.horizontal) {
        if (indexOfHighlight == start) {
          // starts with highlight
          spans.add(_highlightSpan(highlight, context));
          start += highlight.length;
        } else {
          // normal + highlight
          spans.add(_normalSpan(text!.substring(start, indexOfHighlight)));
          spans.add(_highlightSpan(highlight, context));
          start = indexOfHighlight + highlight.length;
        }
      } else if (option == OptionChord.hide) {
        if (indexOfHighlight == start) {
          start += highlight.length;
        } else {
          // normal + highlight
          spans.add(_normalSpan(text!.substring(start, indexOfHighlight)));
          //spans.add(_highlightSpan(highlight));
          start = indexOfHighlight + highlight.length;
        }
      }
    }

    return RichText(
      text: TextSpan(
        style: bodyTextStyle,
        children: spans,
      ),
    );
  }

  TextSpan _formatLyricSpan(String next, String chord, BuildContext context) {
    String sub = chord.substring(1, chord.length - 1);
    return TextSpan(style: bodyTextStyle, children: [
      WidgetSpan(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _buildTabGuitar(context, sub),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(sub,
                    style: bodyTextStyle.copyWith(
                      color: Colors.redAccent,
                    )),
              ),
            ),
            Text(
              next,
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
      // TextSpan(text: next),
    ]);
  }

  TextSpan _highlightSpan(String content, BuildContext context) {
    String sub = content.substring(1, content.length - 1);
    return TextSpan(
      text: content,
      style: bodyTextStyle.copyWith(
        color: Colors.redAccent,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () => _buildTabGuitar(context, sub),
    );
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content);
  }

  _buildTabGuitar(BuildContext context, String chord) async {
    final chordMap = await parseJsonFromAssets("chords/chord.json");

    List<String> chords;
    if (chordMap[chord] != null) {
      chords = (chordMap[chord] as List).map((e) => e as String).toList();
    } else {
      chords = ["0 0 0 0 0 0"];
    }

    return showAnimatedDialog(
        barrierColor: Colors.white70,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              width: 200,
              height: 250,
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: ListBody(
                    children: <Widget>[
                      Column(
                        children: [
                          TabWidget(
                            name: chord,
                            tabs: chords,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ),
          );
        },
        animationType: DialogTransitionType.size,
        curve: Curves.linear);
  }
}
