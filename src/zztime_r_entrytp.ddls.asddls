@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED RAP Time Tracking'
define root view entity ZZTIME_R_ENTRYTP 
  as select from zztime_entry as TimeEntry
  association [0..1] to ZZTIME_R_PROJECTTP as _Project on $projection.ProjectID = _Project.ProjectID
{
  key entry_id as EntryID,
  project_id as ProjectID,
  entrydate as Entrydate,
  entryhours as Entryhours,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  // Public Associations
  _Project
  
}
