import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/main.app.framy.dart';

import 'test_utils.dart';

void main() {
  FramyDependencyModel _getStringListModel([List<String> defaultValue]) =>
      FramyDependencyModel<List<String>>(
          'strings', 'List<String>', defaultValue, []);

  Future<void> _buildDependencyInput(
    WidgetTester tester,
    FramyDependencyModel dependency, {
    ValueChanged<FramyDependencyModel> onChanged,
    Map<String, Map<String, dynamic>> presets = const {},
  }) async {
    await tester.pumpWidget(
      TestMaterialAppWithScaffold(
        FramyWidgetListDependencyInput(
          dependency: dependency,
          onChanged: onChanged ?? (_) {},
          presets: presets,
        ),
      ),
    );
  }

  group('FramyWidgetListDependencyInput', () {
    testWidgets('should build', (WidgetTester tester) async {
      await _buildDependencyInput(tester, _getStringListModel());
      expect(find.byType(FramyWidgetListDependencyInput), findsOneWidget);
    });

    testWidgets('should have Add button', (WidgetTester tester) async {
      await _buildDependencyInput(tester, _getStringListModel());
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('should add new list element when Add is pressed',
        (WidgetTester tester) async {
      //given
      List<String> emittedValue;
      await _buildDependencyInput(
        tester,
        _getStringListModel(),
        onChanged: (model) => emittedValue = model.value,
      );
      //when
      await tester.tap(find.text('Add'));
      //then
      expect(emittedValue, hasLength(1));
      expect(emittedValue.first, isNull);
    });

    testWidgets('should show an input for every list item',
        (WidgetTester tester) async {
      await _buildDependencyInput(
        tester,
        _getStringListModel(['item1', 'item2', 'item3']),
      );
      expect(find.text('item1'), findsOneWidget);
      expect(find.text('item2'), findsOneWidget);
      expect(find.text('item3'), findsOneWidget);
    });

    testWidgets('should emit changed list item value',
        (WidgetTester tester) async {
      //given
      List<String> emittedValue;
      await _buildDependencyInput(
        tester,
        _getStringListModel([null]),
        onChanged: (model) => emittedValue = model.value,
      );
      //when
      await tester.enterText(
          find.byKey(Key('framy_dependency_List element 1_input')), 'Foo foo');
      //then
      expect(emittedValue, hasLength(1));
      expect(emittedValue.first, 'Foo foo');
    });

    testWidgets('should allow to add first item to null and then change it',
        (WidgetTester tester) async {
      //given
      final dependency = _getStringListModel();
      await tester.pumpWidget(
        TestMaterialAppWithScaffold(
          StatefulBuilder(
            builder: (context, setState) => FramyWidgetListDependencyInput(
              dependency: dependency,
              onChanged: (dep) => setState(() {}),
              presets: {},
            ),
          ),
        ),
      );
      //when
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(Key('framy_dependency_List element 1_input')),
        'Foo foo',
      );
      //then
      expect(dependency.value, hasLength(1));
      expect(dependency.value.first, 'Foo foo');
    });

    testWidgets('should remove element from list when delete icon pressed',
        (WidgetTester tester) async {
      //given
      List<String> emittedValue;
      await _buildDependencyInput(
        tester,
        _getStringListModel(['value1', 'value2']),
        onChanged: (model) => emittedValue = model.value,
      );
      //when
      await tester.tap(find.byKey(
        Key('framy_dependency_List element 1_delete_button'),
      ));
      //then
      expect(emittedValue, hasLength(1));
      expect(emittedValue.first, 'value2');
    });

    testWidgets('should properly update UI after removing element from list',
        (WidgetTester tester) async {
      //given
      final dependency = _getStringListModel(['value1', 'value2']);
      await tester.pumpWidget(
        TestMaterialAppWithScaffold(
          StatefulBuilder(
            builder: (context, setState) => FramyWidgetListDependencyInput(
              dependency: dependency,
              onChanged: (dep) => setState(() {}),
              presets: {},
            ),
          ),
        ),
      );
      //when
      await tester.tap(find.byKey(
        Key('framy_dependency_List element 1_delete_button'),
      ));
      await tester.pump();
      //then
      expect(find.text('value1'), findsNothing);
      expect(find.text('value2'), findsOneWidget);
    });
  });
}
