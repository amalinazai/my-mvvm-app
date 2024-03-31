import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/src/constants/custom_typography.dart';
import 'package:my_mvvm_app/src/constants/palette.dart';
import 'package:my_mvvm_app/src/constants/status.dart';
import 'package:my_mvvm_app/src/view_models/product_view_model.dart';
import 'package:my_mvvm_app/src/views/product/product_form_page.dart';
import 'package:my_mvvm_app/src/views/product/widgets/product_list_body.dart';
import 'package:my_mvvm_app/src/widgets/common_snackbar.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  static Future<void> goTo(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<ProductPage>(
        builder: (context) => const ProductPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(),
      child: const _ProductPageView(),
    );
  }
}

class _ProductPageView extends StatefulWidget {
  const _ProductPageView();

  @override
  State<_ProductPageView> createState() => _ProductPageViewState();
}

class _ProductPageViewState extends State<_ProductPageView> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().getProducts(status: Status.loading, skip: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.pearl,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.calPolyGreen,
        onPressed: () => ProductFormPage.goTo(context),
        child: const Icon(Icons.add, color: Palette.mintCream),
      ),
      appBar: AppBar(
        title:
            const Text('Products', style: CustomTypography.body1Bold),
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.state;

          if (state.status == Status.loading) {
            context.loaderOverlay.show();
          }

          if (state.status == Status.success) {
            context.loaderOverlay.hide();
          }

          if (viewModel.state.status == Status.failure) {
            context.loaderOverlay.hide();
            CommonSnackbar.show(
              title: viewModel.state.error ?? '',
              isSuccess: false,
            );
          }
          return ProductListBody(
            products: state.products ?? [],
            canLoadMore: state.productPagination?.canLoadMore ?? false,
          );
        },
      ),
    );
  }
}
