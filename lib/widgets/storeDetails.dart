import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';

class StoreDetailWidget extends StatelessWidget {
  final Map<String, dynamic> storeDetail;

  const StoreDetailWidget({Key? key, required this.storeDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(
                      "https://locator.iocl.com/files/outlet/outlet_facebook_images/outlet_cover_photo/99528/IOCL_Banner_jpg.jpg"), // Replace with your image asset
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.green, width: 2)),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Card(
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.network(
                              storeDetail['url'],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                storeDetail['address'].replaceAll('\n', ' '),
                                overflow: TextOverflow.visible,
                                style: GoogleFonts.habibi(fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email : ",
                                  style: GoogleFonts.k2d(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 12.5,
                                ),
                                Text(
                                  storeDetail['email'],
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.habibi(fontSize: 12.5),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Ph.No : ",
                                  style: GoogleFonts.k2d(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  storeDetail['mobileno'],
                                  overflow: TextOverflow.clip,
                                  style:
                                      GoogleFonts.daiBannaSil(fontSize: 12.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              "Rating : ",
                              style: GoogleFonts.k2d(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: (storeDetail['rating'] ?? 0).toDouble(),
                                itemBuilder: (_, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20,
                                direction: Axis.horizontal,
                              ),
                              Text("( ${storeDetail['rating']} )")
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              facilities(storeDetail['restroom'] ?? false,
                                  Icons.family_restroom_outlined),
                              facilities(storeDetail['gas'] ?? false,
                                  CupertinoIcons.speedometer),
                              facilities(storeDetail['drinking_water'] ?? false,
                                  Icons.local_drink),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget facilities(bool condition, IconData iconData) {
  return condition
      ? Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Your border color here
                width: 1.0, // Border width
              ),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: ClipRRect(
                child: Icon(
                  iconData,
                  size: 30,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        )
      : const SizedBox();
}
