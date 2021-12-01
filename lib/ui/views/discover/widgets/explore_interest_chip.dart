import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';

Widget exploreInterestChip(List<String> list, int i) {
  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {},
                      child: Chip(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        backgroundColor: AppColors.lightGrey,
                        label: Text(
                          list[i],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  );
}