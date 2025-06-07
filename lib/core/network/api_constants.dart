class ApiConstants {
  static const baseUrl = 'https://valet.vps.kirellos.com';
  static const loginEndPoint = '/api/Valet/Login';
  static const createOrderEndPoint = '/api/Valet/Order';
  static const myGaragesEndPoint = '/api/Valet/MyGarages';
  static const storeOrderEndPoint = '/api/Valet/Store/Order';
  static const myOrdersEndPoint = '/api/Valet/myOrders';
  static String updateOrderStatusEndPoint(int orderId , int newStatus)=> '$baseUrl/api/Valet/updateOrderStatus/$orderId/$newStatus';
  static String deleteValetEndPoint(int valetId)=> '$baseUrl/api/Valet/Delete/$valetId';
  static String getGarageSpotEndPoint(int garageId)=> '$baseUrl/api/Valet/getGarageSpot/$garageId';
  static String updateOrderSpotEndPoint(int orderId , int spotId,int garageId)=> '$baseUrl/api/Valet/UpdateOrderSpot/$orderId/$spotId/$garageId';
  static String cancelOrderEndPoint(int orderId)=> '$baseUrl/api/Orders/$orderId';



}