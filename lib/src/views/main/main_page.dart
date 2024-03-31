import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/src/constants/asset_paths.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/view_models/auth_view_model.dart';
import 'package:my_mvvm_app/src/view_models/main_view_model.dart';
import 'package:my_mvvm_app/src/views/home/home_page.dart';
import 'package:my_mvvm_app/src/views/profile/profile_page.dart';
import 'package:my_mvvm_app/src/views/start/start_page.dart';
import 'package:my_mvvm_app/src/widgets/common_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

final List<(Widget page, String title, String iconPath)> _pages = [
  (const HomePage(), 'Home', AssetPaths.home),
  (Container(color: Palette.calPolyGreen), 'Booking', AssetPaths.bookings),
  (Container(color: Palette.mintCream), 'Notification',  AssetPaths.notification),
  (const ProfilePage(), 'Profile', AssetPaths.profile),
];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Future<void> goTo(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<MainPage>(
          builder: (context) => const MainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MainViewModel()),
      ],
      child: const _MainPageView(),
    );
  }
}

class _MainPageView extends StatefulWidget {
  const _MainPageView();

  @override
  State<_MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<_MainPageView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (ctx, authViewModel, child) {
        if (authViewModel.state.status == AuthStatus.loading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }

        if (authViewModel.state.status == AuthStatus.loggedOut) {
          print('hey logged out!');
          // Do something if needed
          StartPage.goTo(context);
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              _pages.length,
              (index) => _pages[index].$1,
              growable: false,
            ),
          ),
          bottomNavigationBar: Consumer<MainViewModel>(
            builder: (context, mainViewModel, child) {
              return CommonBottomNavBar(
                currentIndex: mainViewModel.tabIndex,
                onTap: (index) {
                  mainViewModel.updateTab(index);
                  _pageController.jumpToPage(index);
                },
                items: List.generate(
                  _pages.length,
                  (index) => (_pages[index].$2, _pages[index].$3),
                  growable: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
