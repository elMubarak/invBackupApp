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

  String getGrns() {
    return """
    query getGrn(\$filter: InboundFetchInput)
    {
        goodsReceipts(inboundFetchInput: \$filter) {
          data {
          id
          receiptNo,
          poNo,
          items {
            description
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

  // Active now
  String fetchPo() {
    return """
     query fetchPo(\$poVar: PoItemsFetchInput!){
        getPOItems(poItemsFetchInput: \$poVar){
          name, 
          poNo,
          sku,
          qty,
          price,
          total,
          description,
          statusCode
        }
     }
    """;
  }

  String login() {
    return """
    mutation auth(\$authData: LoginInput!){
      authenticate(loginInput: \$authData){
        email
        password
        jwt
        userId
        message
        branchId
        expireAt
        contactName
      }
    }
    """;
  }
}
