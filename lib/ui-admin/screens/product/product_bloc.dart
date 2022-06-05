import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/screens/product/product_event.dart';
import 'package:maktampos/ui-admin/screens/product/product_state.dart';
import 'package:maktampos/ui-admin/services/repository/product_repository.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository repository;

  ProductBloc(this.repository) : super(InitialState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is GetProducts) {
      try {
        yield GetProductLoading();
        List<ProductItem>? items = await repository.getProducts();
        yield GetProductSuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }

    if (event is GetSubcategories) {
      try {
        yield GetSubcategoryLoading();
        List<SubcategoryItem>? items = await repository.getSubcategories();
        yield GetSubategoriesSuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mengambil list kategori produk, silahkan refresh ulang. ",0);
      }
    }

    if (event is CreateProduct) {
      try {
        yield CreateProductLoading();
        bool isSuccess = await repository.createProduct(event.productParam);
        if(isSuccess){
          yield CreateProductSuccess();
        }else{
          yield FailedState("Gagal menambahkan produk, silahkan buat ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal menambahkan produk, silahkan buat ulang.",2);
      }
    }

    if (event is UpdateProduct) {
      try {
        yield CreateProductLoading();
        bool isSuccess = await repository.updateProduct(event.productParam);
        if(isSuccess){
          yield CreateProductSuccess();
        }else{
          yield FailedState("Gagal edit produk, silahkan edit ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal edit produk, silahkan edit ulang.",2);
      }
    }

    if (event is DeleteProduct) {
      try {
        yield DeleteProductLoading();
        bool isSuccess = await repository.deleteProduct(event.id);
        if(isSuccess){
          yield CreateProductSuccess();
        }else{
          yield FailedState("Gagal menghapus produk, silahkan hapus ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal menghapus produk, silahkan hapus ulang. ",2);
      }
    }

    if(event is GetCategories){
      try {
        yield GetCategoryLoading();
        List<CategoryItem> items = await repository.getCategories() ?? [];
        yield GetCategorySuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mendapatkan kategori, silahkan refresh ulang. ",0);
      }
    }

    if(event is CreateCategory){
      try {
        yield CreateCategoryLoading();
        bool isSuccess = await repository.createCategory(event.param);
        if(isSuccess){
          yield CreateCategorySuccess();
        }else{
          yield FailedState("Gagal membuat kategori, silahkan buat ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal membuat kategori, silahkan buat ulang. ",2);
      }
    }

    if(event is UpdateCategory){
      try {
        yield CreateCategoryLoading();
        bool isSuccess = await repository.updateCategory(event.param);
        if(isSuccess){
          yield CreateCategorySuccess();
        }else{
          yield FailedState("Gagal edit kategori, silahkan edit ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal edit kategori, silahkan edit ulang. ",2);
      }
    }

    if(event is DeleteCategory){
      try {
        yield DeleteCategoryLoading();
        bool isSuccess = await repository.deleteCategory(event.id);
        if(isSuccess){
          yield DeleteCategorySuccess();
        }else{
          yield FailedState("Gagal menghapus kategori, silahkan hapus ulang.",1);
        }
      } catch (e) {
        yield FailedState("Gagal menghapus kategori, silahkan hapus ulang",2);
      }
    }

    //cups
    if (event is GetCups) {
      try {
        yield GetProductLoading();
        List<ProductItem>? items = await repository.getCups();
        yield GetProductSuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }

    //cups
    if (event is GetSpices) {
      try {
        yield GetProductLoading();
        List<ProductItem>? items = await repository.getSpices();
        yield GetProductSuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }
  }
}
