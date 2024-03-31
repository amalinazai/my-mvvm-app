import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_mvvm_app/src/constants/status.dart';
import 'package:my_mvvm_app/src/extensions/scroll_controller.dart';
import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/utils/screen_utils.dart';
import 'package:my_mvvm_app/src/view_models/product_view_model.dart';
import 'package:my_mvvm_app/src/views/product/widgets/product_list_view.dart';
import 'package:my_mvvm_app/src/widgets/common_snackbar.dart';
import 'package:provider/provider.dart';

class ProductListBody extends StatefulWidget {
  const ProductListBody({
    required this.products,
    this.canLoadMore = false,
    super.key,
  });

  final List<Product?> products;
  final bool canLoadMore;

  @override
  State<ProductListBody> createState() => _ProductListBodyState();
}

class _ProductListBodyState extends State<ProductListBody> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // setup scroll controller listeners
    scrollController.addListener(_addOnLoadMoreListener);
  }

  @override
  void dispose() {
    super.dispose();

    scrollController
      ..removeListener(_addOnLoadMoreListener)
      ..dispose();
  }

  void _addOnLoadMoreListener() {
    if (scrollController.isScrollToEnd) {
      context.read<ProductViewModel>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
      if (viewModel.state.status == Status.loading) {
        context.loaderOverlay.show();
      }

      if (viewModel.state.status == Status.success) {
        context.loaderOverlay.hide();
      }

      if (viewModel.state.status == Status.failure) {
        context.loaderOverlay.hide();
        CommonSnackbar.show(
          title: viewModel.state.error ?? '',
          isSuccess: false,
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.04 * ScreenUtils.screenWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: ProductListView(
                products: widget.products,
                onRefresh: () async => context.read<ProductViewModel>().getProducts(status: Status.loading, skip: 0),
                scrollController: scrollController,
                canLoadMore: widget.canLoadMore,
              ),
            ),
          ],
        ),
      );
    },
    );
  }
}
