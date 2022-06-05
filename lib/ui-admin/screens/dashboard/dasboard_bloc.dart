import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dasboard_event.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/services/repository/dashboard_repository.dart';

import 'dashboard_state.dart';


class DashboardBloc extends Bloc<DasboardEvent, DashboardState> {
  DashboardRepository repository;

  DashboardBloc(this.repository) : super(InitialState());

  @override
  Stream<DashboardState> mapEventToState(DasboardEvent event) async* {
    if (event is GetSummary) {
      try {
        yield GetSummaryLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        SummaryResponse? items = await repository.getSummary(formattedDate);
        yield GetSummarySuccess(items: items);
      } catch (e) {
        yield FailedState("GetSummary Failed: ",0);
      }
    }

    if (event is GetSelling) {
      try {
        yield GetSellingLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        List<ProductItem> items = await repository.getSellings(formattedDate);
        yield GetSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("Get selling Failed: ${e.toString()} ",0);
      }
    }

    if (event is GetStocks) {
      try {
        yield GetStockLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        StockResponse item = await repository.getStocks(formattedDate);
        yield GetStockSuccess(stockResponse: item);
      } catch (e) {
        yield FailedState("Get stock Failed: ${e.toString()} ",0);
      }
    }

    if (event is GetMaterials) {
      try {
        yield GetMaterialLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        List<MaterialItem> item = await repository.getMaterials(formattedDate);
        yield GetMaterialSuccess(materialItems: item);
      } catch (e) {
        yield FailedState("Get stock Failed: ${e.toString()} ",0);
      }
    }

    if (event is GetInventory) {
      try {
        yield GetInventoryLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        List<MaterialItem> item = await repository.getInventory(formattedDate);
        yield GetInventorySuccess(materialItems: item);
      } catch (e) {
        yield FailedState("Get stock Failed: ${e.toString()} ",0);
      }
    }

    if (event is UpdateInventory) {
      try {
        yield UpdateInventoryLoading();
        bool isSuccess = await repository.updateInventory(event.param);
        if(isSuccess) {
          yield UpdateInventorySuccess();
        } else {
          yield FailedState("gagal update",0);
        }
      } catch (e) {
        yield FailedState("Get stock Failed: ${e.toString()} ",0);
      }
    }
  }
}
