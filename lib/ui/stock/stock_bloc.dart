import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/services/model/stock_response.dart';
import 'package:maktampos/services/repository/stock_repository.dart';
import 'package:maktampos/ui/stock/stock_event.dart';
import 'package:maktampos/ui/stock/stock_state.dart';
import 'package:maktampos/utils/network_utils.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockRepository repository;

  StockBloc(this.repository) : super(InitialState());

  @override
  Stream<StockState> mapEventToState(StockEvent event) async* {
    if (event is GetStocks) {
      try {
        yield GetStockLoading();
        StockResponse? items = await repository.getStocks(event.page);
        yield GetStockSuccess(items: items);
      } catch (e) {
        yield FailedState("GetStocks: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }
    if (event is GetCategoriesItems) {
      try {
        yield GetCategoriesItemLoading();
        List<CategoryItemResponse>? items =
            await repository.getItemsAndCategories();
        yield GetCategoriesItemSuccess(items: items);
      } catch (e) {
        yield FailedState(
            "GetCategoriesItems: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is InsertStock) {
      try {
        yield CreateUpdateStockLoading();
        BaseResponse? items = await repository.createStock(event.stockParam);
        yield CreateUpdateStockSuccess(items: items);
      } catch (e) {
        yield FailedState("InsertStock: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is UpdateStock) {
      try {
        yield CreateUpdateStockLoading();
        BaseResponse? items = await repository.updateStock(event.stockParam);
        yield CreateUpdateStockSuccess(items: items);
      } catch (e) {
        yield FailedState("UpdateStock: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is DeleteStock) {
      try {
        yield DeleteStockLoading();
        BaseResponse? items = await repository.deleteStock(event.date);
        yield DeleteStockSuccess(items: items);
      } catch (e) {
        yield FailedState("DeleteStock: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is GetStockDetails) {
      try {
        yield GetStockDetailLoading();
        StockDetailResponse? items =
            await repository.getStockDetail(event.date);
        yield GetStockDetailSuccess(items: items);
      } catch (e) {
        yield FailedState("GetStockDetails: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }
  }
}
