import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/extensions/date_time_extensions.dart';
import 'package:my_mvvm_app/src/utils/padding_utils.dart';
import 'package:my_mvvm_app/src/utils/screen_utils.dart';
import 'package:my_mvvm_app/src/views/product/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Future<void> goTo(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<HomePage>(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _playAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.pearl,
      body: Stack(
        children: [
          _bgWithMsg(),
          _mainContainer(),
        ],
      ),
    );
  }

  Widget _bgWithMsg() {
    return Column(
      children: [
        Container(
          height: 0.12 * ScreenUtils.screenHeight,
          margin: EdgeInsets.only(
            top: ScreenUtils.safePaddingTop + 0.01 * ScreenUtils.screenHeight,
          ),
          child: Stack(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.08 * ScreenUtils.screenWidth,
                    vertical: 0.02 * ScreenUtils.screenHeight,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Hi, ${DateTime.now().greeting()} 👋',
                      style: CustomTypography.h4
                          .copyWith(color: Palette.black),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Widget _mainContainer() {
    return Column(
      children: [
        Container(
          height: 0.10 * ScreenUtils.screenHeight,
          margin: EdgeInsets.only(
            top: ScreenUtils.safePaddingTop + 0.01 * ScreenUtils.screenHeight,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 0.04 * ScreenUtils.screenWidth,
              right: 0.04 * ScreenUtils.screenWidth,
              top: 0.03 * ScreenUtils.screenHeight,
            ),
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: PaddingUtils.paddingTop),
                _button(
                  title: 'View Products Here',
                  subtitle:
                      'Note: This page shows the example of list with pagination, and each image is cached. The CRUD functionalities will not update the data in the dummy server.',
                  onTap: () => ProductPage.goTo(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _button({
    required String title, 
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: PaddingUtils.paddingBottom),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.white,
          boxShadow: [
            BoxShadow(
              color: Palette.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Palette.black.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Palette.calPolyGreen.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
            child: Padding(
                    padding: EdgeInsets.all(0.04 * ScreenUtils.screenHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: CustomTypography.body1Bold),
                        Text(
                          subtitle ?? '',
                          style: CustomTypography.body4.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
