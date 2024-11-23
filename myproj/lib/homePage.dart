import 'userService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = Userservice().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('befr'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  User user = snapshot.data?[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical:
                            10.0), // Adds equal spacing above and below the ListTile
                    child: ListTile(
                      title: Text(user.email),
                      subtitle: Text('${user.name.first} ${user.name.last}'),
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.black, thickness: 1);
                },
                itemCount: snapshot.data!.length,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
