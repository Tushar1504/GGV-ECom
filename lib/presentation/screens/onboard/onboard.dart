part of 'onboard_imports.dart';

@RoutePage()
class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  OnBoardViewModel onBoardViewModel = OnBoardViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                 color: Colors.indigo.shade900,
                  scale: 6,
                ),
                const SizedBox(height: 5,),
                const Text('GGV-ECom', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                PageView(
                  controller: onBoardViewModel.pageController,
                  children: const [
                        OnBoardFirst(),
                        OnBoardSecond(),
                        OnBoardThird()
                  ],
                ).expand(),
                SizedBox(height: 60.h,),
                ElevatedButton(onPressed: () => AutoRouter.of(context).push(const AuthRoute()),
                style:  ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryColor,
                        minimumSize: Size(MediaQuery.of(context).size.width, 42),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11),),
                    ),
                  child:  "Get Started"
                        .text
                        .color(Colors.white)
                        .size(16)
                        .fontWeight(FontWeight.w700)
                        .make(),),
                const SizedBox(height: 70,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Skip".text
                        .color(Colors.black)
                        .size(16)
                        .fontWeight(FontWeight.w700)
                        .make(),
                    SmoothPageIndicator(
                      controller: onBoardViewModel.pageController, // PageController
                      count: 3,
                      effect:  WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          activeDotColor: MyColors.primaryColor
                      ), // your preferred effect
                      onDotClicked: (index) {},),
                    "Next".text
                        .color(
                      Colors.black
                    )
                        .size(16)
                        .fontWeight(FontWeight.w700)
                        .make(),
                  ],),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

