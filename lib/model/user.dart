import 'dart:convert';

UsersModel configModelFromJson(String str) => UsersModel.fromJson(json.decode(str));

class UsersModel{
  List<User> user; List<Work_Experience> work;
  List<Education> education;
  UsersModel({required this.user,required this.work,required this.education});
  factory UsersModel.fromJson(Map<String, dynamic> json)=> UsersModel(
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    education: List<Education>.from(json["learn"].map((x) => Education.fromJson(x))),
    work: List<Work_Experience>.from(json["work"].map((x) => Work_Experience.fromJson(x))),
  );
}
class User {
  String id, name, gender, phone, email, location, place_id, image,description,candidate,
  f_name,l_name;
  var job;

  User(
      {required this.id, required this.name, required this.gender, required this.phone,
        required this.email, required this.location, required this.place_id, required this.image,
      required this.description,required this.candidate,required this.job,
      required this.f_name, required this.l_name});

  factory User.fromJson(Map<String, dynamic> json)=>
      User(
        id: json["id"] ?? '',
        name: json["name"] ?? 'Please Edit',
        f_name: json["f_name"],
        l_name: json["l_name"],
        candidate: json["candidate"],
        job: json["job"]??'No Description',
        description: json["description"] ?? 'Please Edit',
        phone: json["phone"] ?? 'Please Edit',
        email: json["email"] ?? 'Please Edit',
        location: json["location"] ?? 'Please Edit',
        place_id: json["place_id"] ?? 'Please Edit',
        image: json["image"] ?? 'Please Edit',
        gender: json["gender"] ?? 'Please Edit',
        // description: json["description"] ?? '',
      );
}
  class Work_Experience{
  String id,title,company,work_from,work_to,position,description,city,category,work_type;
  Work_Experience({required this.id,required this.title,required this.work_from,required this.work_to,
  required this.position,required this.description,required this.city, required this.company,
    required this.category,required this.work_type});
  factory Work_Experience.fromJson(Map<String, dynamic> json)=> Work_Experience(
  id: json["id"]??'',
    title: json["title"] ?? 'Please Edit',
    company: json["company"] ?? 'Please Edit',
    work_from: json["work_from"] ?? 'Please Edit',
    work_to: json["work_to"] ?? 'Please Edit',
    position: json["position"] ?? 'Please Edit',
    description: json["description"] ?? 'Please Edit',
    city: json["city"] ?? 'Please Edit',
    category: json["category"] ?? 'Please Edit',
    work_type: json["work_type"] ?? 'Please Edit',
  );
}

class Education{
  String id,title,school,learn_from,learn_to,degree,description,city,category,school_type;
  Education({required this.id,required this.title,required this.learn_from,required this.learn_to,
    required this.degree,required this.description,required this.city, required this.school,
    required this.category,required this.school_type});
  factory Education.fromJson(Map<String, dynamic> json)=> Education(
    id: json["id"]??'',
    title: json["title"] ?? 'Please Edit',
    school: json["school"] ?? 'Please Edit',
    learn_from: json["learn_from"] ?? 'Please Edit',
    learn_to: json["learn_to"] ?? '',
    degree: json["degree"] ?? 'Please Edit',
    description: json["description"] ?? 'Please Edit',
    city: json["city"] ?? 'Please Edit',
    category: json["category"] ?? 'Please Edit',
    school_type: json["school_type"] ?? 'Please Edit',
  );
}