class Post {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final int price;
  final String nickname;

  Post({required this.id, required this.title, required this.content, required this.imageUrl, required this.price, required this.nickname});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], content: json['content'], imageUrl: json['image_url'], price: json['price'], nickname: json['nickname']);
  }
}
