// ignore_for_file: unnecessary_breaks

import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/apis/products/add_product_api.dart';
import 'package:my_mvvm_app/src/apis/products/delete_product_api.dart';
import 'package:my_mvvm_app/src/apis/products/product_list_api.dart';
import 'package:my_mvvm_app/src/apis/products/update_product_api.dart';
import 'package:my_mvvm_app/src/constants/status.dart';
import 'package:my_mvvm_app/src/models/pagination.dart';
import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/models/result.dart';

enum ActionType { productDetailsAction, productFormAction }

class ProductViewModelState {
  ProductViewModelState({
    this.status = Status.initial,
    this.successMessage,
    this.error,
    this.products,
    this.productPagination,
    this.productFromApiRes,
    this.actionType,
  });

  Status status;
  String? successMessage;
  String? error;
  List<Product?>? products;
  Pagination? productPagination;
  Product? productFromApiRes;
  ActionType? actionType;
}

class ProductViewModel with ChangeNotifier {
  ProductViewModelState _state = ProductViewModelState();
  ProductViewModelState get state => _state;

  void initilizeState() {
    _state = ProductViewModelState();
    notifyListeners();
  }

  Future<void> getProducts({required Status status, required int skip}) async {
    _state.status = status;
    notifyListeners();

    final res = await ProductListAPI.get(skip: skip);

    switch (res) {
      case Success(
          value: (
            final List<Product?> products,
            final Pagination pagination,
          )
        ):
        updateProducts(
          products,
          pagination,
          shouldClearList: skip == 0,
        );

      case Failure(message: final String error):
        _state = ProductViewModelState(
          status: Status.failure,
          error: error,
        );
        notifyListeners();
    }
  }

  void updateProducts(List<Product?> newProducts, Pagination newPagination,
      {bool shouldClearList = false,}) {
    final updatedList = [
      ...(shouldClearList ? <Product?>[] : state.products ?? <Product?>[]),
      ...newProducts,
    ];

    _state = ProductViewModelState(
      status: Status.success,
      products: updatedList,
      productPagination: newPagination,
    );
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (!state.productPagination!.canLoadMore) return;

    final newSkip = state.productPagination!.skip + state.productPagination!.limit;
    
    await getProducts(status: Status.loadingMore, skip: newSkip);
  }

  Future<void> addProduct({required String title, required String description}) async {
    _state = ProductViewModelState(
      status: Status.loading,
      actionType: ActionType.productFormAction,
    );
    notifyListeners();

    final res = await AddProductAPI.post(title: title, description: description);

    switch (res) {
      case Success(value: final Product? product):
        _state = ProductViewModelState(
          status: Status.success,
          productFromApiRes: product,
          actionType: ActionType.productFormAction,
        );
        break;

      case Failure(message: final String error):
        _state = ProductViewModelState(
          status: Status.failure,
          error: error,
          actionType: ActionType.productFormAction,
        );
        break;
    }

    notifyListeners();
  }

  Future<void> updateProduct({required int id, required String title, required String description}) async {
    _state = ProductViewModelState(
      status: Status.loading,
      actionType: ActionType.productFormAction,
    );
    notifyListeners();

    final res = await UpdateProductAPI.put(
      id: id,
      title: title, 
      description: description,
    );

    switch (res) {
      case Success(value: final Product? product):
        _state = ProductViewModelState(
          status: Status.success,
          productFromApiRes: product,
          actionType: ActionType.productFormAction,
        );
        break;

      case Failure(message: final String error):
        _state = ProductViewModelState(
          status: Status.failure,
          error: error,
          actionType: ActionType.productFormAction,
        );
        break;
    }

    notifyListeners();
  }

  Future<void> deleteProduct({required int id}) async {
    _state = ProductViewModelState(
      status: Status.loading,
      actionType: ActionType.productDetailsAction,
    );
    notifyListeners();

    final res = await DeleteProductAPI.delete(id: id);

    switch (res) {
      case Success(value: final Product? product):
        _state = ProductViewModelState(
          status: Status.success,
          productFromApiRes: product,
          actionType: ActionType.productDetailsAction,
        );
        break;

      case Failure(message: final String error):
        _state = ProductViewModelState(
          status: Status.failure,
          error: error,
          actionType: ActionType.productDetailsAction,
        );
        break;
    }

    notifyListeners();
  }
}
