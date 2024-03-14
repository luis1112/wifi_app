import 'package:wifi/docs.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (_) => ProviderGlobal()),
    ChangeNotifierProvider(create: (_) => ProviderConnection()),
    ChangeNotifierProvider(create: (_) => ProviderLogin()),
  ];
}

