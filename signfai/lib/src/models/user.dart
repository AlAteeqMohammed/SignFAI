class User {
  String? message;
  Result? result;

  User({this.message, this.result});

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  int? id;
  String? username;
  String? email;
  String? name;
  bool? isAdmin;
  Profile? profile;

  Result(
      {this.id,
      this.username,
      this.email,
      this.name,
      this.isAdmin,
      this.profile});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    name = json['name'];
    isAdmin = json['isAdmin'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['name'] = name;
    data['isAdmin'] = isAdmin;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? companyName;
  bool? isMaint;
  bool? isManager;
  bool? isMangerMaint;
  bool? isEmp;
  int? user;

  Profile(
      {this.id,
      this.companyName,
      this.isMaint,
      this.isManager,
      this.isMangerMaint,
      this.isEmp,
      this.user});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    isMaint = json['isMaint'];
    isManager = json['isManager'];
    isMangerMaint = json['isMangerMaint'];
    isEmp = json['isEmp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['isMaint'] = isMaint;
    data['isManager'] = isManager;
    data['isMangerMaint'] = isMangerMaint;
    data['isEmp'] = isEmp;
    data['user'] = user;
    return data;
  }
}
