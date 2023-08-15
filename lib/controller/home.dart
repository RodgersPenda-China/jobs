import 'package:get/get.dart';
import 'package:job_search/controller/repo.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/user.dart';
import 'api.dart';
class HomeController extends GetxController implements GetxService {
  final homeRepo HomeRepo;
  HomeController({required this.HomeRepo});

  bool login = false;  var login_response = {};
  login_signup(String role,email, password) async{
    login = true;
    Response response = await HomeRepo.login_signup(role,email,password);
    login_response = response.body;
    login = false;
    update();
  }
  bool google_loading = false; var google_response = []; List<String> google_list = [];
  Future<List<String>> google_autocomplete(String place) async {
    google_loading = true; google_list = [];
    Response response = await HomeRepo.google(place);
    google_response = response.body;
    for(int i = 0; i < google_response.length; i++){
      google_list.add(google_response[i]['name']);
    }
    print(google_list);
    google_loading = false;
    update();
    return google_list;
  }
  bool apply_loading = false;
  var personal_reponse  = {}; //var cvs = [];
  personal_details(String f_name,String l_name,String gender,String phone,location,place_id,List<MultipartBody> image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response response = await HomeRepo.personal_details(token!,f_name, l_name, gender, phone, location,place_id, image);
    personal_reponse = response.body;
    update();
  }
  List<User> user = []; List<Work_Experience> work = [];bool user_loading = false;
  List<Education> edu = [];
  get_user() async {
     user_loading = true; //user = [];
      update();
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     String? token = prefs.getString('token');
     Response response = await HomeRepo.get_user(token!);
     user = UsersModel.fromJson(response.body).user;
     work = UsersModel.fromJson(response.body).work;
     edu = UsersModel.fromJson(response.body).education;
     user_loading = false;
    update();
  }
  //get categories and ty
  List<String> categories = [];
  Future<List<String>> get_categories() async{
    categories = [];
    Response response = await HomeRepo.get_categories();
    var cat = response.body;
    for(int i = 0; i < cat.length;i++){
      categories.add(cat[i]);
    }
    return categories;
  }
  var experience_reponse = {};
  work_experience(String edit,id,title,String company,String position,String category,String work_type,String city,String from,String to,String description) async{
    experience_reponse = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response response = await HomeRepo.work_experience(edit,id,token!, title, company, position, category, work_type, city, from, to, description);
    experience_reponse = response.body;
    update();
  }
  save_jobs(String edit,id,title, salary,experience,education,category,work_type,remoteValue,city,description) async{
    experience_reponse = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response response = await HomeRepo.jobs(edit,id,token!, title, salary,experience,education,category,work_type,remoteValue,city,description);
    experience_reponse = response.body;
    update();
  }
  var education_response = {};
  education(String edit,id,String title,String company,String position,String category,String work_type,String city,String from,String to,String description) async{
    education_response = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response response = await HomeRepo.education(edit,id,token!, title, company, position, category, work_type, city, from, to, description);
    education_response = response.body;
    update();
  }
  var cv_response = {};
  upload_cv(String token,List<MultipartBody> files) async {
    Response response = await HomeRepo.upload_cvs(token,files);
    cv_response = response.body;
    update();
  }
  var cvs = []; bool cv_loading = false;
  get_cv() async {
    cv_loading = true; update();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response response = await HomeRepo.get_cv(token!);
    cvs = response.body;
    cv_loading = false;
    print('cv here');
    update();
  }
  var jobs = []; bool jobs_loading = false;
  get_jobs() async {
    jobs_loading = true; update();
    Response response = await HomeRepo.get_jobs();
    jobs = response.body;
    jobs_loading = false;
    update();
  }
  int loading_from = 0; bool filter_loading = false; var filter_array=[];
  String filter_category = ''; var category_array = {};
  filter(String cat,city,type,remote) async{
    filter_loading = true;  update();
    Response response = await HomeRepo.filter(cat,city,type,remote);
    filter_array = response.body;
    loading_from = 1;
    filter_category = cat;
    filter_loading = false;
    update();
  }
}