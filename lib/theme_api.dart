import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class ThemeApi {
  static Future<Color> fetchThemeColor() async {
    final response = await http.get(
      Uri.parse('${Config.BASE_URL}/api/appsettings/getAllAppSettings.php'),
    );

    if (response.statusCode == 200) {
      final settings = json.decode(response.body);
      print("response.body:"+response.body);
      if (settings['success'] && settings['settings'] != null) {
        var themeColorSetting = settings['settings'].firstWhere(
              (setting) => setting['setting_name'] == 'theme_color',
          orElse: () => null,
        );

        if (themeColorSetting != null) {
          int colorValue = int.parse(themeColorSetting['setting_value']);
          return Color(colorValue);
        }
      }
    }
    return Colors.blue;
  }
}
