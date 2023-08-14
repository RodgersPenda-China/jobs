import 'api.dart';

class homeRepo {
  final ApiClient apiClient;
  homeRepo({required this.apiClient});
  login_signup(String role,email,password) async{
    return await apiClient.getData('login_register=1&role=${role}&email=${email}&password=${password}');
  }
  google(String place) async{
    return await apiClient.getData('google=1&place=${place}');
  }
  get_user(String token) async{
    return await apiClient.getData('get_user=1&token=${token}');
  }
  get_categories() async{
    return await apiClient.getData('get_categories=1');
  }
  get_jobs() async{
    return await apiClient.getData('get_jobs=1');
  }
  filter(String cat,city,type,remote) async{
    return await apiClient.getData('get_jobs=1&filter=1&city=${city}&category=${cat}&type=${type}&remote=${remote}');
  }
  get_cv(String token) async{
    return await apiClient.getData('get_cv=1&token=${token}');
  }
  upload_cvs(String token,List<MultipartBody> files) async{
    return await apiClient.postMultipartData('upload_cvs=1&token=${token}',{},files);
  }
  get_types() async{
    return await apiClient.getData('get_type=1');
  }
  work_experience(String token,String title,String company,String position,String category,String work_type,String city,String from,String to,String description) async{
    return await apiClient.postData('work_experience=1&token=${token}&title=${title}&company=${company}&position=${position}&category=${category}'
        '&work_type=${work_type}&city=${city}&from=${from}&to=${to}',{'description':description});
  }
  jobs(String token,title, salary,experience,education,category,work_type,remoteValue,city,description) async{
    return await apiClient.postData('jobs=1&token=${token}&title=${title}&salary=${salary}&experience=${experience}&category=${category}'
        '&work_type=${work_type}&city=${city}&edu=${education}&remote=${remoteValue}',{'description':description});
  }
  education(String token,String title,String company,String position,String category,String work_type,String city,String from,String to,String description) async{
    return await apiClient.postData('education=1&token=${token}&title=${title}&school=${company}&degree=${position}&category=${category}'
        '&work_type=${work_type}&city=${city}&from=${from}&to=${to}',{'description':description});
  }
  personal_details(String token,String f_name,String l_name,String gender,String phone,String location,String place_id,List<MultipartBody> image) async {
    return await apiClient.postMultipartData('personal_details=1&token=${token}&f_name=${f_name}&l_name=${l_name}&gender=${gender}&phone=${phone}&location=${location}&place_id=${place_id}',{'place':place_id},image);
  }
}