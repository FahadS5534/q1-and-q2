// blocs/product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

class SingleProductLoaded extends ProductState {
  final Product product;
  SingleProductLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductLoading());

  void fetchProducts({int limit = 10, int skip = 0}) async {
    try {
      final products = await repository.fetchProducts(limit: limit, skip: skip);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void fetchSingleProduct(int id) async {
    try {
      final product = await repository.fetchSingleProduct(id);
      emit(SingleProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void searchProducts(String query) async {
    try {
      final products = await repository.searchProducts(query);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
