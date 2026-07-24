class GameModel {
  final String title;
  final String thumb;
  final String salePrice;
  final String normalPrice;
  final String gameID;
  final String savings; 

  GameModel({
    required this.title,
    required this.thumb,
    required this.salePrice,
    required this.normalPrice,
    required this.gameID,
    required this.savings, 
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      normalPrice: json['normalPrice'] ?? '0',
      gameID: json['gameID'] ?? '',
      savings: json['savings'] ?? '0', 
    );
  }
}