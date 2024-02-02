class CardModel {
  String icon;
  String heading;
  String badge;
  String id;
  Function onTap;

  CardModel({
    required this.icon,
    required this.heading,
    required this.badge,
    required this.id,
    required this.onTap,
  });
}
