@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZZTIME_R_ENTRYTP'
@Search.searchable: true
@ObjectModel.semanticKey: [ 'EntryID', 'ProjectID' ]
define root view entity ZZTIME_C_ENTRYTP
  provider contract transactional_query
  as projection on ZZTIME_R_ENTRYTP
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      key EntryID,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['ProjectName']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZZTIME_R_PROJECTTP', element: 'ProjectID' } }]
      ProjectID,
      _Project.Name as ProjectName,
      Entrydate,
      Entryhours,
      LocalLastChangedAt

}
