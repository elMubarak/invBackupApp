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

  String getLocation() {
    return """
    query getLocations(\$filter:WarehouseLocationFetchInput){
  warehouseLocations(warehouseLocationFetchInput:\$filter){
    data{
      name
    }
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

  String countStock() {
    return """
    mutation createStockCount(\$filter:StockCountCreateInput!){
      createStockCount(stockCountCreateInput:\$filter){
        id
        userId
        warehouseLocationId
        sku
        qty
      }
    }
    """;
  }

  String addItemToLocation() {
    return """
    mutation addWarehouseLocationItem(\$item:WarehouseLocationItemCreateInput!){
      addWarehouseLocationItem(warehouseLocationItemCreateInput: \$item){
        id
        warehouseLocationId
        sku
        name
        qty
        description
      }
    }
    """;
  }

  String NewGRN() {
    return """
    mutation newGRN(\$newReceipt: InboundCreateInput!){
  createGoodsReceipt(inboundCreateInput: \$newReceipt){
    
    
    id
    receiptNo,
    poNo,
    userId
    remark
    statusCode
    createdAt
    updatedAt
    items {
      id
      sku
      qty
      price
      name
      warehouseLocationId
    }
  }
}
    """;
  }

  String getWarehouseLocation() {
    return """
    query getWhareHouseLocation(\$filter:WarehouseLocationFetchInput){
      warehouseLocations(warehouseLocationFetchInput:\$filter){
        data {
          id
          name
          warehouse {
            id
            name
            address
          }
          items{
            id
            name
            sku
            qty
            description
          }
        }
	    }
    }
    """;
  }

  String getLocationItems() {
    return """
    query getLocationItem(\$filter:WarehouseLocationItemFetchInput!){
      warehouseLocationItems(warehouseLocationItemFetchInput:\$filter){
    
        data{
          warehouseLocationId
          id
          name
          sku
          description
          qty
      
          warehouseLocation{
            id
            name
          }
        }
        page
        count
        pages
    
      }
  
    }
    """;
  }
}
