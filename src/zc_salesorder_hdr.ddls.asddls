@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_SALESORDER_HDR
  provider contract transactional_query
  as projection on ZR_SALESORDER_HDR
  
{
 key Displayid,
 Id,
 Name,
 Documenttype,
 Documentdate,
 Documentcurrency,
 Salesorganization,
 Receiversalesorganization,
 Distributionchannel,
 Division,
 Customer,
 Salesorder,
 Sampleowner,
 Salesphase,
 CreatedBy,
 CreatedAt,
 LastChangedBy,
 LastChangedAt,
 LocalLastChangedAt,
  /* Associations */
    _Items : redirected to composition child ZC_SALESORDER_LINE
  
}
