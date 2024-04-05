import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:users_api_deneme/models/user_location.dart';
import 'package:users_api_deneme/models/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Users> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter RestAPI"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          fullName() {
            return user.name.title +
                ' ' +
                user.name.first +
                ' ' +
                user.name.last;
          }

          fullAdress() {
            return user.location.city +
                " " +
                user.location.country +
                " " +
                user.location.state +
                " " +
                user.location.street.name +
                " " +
                user.location.street.number.toString();
          }

          return ListTile(
              leading:
                  CircleAvatar(child: Image.network(user.picture.thumbnail)),
              title: Text(
                fullName(),
                style: TextStyle(
                    color: user.gender == "male" ? Colors.blue : Colors.pink),
              ),
              subtitle: Text(user.email),
              onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            "User İnfo",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Image.network(user.picture.large)),
                            SizedBox(
                              height: 25,
                            ),
                            Text(fullName(),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Text("Gender: " + user.gender),
                            Text("Age: " + user.dob.age.toString()),
                            Text("Email Address: " + user.email),
                            Text("Phone: " + user.phone),
                            Text("Nationality: " + user.nat),
                            Text("Address: " + fullAdress()),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void fetchUsers() async {
    print('fetchUser called');

    const url = 'https://randomuser.me/api/?results=25';
    //Bu satır, isteğin yapılacağı API'nin URL'sini belirtir.
    //Bu örnekte, "randomuser.me" API'sine 10 rastgele kullanıcı bilgisi istenmektedir.

    final uri = Uri.parse(url);
    //URL'yi bir Uri nesnesine dönüştürür. Bu, URL'nin çözümlenmesini ve uygun bir şekilde işlenmesini sağlar.

    final response = await http.get(uri);
    //http adlı bir paketin get metodu kullanılarak, belirtilen URI'ye HTTP GET isteği gönderilir.
    //Bu, API'den veri almak için bir istek oluşturur.
    //await ifadesi, isteğin tamamlanmasını beklemek için kullanılır ve bu isteğin sonucu response adlı değişkene atanır.

    final body = response.body;
    //API'den gelen yanıtın gövdesini alır. Bu, genellikle bir JSON dizesidir ve alınan veriyi içerir.

    final json = jsonDecode(body);
    //body adlı dizeyi JSON formatından Dart nesnelerine dönüştürür.
    //Bu işlem, API'den gelen veriyi kullanılabilir hale getirir ve işlenmesini kolaylaştırır.
    //jsonDecode işlevi, JSON dizesini bir Map<String, dynamic> nesnesine dönüştürür.

    //Bu kod parçası, belirtilen URL'ye bir istek gönderir, gelen yanıtın gövdesini alır, bu gövdeyi JSON'a dönüştürür
    //ve sonuç olarak elde edilen veriyi kullanılabilir hale getirir.

    final results = json['results'] as List<dynamic>;
    final transformed = results.map(
      (e) {
        final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last'],
        );

        final street = LocationStreet(
            number: e['location']['street']['number'],
            name: e['location']['street']['name']);

        final coordinates = LocationCoordinates(
            longitude: e['location']['coordinates']['longitude'],
            latitude: e['location']['coordinates']['latitude']);

        final timezone = LocationTimezone(
            offset: e['location']['timezone']['offset'],
            description: e['location']['timezone']['description']);

        final location = UserLocation(
          city: e['location']['city'],
          country: e['location']['country'],
          state: e['location']['state'],
          postcode: e['location']['postcode'].toString(),
          street: street,
          coordinates: coordinates,
          timezone: timezone,
        );

        final date = e['dob']['date'];
        final dob = UserDob(date: DateTime.parse(date), age: e['dob']['age']);

        final picture = UserPicture(
            large: e['picture']['large'], thumbnail: e['picture']['thumbnail']);

        return Users(
          name: name,
          gender: e['gender'],
          nat: e['nat'],
          email: e['email'],
          phone: e['phone'],
          location: location,
          dob: dob,
          picture: picture,
        );
      },
    ).toList();

    setState(() {
      users = transformed;
    });
    print('fetchUser completed.');
  }
}
