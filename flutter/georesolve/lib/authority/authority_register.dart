import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthorityRegister extends StatefulWidget {
  const AuthorityRegister({super.key});

  @override
  State<AuthorityRegister> createState() => _RegisterState();
}

class _RegisterState extends State<AuthorityRegister> {
  final supabase = Supabase.instance.client;
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? role;
  String? district;
  List<String> roles = ['role1', 'role2', 'role3', 'role4', 'role5'];
  List<String> districts = [
    'Krishna',
    'Prakasam',
    'West Godavari',
    'East Godavari',
  ];
  Color mainColor = Color(0xFF201a4a);
  Color backgroundColor = Color(0xFFfef7ff);

  void addUser() async {
    final space = " ";
    final name = nameController.text;
    final username = usernameController.text;
    final mail = mailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    try {
      if (!mail.contains('@')) {
        throw Exception("enter valid email");
      }
      if (password != confirmPassword) {
        throw Exception("The Passwords do not match");
      }
      if (name.contains(space) ||
          username.contains(space) ||
          mail.contains(space) ||
          password.contains(space) ||
          confirmPassword.contains(space)) {
        throw Exception("No field can contain space");
      }
      if (name.isEmpty ||
          username.isEmpty ||
          mail.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        throw Exception("Enter all fields");
      }
      var result = await supabase
          .from('profiles')
          .select()
          .eq("username", username)
          .eq("name", name)
          .eq("email", mail);
      if (result.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("User doesn't exists")));
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("User registered successfully"),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (err) {
      var message = err.toString();
      message = message.replaceAll("Exception:", "");
      if (message.contains('duplicate key')) {
        message = "User already exists";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $message"),
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,

            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset(0, -10),
                  child: Container(
                    height: 75.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Name",
                          counterText: "",
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                        maxLength: 50,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Username",
                          counterText: "",
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                        maxLength: 50,
                      ),
                      const SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        value: role,
                        decoration: InputDecoration(
                          fillColor: backgroundColor,
                          filled: true,
                          labelText: "Role",
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        items: roles.map((String roleItem) {
                          return DropdownMenuItem(
                            value: roleItem,
                            child: Text(roleItem),
                          );
                        }).toList(),
                        onChanged: (String? selectedRole) {
                          role = selectedRole;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        value: district,
                        decoration: InputDecoration(
                          fillColor: backgroundColor,
                          filled: true,
                          labelText: "Districts",
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        items: districts.map((String districtItem) {
                          return DropdownMenuItem(
                            value: districtItem,
                            child: Text(districtItem),
                          );
                        }).toList(),
                        onChanged: (String? selectedDistrict) {
                          district = selectedDistrict;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Mail",
                          counterText: "",
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                        maxLength: 50,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Password",
                          counterText: "",
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                        obscuringCharacter: "*",
                        obscureText: true,
                        maxLength: 50,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Confirm Password",
                          counterText: "",
                          filled: true,
                          fillColor: backgroundColor,
                        ),
                        obscuringCharacter: "*",
                        obscureText: true,
                        maxLength: 50,
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: () => addUser(),
                        style: TextButton.styleFrom(
                          backgroundColor: backgroundColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: mainColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Signup",
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
