class Flight {
  final String flightId;
  final String fromCity;
  final String toCity;
  final String airplaneName;
  final String flightNumber;
  final String date;
  final String time;
  final bool hasTransit;
  final String transitCity;
  final String transitTime;
  final double price;

  Flight({
    required this.flightId,
    required this.fromCity,
    required this.toCity,
    required this.airplaneName,
    required this.flightNumber,
    required this.date,
    required this.time,
    required this.hasTransit,
    required this.transitCity,
    required this.transitTime,
    required this.price,
  });
}
