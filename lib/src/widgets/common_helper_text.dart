import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/constants/asset_paths.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/input_state.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/utils/screen_utils.dart';

class CommonHelperText extends StatelessWidget {
  const CommonHelperText({
    required this.text,
    required this.inputState,
    super.key,
  });

  final String text;
  final InputState inputState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          if (_iconPath != null)
          Image.asset(
            _iconPath!,
            width: 0.05 * ScreenUtils.screenWidth,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: CustomTypography.body3.copyWith(
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? get _iconPath {
    switch (inputState) {
      case InputState.error:
        return AssetPaths.error;
      case InputState.success:
        return AssetPaths.success;
      case InputState.none:
        return null;
    }
  }

  Color _textColor(BuildContext context) {
    switch (inputState) {
      case InputState.none:
        return Palette.black;
      case InputState.error:
        return Palette.error;
      case InputState.success:
        return Palette.success;
    }
  }
}
