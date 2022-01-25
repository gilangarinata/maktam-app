import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/services/model/selling_response.dart';
import 'package:maktampos/services/repository/selling_repository.dart';
import 'package:maktampos/ui/selling/selling_event.dart';
import 'package:maktampos/ui/selling/selling_state.dart';
import 'package:maktampos/utils/network_utils.dart';

class SellingBloc extends Bloc<SellingEvent, SellingState> {
  SellingRepository repository;

  SellingBloc(this.repository) : super(InitialState());

  @override
  Stream<SellingState> mapEventToState(SellingEvent event) async* {
    if (event is GetSelling) {
      try {
        yield GetSellingLoading();
        SellingResponse? items = await repository.getAllData();
        yield GetSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("GetSelling: " + NetworkUtils.getErrorMessage(e),
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

    if (event is InsertSelling) {
      try {
        yield CreateUpdateSellingLoading();
        BaseResponse items = await repository.createSelling(event.params);
        yield CreateUpdateSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("InsertSelling: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is GetSellingDetail) {
      try {
        yield GetDetailSellingLoading();
        SellingDetailResponse? items =
            await repository.getSellingDetail(event.date, event.shift);
        yield GetDetailSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("GetSelling: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is DeleteSelling) {
      try {
        yield DeleteSellingLoading();
        BaseResponse? items =
            await repository.deleteSelling(event.date, event.shift);
        yield DeleteSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("DeleteSelling: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is UpdateSelling) {
      try {
        yield CreateUpdateSellingLoading();
        BaseResponse? items =
            await repository.updateSelling(event.sellingParams);
        yield CreateUpdateSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("UpdateSelling: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }
  }
}
