class EventTicketType {
  final String id;
  final String title;
  final double price;
  final String? subtitle;

  const EventTicketType({
    required this.id,
    required this.title,
    required this.price,
    this.subtitle,
  });

  EventTicketType copyWith({
    String? id,
    String? title,
    double? price,
    String? subtitle,
  }) {
    return EventTicketType(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}
