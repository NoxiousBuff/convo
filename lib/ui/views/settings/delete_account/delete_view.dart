import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';

class DeleteMyAccount extends StatelessWidget {
  const DeleteMyAccount({Key? key}) : super(key: key);

  Widget bulletins(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const Icon(CupertinoIcons.circle_fill,
              color: AppColors.darkGrey, size: 15),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        middle: Row(
          children: [
            Text(
              'Security',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 40),
              const Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.red,
              ),
              const SizedBox(width: 10),
              Text(
                'Deleting your account will:',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColors.red, fontSize: 16),
              )
            ],
          ),
          bulletins('Delete your account from Dule'),
          bulletins('Erase you Letters'),
          bulletins('Delete your all data'),
          const SizedBox(height: 10),
          const Divider(height: 0),
          const SizedBox(height: 50),
          const SizedBox(width: 50),
          Row(
            children: [
              const SizedBox(width: 50),
              const Icon(
                CupertinoIcons.arrow_right_arrow_left_square,
                size: 30,
                color: AppColors.darkGrey,
              ),
              const SizedBox(width: 10),
              Text(
                "Change email instead ?",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black54),
              ),
            ],
          ),
          CupertinoButton.filled(
            child: Text(
              'Change Email',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: AppColors.white),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 180),
          CupertinoButton(
            color: AppColors.red,
            child: Text(
              'Delete My Account',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: AppColors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}