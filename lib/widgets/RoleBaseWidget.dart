import 'package:flutter/cupertino.dart';

class RoleBasedWidget extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const RoleBasedWidget({Key? key, required this.child, required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: child,
    );
  }
}