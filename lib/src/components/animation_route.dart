import 'package:flutter/cupertino.dart';

class AnimatingRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget? router;

  AnimatingRoute({this.page, this.router})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page!,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation,
                  child: router,
                ));
}
