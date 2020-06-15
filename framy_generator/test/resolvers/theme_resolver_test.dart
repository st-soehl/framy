import 'package:framy_annotation/framy_annotation.dart';
import 'package:framy_generator/theme_resolver.dart';
import 'package:source_gen_test/source_gen_test.dart';

import 'dummy_classes.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/resolvers',
    'theme_resolver_test.dart',
  );

  initializeBuildLogTracking();
  testAnnotatedElements<FramyTheme>(
    reader,
    ThemeResolver(),
    useDartFormatter: false,
  );
}

@ShouldGenerate('''
[
  {
    "type": "FramyObjectType.themeData",
    "import": "package:__test__/theme_resolver_test.dart",
    "name": "getThemeData",
    "isStatic": true,
    "kind": "FUNCTION",
    "parentObject": null
  }
]''')
@FramyTheme()
ThemeData getThemeData() => ThemeData(errorColor: Color(0xFFFF0000));

@ShouldThrow('Framy annotations cannot be applied to private methods')
@FramyTheme()
// ignore: unused_element
ThemeData _privateThemeData() => ThemeData();

@ShouldGenerate('''
[
  {
    "type": "FramyObjectType.themeData",
    "import": "package:__test__/theme_resolver_test.dart",
    "name": "getTheme",
    "isStatic": false,
    "kind": "METHOD",
    "parentObject": {
      "type": null,
      "import": "package:__test__/theme_resolver_test.dart",
      "name": "AppTheme",
      "isStatic": false,
      "kind": "CLASS",
      "parentObject": null
    }
  }
]''')
@FramyTheme()
class AppTheme {
  ThemeData getTheme() => ThemeData();
}

@ShouldGenerate('"isStatic": true', contains: true)
@FramyTheme()
class AppTheme2 {
  static ThemeData getTheme() => ThemeData();
}

@ShouldGenerate('"kind": "GETTER"', contains: true)
@FramyTheme()
class AppTheme3 {
  ThemeData theme = ThemeData();
}

@ShouldGenerate('''
[
  {
    "type": "FramyObjectType.color",
    "import": "package:__test__/theme_resolver_test.dart",
    "name": "myCustomColor",
    "isStatic": false,
    "kind": "GETTER",
    "parentObject": {
      "type": null,
      "import": "package:__test__/theme_resolver_test.dart",
      "name": "AppThemeWithColor1",
      "isStatic": false,
      "kind": "CLASS",
      "parentObject": null
    }
  }
]''')
@FramyTheme()
class AppThemeWithColor1 {
  final myCustomColor = Color(0xFFFF9090);
}

@ShouldGenerate('"name": "myCustomColor",', contains: true)
@FramyTheme()
class AppThemeWithMaterialColor {
  final myCustomColor = MaterialColor(0xFFFF9090);
}

@ShouldGenerate('"name": "myCustomMaterialAccentColor",', contains: true)
@FramyTheme()
class AppThemeWithMaterialAccentColor {
  final myCustomMaterialAccentColor = MaterialAccentColor(0xFFFF9090);
}