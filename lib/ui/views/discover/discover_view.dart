import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


import 'discover_viewmodel.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiscoverViewModel>.reactive(
      viewModelBuilder: () => DiscoverViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.refreshCcw),
                color: Colors.black,
                iconSize: 24,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.pocket),
                color: Colors.black,
                iconSize: 24,
              ),
              horizontalSpaceSmall
            ],
            elevation: 0.0,
            toolbarHeight: 60,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark),
            title: const Text(
              'Discover',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 32),
            ),
            backgroundColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              return states.contains(MaterialState.scrolledUnder)
                  ? Colors.grey.shade50
                  : Colors.white;
            }),
            leadingWidth: 0,
          ),
          backgroundColor: Colors.white,
          body: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                verticalSpaceMedium,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Today\'s Top Picks',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                verticalSpaceRegular,
                // SizedBox(
                //   height: 30,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: 20,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         child: AnimatedContainer(
                //           height: 35,
                //           margin: const EdgeInsets.symmetric(horizontal: 8),
                //           padding: const EdgeInsets.all(5),
                //           duration: const Duration(milliseconds: 300),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(12),
                //               border: Border.all(
                //                 color: Colors.grey.shade300,
                //               )),
                //           child: Center(
                //             child: Text(
                //               'Chat',
                //               style: TextStyle(
                //                 color: Colors.grey.shade600,
                //                 fontSize: 18
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                interestPersonTile(),
                interestPersonTile(),
                interestPersonTile(),
                interestPersonTile(),
                interestPersonTile(),
              ]),
        ),
      ),
    );
  }
}

interestPersonTile() {
  return InkWell(
    borderRadius: BorderRadius.circular(28),
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1620598852012-5ebc7712a3b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Veronica',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Spain',
                                style: TextStyle(color: Colors.grey[500])),
                          ]),
                    )
                  ]),
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        )),
                    child: Center(
                        child: Icon(
                      FeatherIcons.heart,
                      color: Colors.grey.shade600,
                      size: 20,
                    )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200),
                      child: const Text(
                        'Normal Life',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black26.withAlpha(20)),
                      child: const Text(
                        'Expert',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  ],
                ),
                Text(
                  '1000 yrs',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                )
              ],
            ),
          ),
          // const Divider(),
        ],
      ),
    ),
  );
}

            // GestureDetector(
            //   child: AnimatedContainer(
            //       height: 35,
            //       padding: const EdgeInsets.all(5),
            //       duration: const Duration(milliseconds: 300),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(12),
            //           border: Border.all(
            //             color: Colors.grey.shade300,
            //           )),
            //       child: Center(
            //           child: Text(
            //         'Chat',
            //         style: TextStyle(
            //           color: Colors.grey.shade600,
            //         ),
            //       ),),),
            // ),
            // horizontalSpaceTiny,