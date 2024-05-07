import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:riverpod_';

final riverpodEasyLevel = StateProvider<int>((ref) {
  return 0;
});

// final riverpodHardLevel = ChangeNotifierProvider<RiverpodModel>((ref) {
//   return RiverpodModel (counter: 0);
// });