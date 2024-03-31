import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/input_state.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/constants/status.dart';
import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/utils/padding_utils.dart';
import 'package:my_mvvm_app/src/view_models/product_view_model.dart';
import 'package:my_mvvm_app/src/views/product/widgets/product_dialog.dart';
import 'package:my_mvvm_app/src/widgets/common_button.dart';
import 'package:my_mvvm_app/src/widgets/common_snackbar.dart';
import 'package:my_mvvm_app/src/widgets/common_text_field.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({
    this.product,
    super.key,
  });

  final Product? product;

  static Future<void> goTo(BuildContext context, {Product? product}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<ProductFormPage>(
        builder: (context) => ProductFormPage(product: product),
      ),
    );
  }

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController descTEC = TextEditingController();
  bool isTFFilledIn = false;

  @override
  void initState() {
    super.initState();

    Provider.of<ProductViewModel>(context, listen: false).initilizeState();

    if (widget.product != null) {
      titleTEC.text = widget.product?.title ?? '';
      descTEC.text = widget.product?.description ?? '';
      isTFFilledIn = true;
    }

    titleTEC.addListener(_textFieldListener);
    descTEC.addListener(_textFieldListener);
  }

  @override
  void dispose() {
    titleTEC
      ..removeListener(_textFieldListener)
      ..dispose();
    descTEC
      ..removeListener(_textFieldListener)
      ..dispose();
    super.dispose();
  }

  void _textFieldListener() {
    setState(() => isTFFilledIn = titleTEC.text.isNotEmpty && descTEC.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: Text(
          widget.product != null ? 'Edit Product' : 'Add New Product',
          style: CustomTypography.body1Bold,
        ),
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state.actionType == ActionType.productFormAction) {
            
            if (viewModel.state.status == Status.loading) {
              context.loaderOverlay.show();
            }
      
            if (viewModel.state.status == Status.success) {
              context.loaderOverlay.hide();
              ProductDialog.show(
                title: widget.product != null
                    ? 'Product Updated!'
                    : 'Product Added!',
                product: viewModel.state.productFromApiRes ?? Product(),
                onTapBtn: () {
                  Navigator.pop(context);
                },
              );
            }
      
            if (viewModel.state.status == Status.failure) {
              context.loaderOverlay.hide();
              CommonSnackbar.show(
                title: viewModel.state.error ?? '',
                isSuccess: false,
              );
            }
          }
      
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PaddingUtils.paddingHorizontal,
                    vertical: PaddingUtils.paddingVertical,
                  ),
                  child: Column(
                    children: [
                      _textfield(
                        label: 'Title',
                        ctrl: titleTEC,
                      ),
                      _textfield(
                        label: 'Description',
                        ctrl: descTEC,
                      ),
                      const Spacer(),
                      _saveBtn(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _textfield({
    required String label,
    required TextEditingController ctrl,
    ({InputState state, String text})? Function(String?)? helperText,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: PaddingUtils.paddingBottom),
      child: CommonTextField(
        controller: ctrl,
        labelText: label,
        showLabel: true,
        helperText: helperText,
        hintText: '',
      ),
    );
  }

  Widget _saveBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: PaddingUtils.paddingBottomScreen),
      child: CommonButton(
        title: widget.product != null ? 'Update' : 'Add',
        columnCrossAxisAlignment: CrossAxisAlignment.center,
        isEnabled: isTFFilledIn,
        onTap: () async {
          if (widget.product != null) {
            await context.read<ProductViewModel>().updateProduct(
                  id: widget.product?.id ?? 0,
                  title: titleTEC.text,
                  description: descTEC.text,
                );
          } else {
            await context.read<ProductViewModel>().addProduct(
                  title: titleTEC.text,
                  description: descTEC.text,
                );
          }
        },
      ),
    );
  }
}
