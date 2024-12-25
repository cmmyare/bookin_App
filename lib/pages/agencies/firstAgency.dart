//import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/local/FlightListPage.dart';
//import 'package:booking/pages/Home.dart';
//import 'package:booking/pages/inernational/bookingFormInter.dart';
import 'package:booking/pages/inernational/flightListInter.dart';
import 'package:flutter/material.dart';

class AgencyDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // commentiga ka qaad hadii aaad agencies badan isticmaasho si aad homepage ugu laabatid.
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      //   title: const Center(child: Text("Dere Agency")),

      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomePage()),
      //       );
      //     },
      //   ),
      //   actions: const [
      //     // Bar icons from Components folder
      //     RightIcons(),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade100, // Background color for the page
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Choose Your Flight And Explore The World",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),
                  // Two Containers for Flight Options
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return InterFlightListPage();
                        })),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "International Flight",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FlightListPage();
                        })),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade400,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Local Flight",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 8.0),
            // Most Visited Places Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Most Visited Places",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true, // Allows the grid to scroll inside Column
                physics:
                    const NeverScrollableScrollPhysics(), // Disable internal scroll
                itemCount: 6, // Total number of items
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final imageUrls = [
                    "https://media.architecturaldigest.com/photos/66a951edce728792a48166e6/16:9/w_2560%2Cc_limit/GettyImages-955441104.jpg",
                    "https://www.globalnationalparks.com/wp-content/uploads/national-park-grand-canyon.jpg",
                    "https://cdn.britannica.com/82/94382-050-20CF23DB/Great-Wall-of-China-Beijing.jpg",
                    "https://pbs.twimg.com/media/FB5Zd1uXIAAUDhp.jpg",
                    "https://cdn.mos.cms.futurecdn.net/wtqqnkYDYi2ifsWZVW2MT4-320-80.jpg",
                    "https://www.alluringworld.com/wp-content/uploads/2016/04/1-Jubba.jpg",
                  ];
                  final placeNames = [
                    "Eiffel Tower",
                    "Grand Canyon",
                    "Great Wall",
                    "Al madaw Sanaag",
                    "Eyl beach",
                    "Jubba river",
                  ];

                  return _buildMostVisitedCard(
                    imageUrl: imageUrls[index],
                    placeName: placeNames[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create a most visited place card
  Widget _buildMostVisitedCard({
    required String imageUrl,
    required String placeName,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              imageUrl,
              height: 120.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120.0,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50.0,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              placeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
