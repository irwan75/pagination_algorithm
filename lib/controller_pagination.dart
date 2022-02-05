import 'package:get/get_state_manager/get_state_manager.dart';

class PaginationController extends GetxController {
  void updatePagination() {
    update(['paginationRefresh']);
  }

  void refreshFetchData() {
    update(['refreshPagination']);
  }
}
