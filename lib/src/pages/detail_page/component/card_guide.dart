import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:guitar_chords_web/src/components/components.dart';
import 'package:guitar_chords_web/src/components/expand_widget.dart';

class CardGuide extends StatelessWidget {
  final String? guide;
  CardGuide({
    Key? key,
    required this.guide,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        children: <Widget>[
          ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: false,
            ),
            header: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ExpandableIcon(
                      theme: const ExpandableThemeData(
                        expandIcon: Icons.arrow_right_outlined,
                        collapseIcon: Icons.arrow_drop_down,
                        iconColor: Colors.black,
                        iconSize: 28.0,
                        iconRotationAngle: math.pi / 2,
                        iconPadding: EdgeInsets.only(right: 5),
                        hasIcon: false,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Hướng dẫn",
                        style: bodyTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            collapsed: Container(),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Text(
                guide!,
                style: bodyTextStyle,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
