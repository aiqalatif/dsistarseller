class AppSettingsModel {
  bool isSMSGatewayOn;
  bool isCityWiseDeliveribility;
  AppSettingsModel({
    required this.isSMSGatewayOn,
    required this.isCityWiseDeliveribility,
  });

  factory AppSettingsModel.fromMap(Map<String, dynamic> data) {
    return AppSettingsModel(
        isSMSGatewayOn: data['authentication_settings'] != null &&
                data['authentication_settings'].isNotEmpty
            ? data['authentication_settings'][0]['authentication_method']
                    .toString()
                    .toLowerCase() ==
                'sms'
            : false,
        isCityWiseDeliveribility: data['system_settings'] != null &&
                data['system_settings'].isNotEmpty
            ? data['system_settings'][0]['city_wise_deliverability'] == "1"
            : false);
  }
}
