//==============================================================================
//========================= All API's here =====================================

import '../Helper/Constant.dart';

final Uri getUserLoginApi = Uri.parse('${baseUrl}login');
final Uri getOrdersApi = Uri.parse('${baseUrl}get_orders');
final Uri updateOrderItemApi = Uri.parse('${baseUrl}update_order_item_status');
final Uri getCategoriesApi = Uri.parse('${baseUrl}get_categories');
final Uri getProductsApi = Uri.parse('${baseUrl}get_products');
final Uri getCustomersApi = Uri.parse('${baseUrl}get_customers');
final Uri getTransactionsApi = Uri.parse('${baseUrl}get_transactions');
final Uri getStatisticsApi = Uri.parse('${baseUrl}get_statistics');
final Uri forgotPasswordApi = Uri.parse('${baseUrl}forgot_password');
final Uri deleteOrderApi = Uri.parse('${baseUrl}delete_order');
final Uri verifyUserApi = Uri.parse('${baseUrl}verify_user');
final Uri getVerifyOtpApi = Uri.parse('${baseUrl}verify_otp');
final Uri getResendOtpApi = Uri.parse('${baseUrl}resend_otp');
final Uri getSettingsApi = Uri.parse('${baseUrl}get_settings');
final Uri updateFcmApi = Uri.parse('${baseUrl}update_fcm');
final Uri getCitiesApi = Uri.parse('${baseUrl}get_cities');
final Uri getAreasByCityIdApi = Uri.parse('${baseUrl}get_areas_by_city_id');
final Uri getZipcodesApi = Uri.parse('${baseUrl}get_zipcodes');
final Uri getTaxesApi = Uri.parse('${baseUrl}get_taxes');
final Uri sendWithDrawalRequestApi =
    Uri.parse('${baseUrl}send_withdrawal_request');
final Uri getWithDrawalRequestApi =
    Uri.parse('${baseUrl}get_withdrawal_request');
final Uri getAttributeSetApi = Uri.parse('${baseUrl}get_attribute_set');
final Uri getAttributesApi = Uri.parse('${baseUrl}get_attributes');
final Uri getAttributrValuesApi = Uri.parse('${baseUrl}get_attribute_values');
final Uri addProductsApi = Uri.parse('${baseUrl}add_products');
final Uri getMediaApi = Uri.parse('${baseUrl}get_media');
final Uri getSellerDetailsApi = Uri.parse('${baseUrl}get_seller_details');
final Uri updateUserApi = Uri.parse('${baseUrl}update_user');
final Uri getDeliveryBoysApi = Uri.parse('${baseUrl}get_delivery_boys');
final Uri getDeleteProductApi = Uri.parse('${baseUrl}delete_product');
final Uri editProductApi = Uri.parse('${baseUrl}update_products');
final Uri registerApi = Uri.parse('${baseUrl}register');
final Uri uploadMediaApi = Uri.parse("${baseUrl}upload_media");
final Uri getProductRatingApi = Uri.parse("${baseUrl}get_product_rating");
final Uri getOrderTrackingApi = Uri.parse("${baseUrl}get_order_tracking");
final Uri editOrderTrackingApi = Uri.parse("${baseUrl}edit_order_tracking");
final Uri getSalesListApi = Uri.parse("${baseUrl}get_sales_list");
final Uri updateProductStatusAPI = Uri.parse("${baseUrl}update_product_status");
final Uri getCountriesDataApi = Uri.parse("${baseUrl}get_countries_data");
final Uri addProductFaqsApi = Uri.parse("${baseUrl}add_product_faqs");
final Uri getProductFaqsApi = Uri.parse("${baseUrl}get_product_faqs");
final Uri deleteProductFaqApi = Uri.parse("${baseUrl}delete_product_faq");
final Uri editProductFaqApi = Uri.parse("${baseUrl}edit_product_faq");
final Uri deleteSellerApi = Uri.parse("${baseUrl}delete_seller");
final Uri getBrandsDataApi = Uri.parse("${baseUrl}get_brands_data");
final Uri manageStockApi = Uri.parse("${baseUrl}manage_stock");
final Uri sendDigitalProductMailApi =
    Uri.parse("${baseUrl}send_digital_product_mail");
final Uri getPickUpLocationApi = Uri.parse("${baseUrl}get_pickup_locations");
final Uri addPickUpLocationApi = Uri.parse("${baseUrl}add_pickup_location");
final Uri createShipRocketOrderApi =
    Uri.parse("${baseUrl}create_shiprocket_order");
final Uri generateAWBApi = Uri.parse("${baseUrl}generate_awb");
final Uri sendPickUpRequestApi = Uri.parse("${baseUrl}send_pickup_request");
final Uri cancelShipRocketOrderApi =
    Uri.parse("${baseUrl}cancel_shiprocket_order");
final Uri generateLabelApi = Uri.parse("${baseUrl}generate_label");
final Uri downloadLabelApi = Uri.parse("${baseUrl}download_label");
final Uri generateInvoiceApi = Uri.parse("${baseUrl}generate_invoice");
final Uri downloadInvoiceApi = Uri.parse("${baseUrl}download_invoice");
final Uri shipRocketOrderTrackingApi =
    Uri.parse("${baseUrl}shiprocket_order_tracking");
final Uri getShipRocketOrderApi = Uri.parse("${baseUrl}get_shiprocket_order");

//
//Seller to user and group chat urls
final Uri getPersonalChatListApi = Uri.parse('${chatBaseUrl}get_chat_history');
final Uri getGroupChatListApi = Uri.parse('${chatBaseUrl}get_groups');
final Uri readMessagesApi = Uri.parse('${chatBaseUrl}mark_msg_read');
final Uri getConversationApi = Uri.parse('${chatBaseUrl}load_chat');
const String sendMessageApi = '${chatBaseUrl}send_msg';
final Uri searchUserApi = Uri.parse('${chatBaseUrl}search_user');
final Uri createGroupApi = Uri.parse('${chatBaseUrl}create_group');
final Uri editGroupApi = Uri.parse('${chatBaseUrl}edit_group');
final Uri deleteGroupApi = Uri.parse("${chatBaseUrl}delete_group");
//