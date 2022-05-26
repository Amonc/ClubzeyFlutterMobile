class CustomTimer{

  Stream<int> countStream(int to) async* {
    int i=30;
    while(i>=0){

      yield i--;
      await Future.delayed(Duration(seconds: 1));
    }
  }


}
