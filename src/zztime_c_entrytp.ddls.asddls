@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZZTIME_R_ENTRYTP'
@ObjectModel.semanticKey: [ 'EntryID', 'ProjectID' ]
define root view entity ZZTIME_C_ENTRYTP
  provider contract transactional_query
  as projection on ZZTIME_R_ENTRYTP
{
  key EntryID,
  key ProjectID,
  Entydate,
  Entryhours,
  LocalLastChangedAt
  
}
