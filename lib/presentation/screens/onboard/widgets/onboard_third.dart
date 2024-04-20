part of 'widgets_imports.dart';

class OnBoardThird extends StatelessWidget {
  const OnBoardThird({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/3.png', height: 333, width: 333,),
        "Discover, engage and read the latest article or as well as share your own thought and ideas with the community."
            .text
            .size(15)
            .align(TextAlign.center)
            .fontWeight(FontWeight.w500)
            .make(),
      ],
    );
  }
}
