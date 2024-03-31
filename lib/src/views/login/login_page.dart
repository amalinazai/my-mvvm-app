import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/utils/padding_utils.dart';
import 'package:my_mvvm_app/src/utils/screen_utils.dart';
import 'package:my_mvvm_app/src/view_models/auth_view_model.dart';
import 'package:my_mvvm_app/src/view_models/login_view_model.dart';
import 'package:my_mvvm_app/src/views/main/main_page.dart';
import 'package:my_mvvm_app/src/widgets/common_button.dart';
import 'package:my_mvvm_app/src/widgets/common_password_text_field.dart';
import 'package:my_mvvm_app/src/widgets/common_snackbar.dart';
import 'package:my_mvvm_app/src/widgets/common_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Future<void> goTo(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<LoginPage>(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          if (authViewModel.state.status == AuthStatus.loading) {
            context.loaderOverlay.show();
          }

          if (authViewModel.state.status == AuthStatus.success) {
            context.loaderOverlay.hide();
            MainPage.goTo(context);
          }

          if (authViewModel.state.status == AuthStatus.loginFailure) {
            context.loaderOverlay.hide();
            CommonSnackbar.show(
              title: authViewModel.state.error ?? '',
              isSuccess: false,
            );
          }

          return const _LoginPageView();
        },
      ),
    );
  }
}

class _LoginPageView extends StatelessWidget {
  const _LoginPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.alabaster,
      body: Consumer<LoginViewModel>(
        builder: (ctx, loginViewModel, child) {
          return Column(
            children: [
              AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      height: ScreenUtils.screenHeight * 0.25,
                      margin: EdgeInsets.only(top: ScreenUtils.safePaddingTop + (ScreenUtils.screenHeight * 0.01)),
                    ),
                  ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.screenWidth * 0.08,
                  ),
                  decoration: const BoxDecoration(
                    color: Palette.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  child: _FieldsView(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FieldsView extends StatelessWidget {
  _FieldsView();

  final TextEditingController usernameTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Updated to use viewModel for login attempt
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: PaddingUtils.paddingBottomScreen,
            ),
            child: const Center(
              child: Text(
                'Welcome Back!',
                style: CustomTypography.h1,
              ),
            ),
          ),
          SizedBox(height: PaddingUtils.paddingBottomScreen),
          CommonTextField(
            controller: usernameTEC,
            hintText: 'Username',
            cursorColor: Palette.white,
            options: const TextFieldOptions(
              autocorrect: false,
            ),
          ),
          CommonPasswordTextField(
            margin: EdgeInsets.only(
              top: ScreenUtils.screenHeight * 0.05,
              bottom: ScreenUtils.screenHeight * 0.05,
            ),
            controller: passwordTEC,
            hintText: 'Password',
            cursorColor: Palette.white,
            options: const TextFieldOptions(
              autocorrect: false,
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(height: ScreenUtils.screenHeight * 0.02,),
          CommonButton(
            title: 'Login',
            onTap: () => viewModel.onTapLogIn(usernameTEC.text, passwordTEC.text),
            rightIconData: Icons.arrow_forward,
          ),
          SizedBox(height: PaddingUtils.paddingBottomScreen,),
        ],
      ),
    );
  }
}
