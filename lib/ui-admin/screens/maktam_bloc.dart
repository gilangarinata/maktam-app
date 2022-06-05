import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/screens/maktam_event.dart';
import 'package:maktampos/ui-admin/screens/maktam_state.dart';
import 'package:maktampos/ui-admin/services/network_exception.dart';
import 'package:maktampos/ui-admin/services/repository/maktam_repository.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';

class MaktamBloc extends Bloc<MaktamEvent, MaktamState> {
  MaktamRepository repository;

  MaktamBloc(this.repository) : super(InitialState());

  @override
  Stream<MaktamState> mapEventToState(MaktamEvent event) async* {
    if (event is GetUsers) {
      try {
        yield GetUserLoading();
        List<UserResponse>? items = await repository.getUsers();
        yield GetUserSuccess(items: items);
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }

    if (event is GetOutlets) {
      try {
        yield GetOutletLoading();
        List<OutletItem>? items = await repository.getOutlets();
        yield GetOutletsSuccess(items);
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }

    if (event is DeleteUser) {
      try {
        yield DeleteUserLoading();
        bool isSuccess = await repository.deleteUser(event.id);
        if(isSuccess){
          yield DeleteUserSuccess();
        }else{
          yield FailedState("Gagal hapus user",0);
        }
      } catch (e) {
        yield FailedState("Gagal mengambil list produk, silahkan refresh ulang. ",0);
      }
    }

    if (event is CreateUsers) {
      try {
        yield CreateUserLoading();
        await repository.createUser(event.param);
        yield CreateUserSuccess();
      } catch (e) {
        if(e is ClientErrorException){
          yield FailedState("Gagal membuat user ${e.message} ",e.code);
        }else{
          yield FailedState("Gagal membuat user ",0);
        }
      }
    }

    if (event is UpdateUsers) {
      try {
        yield CreateUserLoading();
        await repository.updateUser(event.param);
        yield CreateUserSuccess();
      } catch (e) {
        if(e is ClientErrorException){
          yield FailedState("${e.message} ",e.code);
        }else{
          yield FailedState("Gagal membuat user ",0);
        }
      }
    }

    if (event is CreateOutlet) {
      try {
        yield CreateOutletLoading();
        var isSuccess = await repository.createOutlet(event.param);
        if(isSuccess){
          yield CreateOutletsSuccess();
        }else{
          yield FailedState("Gagal membuat outlet ",0);
        }
      } catch (e) {
        if(e is ClientErrorException){
          yield FailedState("${e.message} ",e.code);
        }else{
          yield FailedState("Gagal membuat outlet ",0);
        }
      }
    }

    if (event is UpdateOutlet) {
      try {
        yield CreateOutletLoading();
        var isSuccess = await repository.updateOutlet(event.param);
        if(isSuccess){
          yield CreateOutletsSuccess();
        }else{
          yield FailedState("Gagal update outlet ",0);
        }
      } catch (e) {
        if(e is ClientErrorException){
          yield FailedState("${e.message} ",e.code);
        }else{
          yield FailedState("Gagal update outlet ",0);
        }
      }
    }

    if (event is DeleteOutlet) {
      try {
        yield DeleteOutletLoading();
        var isSuccess = await repository.deleteOutlet(event.id);
        if(isSuccess){
          yield DeleteOutletsSuccess();
        }else{
          yield FailedState("Gagal update outlet ",0);
        }
      } catch (e) {
        if(e is ClientErrorException){
          yield FailedState("${e.message} ",e.code);
        }else{
          yield FailedState("Gagal update outlet ",0);
        }
      }
    }

  }
}
