import 'package:flutter/material.dart';

import '../../theme/theme.dart';

dynamic getPrimaryColor(context) {
  return colorThemeData['primaryColor'];
}

dynamic getSecondaryColor(context) {
  return Theme.of(context).selectedRowColor;
}

dynamic getDeviceWidth(context) {
  return MediaQuery.of(context).size.width;
}

dynamic getDeviceHeight(context) {
  return MediaQuery.of(context).size.height;
}

dynamic getPadding(
    {@required context, top = 0.0, right = 0.0, bottom = 0.0, left = 0.0}) {
  return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}

dynamic getPaddingAllSide({@required context, value = 0.0}) {
  return EdgeInsets.all(value);
}

var defaultIconStyle = {
  "size": 32.0,
  "color": colorThemeData['iconPrimaryColor']
};

var defaultTextFieldStyle = {};
