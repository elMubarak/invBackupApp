class Requests {
  String getReceipts(int id) {
    return """
    {
      goodsReceipt(id: $id){
        id
        warehouseId
        poNo
        receiptNo
        items{
          id
     	    price
          sku
          total
        }
      }
    }
    """;
  }
}
