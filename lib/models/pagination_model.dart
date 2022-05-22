import 'package:queroservoluntario/services/config_service.dart';

class PaginationModel {

  int total;
  int totalPage;
  dynamic items;

  static PaginationModel toModel(int total, dynamic items) {
    PaginationModel paginationModel = PaginationModel();
    paginationModel.total = total;
    paginationModel.items = items;
    paginationModel.totalPage =  (total / ConfigService.PAGE_SIZE).ceil();

    return paginationModel;
  }

}