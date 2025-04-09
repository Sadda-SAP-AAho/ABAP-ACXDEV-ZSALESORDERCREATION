@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_SALESORDER_LINE
  as select from zsalesorder_line
  association to parent ZR_SALESORDER_HDR as _Order on $projection.Displayid = _Order.Displayid
  
{
  key displayid as Displayid,
  key linenumber as Linenumber,
  product as Product,
  description as Description,
  uom as Uom,
  requestedquantity as Requestedquantity,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  _Order
  
}
