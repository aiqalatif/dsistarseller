import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Helper/Color.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                .map(
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          color: white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 18.0,
                                color: white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 100.0,
                                height: 8.0,
                                color: white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 20.0,
                                height: 8.0,
                                color: white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
