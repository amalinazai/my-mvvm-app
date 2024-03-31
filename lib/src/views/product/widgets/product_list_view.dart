import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/utils/screen_utils.dart';
import 'package:my_mvvm_app/src/view_models/product_view_model.dart';
import 'package:my_mvvm_app/src/views/product/widgets/product_item.dart';
import 'package:my_mvvm_app/src/widgets/common_pagination_footer.dart';
import 'package:provider/provider.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({
    required this.products,
    required this.onRefresh,
    required this.scrollController,
    required this.canLoadMore,
    super.key,
  });

  final List<Product?> products;
  final bool canLoadMore;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: products.isEmpty
              ? SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: ScreenUtils.contentableHeight,
                    child: const Placeholder(),
                  ),
                )
              : ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                  itemCount: products.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    if (index == products.length) {
                      return CommonPaginationFooter(
                        hasMoreData: canLoadMore,
                      );
                    }

                    return ProductItem(product: products[index] ?? Product());
                  },
                ),
        );
      },
    );
  }
}
