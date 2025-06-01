class Driver {
  final String name;
  final String phone;
  final String picture;
  final String age;
  final String rating;
  final String birth;
  const Driver(this.name, this.phone, this.picture, this.age, this.rating, this.birth);
}

final List<Driver> people = _people
    .map((e) => Driver(
        e['name'] as String,
        e['phone'] as String,
        e['picture'] as String,
        e['age'] as String,
        e['rating'] as String,
        e['birth'] as String,
    ))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "name": "Sandal",
    "phone": "+62 987-548-3165",
    "picture":
        "https://i.pinimg.com/564x/71/1f/c0/711fc0f41b1316c2d8d265b4bbec1880.jpg",
    "age": "30",
    "rating": "4.5",
    "birth": "1994-08-15",
  },
  {
    "name": "Nyangkut",
    "phone": "+62 892-586-3072",
    "picture":
        "https://i.pinimg.com/564x/b4/84/1c/b4841c4d01a8495b976531a55b5b615c.jpg",
    "age": "34",
    "rating": "4.8",
    "birth": "1990-02-22",
  },
  {
    "name": "Di Pohon",
    "phone": "+62 927-536-3003",
    "picture":
        "https://i.pinimg.com/564x/fe/ea/cd/feeacd0aa22bd3aface7d7ba11c01364.jpg",
    "rating": "4.3",
    "age": "28",  
    "birth": "1996-05-09",
  }
];
