@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZZTIME_R_PROJECTTP'
@ObjectModel.semanticKey: [ 'ProjectID' ]
define root view entity ZZTIME_C_PROJECTTP
  provider contract transactional_query
  as projection on ZZTIME_R_PROJECTTP
{
  key ProjectID,
  Name,
  Descripton,
  LocalLastChangedAt
  
}
