part of 'widgets_imports.dart';

class OnBoardFirst extends StatelessWidget {
  const OnBoardFirst({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/1.png', height: 333.h, width: 333.w,),
        "Discover, engage and read the latest article or as well as share your own thought and ideas with the community."
            .text
            .size(15.sp)
            .align(TextAlign.center)
            .fontWeight(FontWeight.w500)
            .make(),
      ],
    );
  }
}
