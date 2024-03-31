import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';

class CommonPaginationFooter extends StatelessWidget {
  const CommonPaginationFooter({
    this.hasMoreData = false,
    this.noMoreItemsSubtitle,
    this.margin = const EdgeInsets.only(top: 12),
    super.key,
  });

  final EdgeInsets margin;
  final String? noMoreItemsSubtitle;
  final bool hasMoreData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: hasMoreData
          ? const _HasMoreItemsView()
          : _NoMoreItemsView(
              subtitle: noMoreItemsSubtitle,
            ),
    );
  }
}

class _HasMoreItemsView extends StatelessWidget {
  const _HasMoreItemsView();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator.adaptive(),
          ),
          Text('Loading...', 
          style: CustomTypography.body2.copyWith(color: Palette.calPolyGreen),),
        ],
      ),
    );
  }
}

class _NoMoreItemsView extends StatelessWidget {
  const _NoMoreItemsView({
    this.subtitle,
  });

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _DividerWithTickIcon(),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "You're All Caught Up",
            style: CustomTypography.body3.copyWith(
              color: Palette.calPolyGreen,
            ),
          ),
        ),
        Text(
          subtitle ?? "You've seen all new items.",
          style: CustomTypography.bodySubtitleSemiBold.copyWith(
            color: Palette.calPolyGreen,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CustomStyles {}

class _DividerWithTickIcon extends StatelessWidget {
  const _DividerWithTickIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: Palette.calPolyGreen,
          ),

          // tick icon smack in the center
          const Icon(
            Icons.check_circle_rounded,
            color: Palette.calPolyGreen,
            size: 30,
          ),
        ],
      ),
    );
  }
}
