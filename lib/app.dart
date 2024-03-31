import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/flavors.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/navigator_service.dart';
import 'package:my_mvvm_app/src/view_models/product_view_model.dart';
import 'package:my_mvvm_app/src/view_models/start_view_model.dart';
import 'package:my_mvvm_app/src/views/start/start_page.dart';
import 'package:my_mvvm_app/src/widgets/common_full_screen_loader.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StartViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: const _AppEntry(),
    );
  }
}

class _AppEntry extends StatelessWidget {
  const _AppEntry();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: const CommonFullScreenLoader(),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.noScaling),
                    child: child!,
                  );
                },
                title: F.title,
                navigatorKey: locator.get<NavigatorService>().mainKey,
                debugShowCheckedModeBanner: false,
                home: const StartPage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
