@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_SALESORDER_LINE
  as projection on ZR_SALESORDER_LINE
{
  key Displayid,
  key Linenumber,
  Product,
  Description,
  Uom,
  Requestedquantity,
  Salesorder,
  Salesorderitem,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  
  /** Associations */
    _Order : redirected to parent ZC_SALESORDER_HDR
  
}
