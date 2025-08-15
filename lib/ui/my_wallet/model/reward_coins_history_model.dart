class RewardCoinsHistoryModel {
  String? sId;
  String? userId;
  Null videoId;
  Null movieSeries;
  int? type;
  int? coin;
  int? price;
  int? offerPrice;
  String? paymentGateway;
  String? uniqueId;
  String? date;
  String? createdAt;
  String? updatedAt;

  RewardCoinsHistoryModel(
      {this.sId,
      this.userId,
      this.videoId,
      this.movieSeries,
      this.type,
      this.coin,
      this.price,
      this.offerPrice,
      this.paymentGateway,
      this.uniqueId,
      this.date,
      this.createdAt,
      this.updatedAt});

  RewardCoinsHistoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    videoId = json['videoId'];
    movieSeries = json['movieSeries'];
    type = json['type'];
    coin = json['coin'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    paymentGateway = json['paymentGateway'];
    uniqueId = json['uniqueId'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['videoId'] = videoId;
    data['movieSeries'] = movieSeries;
    data['type'] = type;
    data['coin'] = coin;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    data['paymentGateway'] = paymentGateway;
    data['uniqueId'] = uniqueId;
    data['date'] = date;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
