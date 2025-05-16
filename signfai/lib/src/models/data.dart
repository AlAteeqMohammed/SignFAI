class Data {
  int? id;
  String? title;
  String? video;
  int? order;
  bool? locked;

  Data({this.id, this.title, this.video, this.order, this.locked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    video = json['video'];
    order = json['order'];
    locked = json['locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['video'] = video;
    data['order'] = order;
    data['locked'] = locked;
    return data;
  }
}
