import 'package:my_mvvm_app/src/models/product.dart';
import 'package:my_mvvm_app/src/models/result.dart';
import 'package:my_mvvm_app/src/services/locator_service.dart';
import 'package:my_mvvm_app/src/services/network_exceptions.dart';
import 'package:my_mvvm_app/src/services/network_service.dart';

class AddProductAPI {
  static Future<Result<Product, String>> post({
    required String title,
    required String description,
  }) async {
    try {
      final response = await locator<NetworkService>().post(
        '/products/add',
        isRequireAuth: false,
        body: {
          'title': title,
          'description': description,
        },
      ) as Map<String, dynamic>;

      // Directly parse the API response into AddProductResponse
      final addProductRes = AddProductResponse.fromJson(response);

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

class AddProductResponse {
  AddProductResponse({required this.product});

  factory AddProductResponse.fromJson(Map<String, dynamic> json) {
    return AddProductResponse(
      product: Product.fromJson(json),
    );
  }
  final Product product;
}
