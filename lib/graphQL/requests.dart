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

  String getGrns(String poNo) {
    return """
 getGRNs{
  goodsReceipts {
    data {
      id
      receiptNo,
      poNo,
      userId
      createdAt
      items {
        id
        sku
        qty
        price
        name
        warehouseLocationId
      }
    }
    count
    page
    pages
  }
}

    """;
  }

  String getGrnFillter(String grnsFilter) {
    return """
    query getGRNsWithParams($grnsFilter: InboundFetchInput){
  goodsReceipts(inboundFetchInput: $grnsFilter) {
    data {
      id
      receiptNo,
      poNo,
      items {
        id,
        sku
        name
        qty
      }
    }
    count
    page
    pages
  }
}
    """;
  }
}
