class EndPoint {
  static String mainEndPoint = "http://192.168.37.37/inventory_app_api/public/api/";
  static String login = mainEndPoint + "login";
  static String add = mainEndPoint + "inventory/add";
  static String showList = mainEndPoint + "inventory/show_list";
  static String detail = mainEndPoint + "inventory/detail";
  static String update = mainEndPoint + "inventory/update";
  static String delete = mainEndPoint + "inventory/delete";
  static String exportPdf = mainEndPoint + "inventory/export_pdf";
  
  static String updateFcmToken = mainEndPoint + "user/update_token";
}