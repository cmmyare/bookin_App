// pages/local_model/local_flight_model.dart
class Flight {
  final String id;
  final String fromCity;
  final String toCity;
  final String airplaneName;
  final String flightNumber;
  final String date;
  final String time;
  final double price;

  Flight({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.airplaneName,
    required this.flightNumber,
    required this.date,
    required this.time,
    required this.price,
  });

  factory Flight.fromDocument(Map<String, dynamic> doc, String id) {
    return Flight(
      id: id,
      fromCity: doc['fromCity'],
      toCity: doc['toCity'],
      airplaneName: doc['airplaneName'],
      flightNumber: doc['flightNumber'],
      date: doc['date'],
      time: doc['time'],
      price: double.parse(doc['price'].toString()),
    );
  }
}
