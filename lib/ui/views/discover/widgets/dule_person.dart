import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/views/discover/discover_viewmodel.dart';

InkWell dulePerson(DiscoverViewModel model,  FireUser fireUser) {
  final lists = [
    model.usersInterests,
    fireUser.interests,
  ];
  final commonElements =
      lists.fold<Set>(
        lists.first.toSet(), 
        (a, b) => a.intersection(b.toSet()));
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
                            fireUser.photoUrl,
                            // 'https://images.unsplash.com/photo-1620598852012-5ebc7712a3b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fireUser.displayName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(fireUser.country ?? '',
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
          // const SizedBox(
          //   height: 10,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15),
          //   child: Wrap(
          //     children: commonElements.map((e) => Chip(label: Text(e.toString()))).toList(),
          //   ),
          //   // child: Row(
          //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   //   children: [
          //   //     // Row(
          //   //     //   children: [
          //   //     //     Container(
          //   //     //       padding: const EdgeInsets.symmetric(
          //   //     //           vertical: 8, horizontal: 15),
          //   //     //       decoration: BoxDecoration(
          //   //     //           borderRadius: BorderRadius.circular(12),
          //   //     //           color: Colors.grey.shade200),
          //   //     //       child: const Text(
          //   //     //         'Normal Life',
          //   //     //         style: TextStyle(color: Colors.black),
          //   //     //       ),
          //   //     //     ),
          //   //     //     const SizedBox(
          //   //     //       width: 10,
          //   //     //     ),
          //   //     //     Container(
          //   //     //       padding: const EdgeInsets.symmetric(
          //   //     //           vertical: 8, horizontal: 15),
          //   //     //       decoration: BoxDecoration(
          //   //     //           borderRadius: BorderRadius.circular(12),
          //   //     //           color: Colors.black26.withAlpha(20)),
          //   //     //       child: const Text(
          //   //     //         'Expert',
          //   //     //         style: TextStyle(color: Colors.black54),
          //   //     //       ),
          //   //     //     )
          //   //     //   ],
          //   //     // ),
          //   //     // Text(
          //   //     //   '1000 yrs',
          //   //     //   style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
          //   //     // )
          //   //   ],
          //   // ),
          // ),
        ],
      ),
    ),
  );
}