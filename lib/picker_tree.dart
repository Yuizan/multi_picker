class Node<T>{
  int k;
  T v;
  List<Node> children;

  Node(this.k, this.v){
    this.k = k;
    this.v = v;
    this.children = new List<Node>();
  }

}

class PickerTree<T>{

  List<Node> root;

  PickerTree();

  void add(int k, T v){
    if(root == null){
      root = new List();
      root.add(new Node(k, v));
      return;
    }

    _retrieveAndAdd(k, v, root);

  }

  _retrieveAndAdd(int k, T v, List<Node> children){
    bool isFind = false;
    for(int i = 0; i < children.length; i++){
      Node node = children[i];
      if(node.k == k){
        node.v = v;
        isFind = true;
        return;
      }

      if(node.k.toString() == k.toString().substring(0, children.first.k.toString().length)){
        _retrieveAndAdd(k, v, node.children);
        return;
      }
    }

    if(!isFind){
      Node newNode = new Node(k, v);
      children.add(newNode);
      return;
    }
  }

  Node get(k){
    Node node = _retrieve(k, root);
    return node;
  }

  Node _retrieve(int k, List<Node> children){
    for(int i = 0; i < children.length; i++){
      Node node = children[i];
      if(node.k == k){
        return node;
      }

      if(node.k.toString() == k.toString().substring(0, children.first.k.toString().length)){
        Node n = _retrieve(k, node.children);
        return n;
      }
    }
    return null;
  }
}

