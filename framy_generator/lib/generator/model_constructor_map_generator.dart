import 'package:framy_generator/framy_object.dart';

String generateModelConstructorMap(List<FramyObject> models) => '''
final framyModelConstructorMap =
    <String, dynamic Function(FramyDependencyModel)>{
  ${models.fold('', (previousValue, model) => previousValue + _generateModelConstructor(model))}
};
''';

String _generateModelConstructor(FramyObject model) {
  return ''''${model.name}': (dep) => ${model.name}(
    ${model.widgetDependencies.fold('', (s, dep) => s + _generateParamUsageInConstructor(dep))}),
''';
}

String _generateParamUsageInConstructor(FramyWidgetDependency dependency) {
  final nameInConstructor = dependency.isNamed ? '${dependency.name}: ' : '';
  return '${nameInConstructor}dep.subDependencies.singleWhere((d) => d.name == \'${dependency.name}\').value,\n';
}
