import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'interest_viewmodel.dart';

class InterestView extends StatelessWidget {
  const InterestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InterestViewModel>.reactive(
      viewModelBuilder: () => InterestViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
          appBar: cwAuthAppBar(context, title: 'People', showLeadingIcon: false),
          backgroundColor: Colors.white,
          // appBar: AppBar(toolbarHeight: 0, elevation: 0.0, backgroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          //     model.appBarColorChanger(states.contains(MaterialState.scrolledUnder));
          //     return states.contains(MaterialState.scrolledUnder) ? AppColors.lightGrey : Colors.white;
          //   }),),
          // appBar: AppBar(
          //   leadingWidth: 70,
          //   leading: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Row(
          //         children: [
          //           horizontalSpaceRegular,
          //           ClipOval(
          //             child: Image.asset(
          //               'assets/panda.webp',
          //               cacheHeight: 48,
          //               cacheWidth: 48,
          //               height: 48,
          //               width: 48,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          //   elevation: 0.0,
          //   backgroundColor: Colors.white,
          //   toolbarHeight: 80,
          //   actions: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.person_add_alt_1_sharp),
          //       color: Colors.black54,
          //       iconSize: 32,
          //     ),
          //     horizontalSpaceRegular,
          //   ],
          //   title: const Text(
          //     'friends',
          //     style: TextStyle(
          //         color: Colors.black, fontSize: 26, fontWeight: FontWeight.w700),
          //   ),
          //   automaticallyImplyLeading: false,
          // ),
          body: CustomScrollView(
            slivers: [
              // CupertinoSliverNavigationBar(
              //   backgroundColor: Colors.white,
              //   trailing: Material(
              //     child: IconButton(
              //       icon: const Icon(Icons.search),
              //       onPressed: () {
                      
              //       },
              //     ),
              //   ),
              //   stretch: true,
              //   largeTitle: const Text('People'),
              //   // border: Border.all(width: 0.0,),
              // ),
              
              SliverList(delegate: SliverChildListDelegate([
                ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: interestPersonTile(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: interestPersonTile(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: interestPersonTile(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: interestPersonTile(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: interestPersonTile(),
              ),
            ],
          ),
              ]))
            ],
          )
        ),
      ),
    );
  }
}

interestPersonTile() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network('https://images.unsplash.com/photo-1620598852012-5ebc7712a3b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80', fit: BoxFit.cover,),
                      )
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Veronica', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 5,),
                          Text('Spain', style: TextStyle(color: Colors.grey[500])),
                        ]
                      ),
                    )
                  ]
                ),
              ),
              GestureDetector(
                child: AnimatedContainer(
                  height: 35,
                  padding: const EdgeInsets.all(5),
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300,)
                  ),
                  child: Center(
                    child: Text('Request Friend', style: TextStyle(color: Colors.grey.shade600,),)
                  )
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200
                    ),
                    child: const Text('Normal Life', style: TextStyle(color: Colors.black),),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black26.withAlpha(20)
                    ),
                    child: const Text('Expert', style: TextStyle(color: Colors.black54),),
                  )
                ],
              ),
              Text('1000 yrs', style: TextStyle(color: Colors.grey.shade800, fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }
