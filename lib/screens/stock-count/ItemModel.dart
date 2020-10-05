

class ItemModel {
  String id;
  String name;
  String sku;
  String qty;
  String description;

//  List<ModelVideo> myfavourite = [];



  ItemModel(collection) {
    try {
      id = collection['id'].toString();
      sku = collection['sku'].toString();
      qty = collection['qty'].toString();
      description = collection['description'].toString();
      name = collection['name'];

    }catch(Exception){

    }

  }
}

