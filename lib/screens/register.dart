import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/services/firebase_auth_service.dart';
import 'package:login_app/utils/utils.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  Uint8List? image;

  String? name;
  String? email;
  String? password;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('themes/register.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 90),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://media.istockphoto.com/id/1405522719/photo/man-sitting-indoor-looks-at-camera-participate-in-live-videoconference.jpg?s=612x612&w=0&k=20&c=zTUVs3C45_EOOzUJ4QC0IVKSE9Dmlc1A_aUWvE2th10='),
                              ),
                        Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                              color: Colors.white,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Name",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      //important
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            String message = await FirebaseAuthService.signUp(name!, email!, password!, image);
                            if(message == "Success"){
                              Navigator.pushNamed(context, 'login');
                            }else{
                              await showDialog(context: context, builder: (context) {
                                return const AlertDialog(title: Text('Something went Wrong'),);
                              });
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
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
                            Navigator.pushNamed(context, 'login');
                          },
                          child: const Text(
                            'Sign In',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b)),
                          ),
                        ),
                      ],
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
}
