
import 'package:flutter/material.dart';
import 'package:washing_schedule/auth/auth.dart';
import 'package:washing_schedule/design_system/list_item.dart';
import 'package:washing_schedule/home/home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String?> futureUserId;

  @override
  void initState() {
    super.initState();
    // todo: replace with profile info
    futureUserId = Future.delayed(const Duration(milliseconds: 400))
        .then((_) => getUserId());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: FutureBuilder<String?>(
        future: futureUserId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(88),
                      ),
                      child: const Icon(Icons.catching_pokemon, size: 88),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ListItem(
                    paddingHorizontal: horizontalPadding,
                    leftItem: Icon(Icons.person_outlined),
                    rightItem: Text('Михалевич Тёмочка'),
                  ),
                  const ListItem(
                    paddingHorizontal: horizontalPadding,
                    leftItem: Icon(Icons.house_outlined),
                    rightItem: Text('Общежитие №4'),
                  ),
                  const ListItem(
                    paddingHorizontal: horizontalPadding,
                    leftItem: Icon(Icons.bed_outlined),
                    rightItem: Text('Комната №127'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('ERROOOOOOOR!!!!');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
