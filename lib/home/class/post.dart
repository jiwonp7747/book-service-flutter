class Post {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final int price;

  Post({required this.id, required this.title, required this.content, required this.imageUrl, required this.price});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], content: json['content'], imageUrl: json['image_url'], price: json['price']);
  }
}
