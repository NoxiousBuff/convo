import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/fonts.dart';
import 'package:hint/ui/components/pickers/text_editor/view_model.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({Key? key}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  double height = 1.0;
  double fontSize = 20.0;
  bool showColors = false;
  bool sliderPosition = false;
  bool heightVisibility = false;
  Color textColor = Colors.white;

  bool heightSliderPosition = false;


  TextAlign textAlign = TextAlign.start;
  String? fontFamily = GoogleFonts.aBeeZee().fontFamily!;
  final provider = ChangeNotifierProvider((ref) => TextEditorViewModel());

  Widget fontList() {
    return Container(
      height: 50,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: fonts.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              setState(() {
                fontFamily = fonts[i];
              });
            },
            child: CircleAvatar(
              backgroundColor:
                  fontFamily == fonts[i] ? Colors.white : Colors.black,
              maxRadius: 20,
              child: Center(
                child: Text(
                  'Aa',
                  style: TextStyle(
                      fontFamily: fonts[i],
                      color:
                          fontFamily == fonts[i] ? Colors.black : Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final viewModel = watch(provider);
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.hand_draw,
                    color: heightVisibility ? activeBlue : systemBackground),
                onPressed: () {
                  setState(() {
                    heightVisibility = !heightVisibility;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  showColors
                      ? CupertinoIcons.color_filter_fill
                      : CupertinoIcons.color_filter,
                  color: showColors ?  activeBlue : systemBackground,
                ),
                onPressed: () {
                  setState(() {
                    showColors = !showColors;
                  });
                },
              ),
              IconButton(
                icon:
                    Icon(textMode[viewModel.index].icon, color:systemBackground),
                onPressed: () {
                  if (viewModel.index == 2) {
                    viewModel.resetIndex();
                  } else {
                    viewModel.increseIndex();
                  }
                },
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SizedBox(
                    height: 200,
                    child: CupertinoTextField(
                      maxLines: 6,
                      textAlign: textMode[viewModel.index].textAlign!,
                      placeholder: 'Write Here',
                      style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          height: height),
                      decoration: const BoxDecoration(),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: MediaQuery.of(context).size.height * 0.3,
                left: sliderPosition ? 10.0 : -20.0,
                child: SizedBox(
                  height: 200,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: CupertinoSlider(
                      min: 20,
                      max: 100,
                      value: fontSize,
                      onChangeStart: (val) {
                        setState(() {
                          sliderPosition = true;
                        });
                      },
                      onChanged: (val) {
                        setState(() {
                          fontSize = val;
                        });
                      },
                      onChangeEnd: (val) {
                        setState(() {
                          sliderPosition = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: MediaQuery.of(context).size.height * 0.3,
                right: heightSliderPosition ? 5.0 : -20.0,
                child: Visibility(
                  visible: heightVisibility,
                  child: SizedBox(
                    height: 200,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: CupertinoSlider(
                        min: 0.5,
                        max: 1.0,
                        activeColor: dirtyWhite,
                        value: height,
                        onChangeStart: (val) {
                          setState(() {
                            heightSliderPosition = true;
                          });
                        },
                        onChanged: (val) {
                          setState(() {
                            height = val;
                          });
                        },
                        onChangeEnd: (val) {
                          setState(() {
                            heightSliderPosition = false;
                            heightVisibility = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Visibility(
                  visible: showColors,
                  child: FastColorPicker(
                    selectedColor: textColor,
                    icon: CupertinoIcons.paintbrush,
                    onColorSelected: (_color) {
                      setState(() {
                        textColor = _color;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: fontList(),
        );
      },
    );
  }
}

List<TextModeData> textMode = [
  const TextModeData(
      icon: CupertinoIcons.text_aligncenter, textAlign: TextAlign.center),
  const TextModeData(icon: CupertinoIcons.text_alignleft, textAlign: TextAlign.start),
  const TextModeData(icon: CupertinoIcons.text_alignright, textAlign: TextAlign.end),
];

@immutable
class TextModeData {
  final IconData? icon;
  final TextAlign? textAlign;

  const TextModeData({
    this.icon,
    this.textAlign,
  });
}