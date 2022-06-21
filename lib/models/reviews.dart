import 'dart:convert';

List<Reviews> reviewsFromJson(String str) =>
    List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
  Reviews(
      {required this.customerId,
      required this.traderId,
      required this.stars,
      required this.message,
      required this.givenBy});

  String customerId;
  String traderId;
  String stars;
  String message;
  String givenBy;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        customerId: json["customerId"],
        traderId: json["traderId"],
        stars: json["stars"],
        message: json["message"],
        givenBy: json["givenBy"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "traderId": traderId,
        "stars": stars,
        "message": message,
        "givenBy": givenBy
      };
}
