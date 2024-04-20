part of 'login_imports.dart';

@RoutePage()
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernamefocusNode = FocusNode();
  final _passwordfocusNode = FocusNode();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              AutoRouter.of(context).replace(HomePageRoute());
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? "Login failed")),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        Assets.assetsImagesLogin,
                        height: 42.h,
                        width: 139.w,
                      ).centered(),
                      const SizedBox(height: 101),
                      Container(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              50.h.heightBox,
                              "Login"
                                  .text
                                  .size(18.sp)
                                  .color(MyColors.primaryColor)
                                  .fontWeight(FontWeight.w700)
                                  .makeCentered(),
                              48.h.heightBox,
                              "Username".text.make(),
                              8.h.heightBox,
                              VxTextField(
                                focusNode: _usernamefocusNode,
                                controller: userNameController,
                                fillColor: Colors.transparent,
                                borderColor: MyColors.primaryColor,
                                borderType: VxTextFieldBorderType.roundLine,
                                borderRadius: 10,
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: MyColors.primaryColor),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Username is empty.";
                                  }
                                  return null;
                                },
                              ),
                              20.h.heightBox,
                              "Password".text.make(),
                              8.h.heightBox,
                              VxTextField(
                                focusNode: _passwordfocusNode,
                                controller: passwordController,
                                isPassword: true,
                                fillColor: Colors.transparent,
                                borderColor: MyColors.primaryColor,
                                borderType: VxTextFieldBorderType.roundLine,
                                borderRadius: 10,
                                prefixIcon: Icon(Icons.lock_outlined,
                                    color: MyColors.primaryColor),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Password is empty";
                                  }
                                  return null;
                                },
                              ),
                              40.h.heightBox,
                              Row(
                                children: [
                                  Checkbox(value: _rememberMe, onChanged: (bool? value){
                                setState(() {
                                  _rememberMe = value!;
                                });
                              }),
                                Text('Remember me', style: TextStyle(color: Colors.black),),
                                ],
                              ),

                              CommonButton(
                                  title: "Login",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SignInBloc>().add(
                                          SignInRequiredEvent(
                                              userName: userNameController.text,
                                              password: passwordController.text,
                                              rememberMe: _rememberMe,
                                          ));
                                    }
                                    _usernamefocusNode.unfocus();
                                    _passwordfocusNode.unfocus();
                                  }
                                  ),
                              20.h.heightBox,
                              "Don’t have an account?"
                                  .richText
                                  .size(14)
                                  .bold
                                  .color(MyColors.primaryColor)
                                  .withTextSpanChildren([
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => AutoRouter.of(context)
                                          .push(const RegisterRoute()),
                                    text: " Sign Up",
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontWeight: FontWeight.w700))
                              ]).makeCentered()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}