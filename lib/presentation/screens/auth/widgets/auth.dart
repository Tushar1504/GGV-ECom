part of 'auth_imports.dart';

@RoutePage()
class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Assets.assetsImagesBg,
          ),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Assets.assetsImagesLogo,
                  height: 42.h,
                  width: 139.w,
                ).centered(),
                const Spacer(),
                "Explore the world, \nBillions of Thoughts"
                    .text
                    .size(28.sp)
                    .fontWeight(FontWeight.w700)
                    .color(Colors.white)
                    .align(TextAlign.left)
                    .make(),
                25.h.heightBox,
                ElevatedButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const LoginRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      42.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        11.r,
                      ),
                    ),
                  ),
                  child: "Login"
                      .text
                      .color(Colors.white)
                      .size(16.sp)
                      .fontWeight(FontWeight.w700)
                      .make(),
                ),
                12.h.heightBox,
                ElevatedButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const RegisterRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      42.h,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(
                        11.r,
                      ),
                    ),
                  ),
                  child: "Register "
                      .text
                      .color(Colors.white)
                      .size(16.sp)
                      .fontWeight(FontWeight.w700)
                      .make(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
