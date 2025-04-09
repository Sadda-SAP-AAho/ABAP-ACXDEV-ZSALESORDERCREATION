@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_SALESORDER_HDR
  as select from zsalesorder_hdr
composition [0..*] of ZR_SALESORDER_LINE as _Items
{
  key displayid as Displayid,
  id as Id,
  name as Name,
  documenttype as Documenttype,
  documentdate as Documentdate,
  documentcurrency as Documentcurrency,
  salesorganization as Salesorganization,
  receiversalesorganization as Receiversalesorganization,
  distributionchannel as Distributionchannel,
  division as Division,
  customer as Customer,
  salesorder as Salesorder,
  sampleowner as Sampleowner,
  salesphase as Salesphase,
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
  
  _Items
  
}
