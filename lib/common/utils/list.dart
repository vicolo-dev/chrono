extension ListUtils<T> on List<T>{
  List<T> rotate(int rotate){
    if(isEmpty) return this;
    var index = rotate % length;
    return sublist(index)..addAll(sublist(0, index));
  }
}
