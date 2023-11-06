@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZZTIME_PROJECT'
define root view entity ZZTIME_R_PROJECTTP
  as select from zztime_project
{
  key project_id as ProjectID,
  name as Name,
  descripton as Descripton,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}
