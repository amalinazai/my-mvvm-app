import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/view_models/start_view_model.dart';
import 'package:my_mvvm_app/src/views/login/login_page.dart';
import 'package:my_mvvm_app/src/views/main/main_page.dart';
import 'package:my_mvvm_app/src/widgets/common_loader.dart';
import 'package:my_mvvm_app/src/widgets/double_tap_exit.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  static Future<void> goTo(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<StartPage>(
          builder: (context) => const StartPage(),
        ),
      );
    });
  }

  @override
Widget build(BuildContext context) {
    return DoubleTapExit(
      child: ChangeNotifierProvider<StartViewModel>(
        create: (_) => StartViewModel()..initialize(),
        child: Consumer<StartViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.state == StartViewState.loading) {
              return const Scaffold(body: Center(child: CommonLoader()));
            }
      
            if (viewModel.state == StartViewState.loaded) {
              Future.microtask(() => viewModel.isAuthenticated
                  ? MainPage.goTo(context)
                  : LoginPage.goTo(context),);
      
              // Returning Container to avoid build errors, 
              // navigation will trigger before build finishes.
              return Container();
            }
      
            return const Scaffold(body: Center(child: Text('Initializing...')));
          },
        ),
      ),
    );
  }
}
