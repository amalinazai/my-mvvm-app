import 'package:my_mvvm_app/flavors.dart';
import 'package:my_mvvm_app/main.dart';

void main() {
  F.appFlavor = Flavor.STAGING;
  initializeApp();
}
