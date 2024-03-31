import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/models/result.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/network_exceptions.dart';
import 'package:my_mvvm_app/src/services/network_service.dart';

class DeleteProductAPI {
  static Future<Result<Product, String>> delete({
    required int id,
  }) async {
    try {
      final response = await locator<NetworkService>().delete(
        '/products/$id',
        isRequireAuth: false,
        body: {},
      ) as Map<String, dynamic>;

      // Directly parse the API response into DeleteProductResponse
      final addProductRes = DeleteProductResponse.fromJson(response);

      return Success(addProductRes.product);
    } catch (e) {
      return Failure(
        getNetworkErrorMessage(
          e,
          badResponseMessage: (data) {
            return (data as Map<String, dynamic>?)?['message'] as String?;
          },
        ),
      );
    }
  }
}

class DeleteProductResponse {
  DeleteProductResponse({required this.product});

  factory DeleteProductResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProductResponse(
      product: Product.fromJson(json),
    );
  }
  final Product product;
}
