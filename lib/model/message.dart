class Message {
  String owner;
  String content;
  get getOwner => this.owner;

  set setOwner(owner) => this.owner = owner;

  get getContent => this.content;

  set setContent(content) => this.content = content;

  Message({this.owner, this.content});
}
