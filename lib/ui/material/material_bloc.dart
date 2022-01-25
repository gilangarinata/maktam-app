import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/material_detail_response.dart';
import 'package:maktampos/services/model/material_item_response.dart';
import 'package:maktampos/services/model/material_response.dart';
import 'package:maktampos/services/repository/material_repository.dart';
import 'package:maktampos/ui/material/material_event.dart';
import 'package:maktampos/ui/material/material_state.dart';
import 'package:maktampos/utils/network_utils.dart';

class MaterialBloc extends Bloc<MaterialEvent, MaterialsState> {
  MaterialRepository repository;

  MaterialBloc(this.repository) : super(InitialState());

  @override
  Stream<MaterialsState> mapEventToState(MaterialEvent event) async* {
    if (event is GetMaterial) {
      try {
        yield GetMaterialLoading();
        List<MaterialResponse>? items = await repository.getMaterials();
        yield GetMaterialsSuccess(items: items);
      } catch (e) {
        yield FailedState("GetMaterial: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }
    if (event is GetMaterialItems) {
      try {
        yield GetMaterialItemLoading();
        List<MaterialItem>? items = await repository.getMaterialItems();
        yield GetMaterialItemSuccess(items: items);
      } catch (e) {
        yield FailedState(
            "GetMaterialItems: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is InsertMaterial) {
      try {
        yield CreateUpdateMaterialLoading();
        BaseResponse? items =
            await repository.createMaterial(event.materialParam);
        yield CreateUpdateMaterialSuccess(items: items);
      } catch (e) {
        yield FailedState("InsertMaterial: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is UpdateMaterial) {
      try {
        yield CreateUpdateMaterialLoading();
        BaseResponse? items =
            await repository.updateMaterial(event.materialParam);
        yield CreateUpdateMaterialSuccess(items: items);
      } catch (e) {
        yield FailedState(
            "UpdateStockUpdateMaterial: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is DeleteMaterial) {
      try {
        yield DeleteMaterialLoading();
        BaseResponse? items = await repository.deleteMaterial(event.date);
        yield DeleteMaterialSuccess(items: items);
      } catch (e) {
        yield FailedState("DeleteMaterial: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }

    if (event is GetMaterialDetails) {
      try {
        yield GetMaterialDetailLoading();
        MaterialDetailResponse? items =
            await repository.getMaterialDetail(event.date);
        yield GetMaterialDetailSuccess(items: items);
      } catch (e) {
        yield FailedState(
            "GetMaterialDetails: " + NetworkUtils.getErrorMessage(e),
            NetworkUtils.getErrorCode(e));
      }
    }
  }
}
