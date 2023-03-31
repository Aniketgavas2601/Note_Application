import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_app/services/firebase_auth_service.dart';
import 'package:login_app/services/google_auth.dart';

class MyLogin extends StatefulWidget {

  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('themes/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 90),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 300, right: 35, left: 35),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () async {
                            String result = await FirebaseAuthService.signIn(emailController.text, passwordController.text);
                            print(result);
                            if(result == 'Successfully login'){
                              Navigator.of(context).pushReplacementNamed('homePage');
                            }else{
                              showDialog(context: context, builder: (context){
                                return const AlertDialog(
                                  title: Text('Enter Field Correctly'),
                                );
                              });
                            }
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4c505b)),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            )),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        //SignIn with google
                        signInWithGoogle(context);
                      },
                      label: const Text(
                        'Sign In With Google',
                        style: TextStyle(color: Colors.black54),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.grey[700])),
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//Method for AutoLogin without SharedPreference Network

// @override
// void initState(){
//   super.initState();
//   checkLogin();
// }
//
//
// void checkLogin() async {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final user = await auth.currentUser;
//
//   if(user != null){
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
//   }
// }
}
