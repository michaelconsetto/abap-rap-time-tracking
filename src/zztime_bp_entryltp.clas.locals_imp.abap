CLASS lhc_zztime_r_entrytp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zztime_r_entrytp
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE zztime_r_entrytp,
      defaultdate FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zztime_r_entrytp~defaultdate.
ENDCLASS.

CLASS lhc_zztime_r_entrytp IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.

    DATA:
      entity TYPE STRUCTURE FOR CREATE zztime_r_entrytp,
      id_max TYPE zztime_entry_id.


    "Ensure ID is not set yet (idempotent)- must be checked when BO is draft-enabled
    LOOP AT entities INTO entity WHERE EntryID IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-zztime_r_entrytp.
    ENDLOOP.

    DATA(entities_wo_id) = entities.
    "Remove the entries with an existing  ID
    DELETE entities_wo_id WHERE EntryID IS NOT INITIAL.


    "determine the first free ID without number range
    "Get max ID from active table
    SELECT SINGLE FROM zztime_entry FIELDS MAX( entry_id ) AS entryID INTO @id_max.
    "Get max ID from draft table
    SELECT SINGLE FROM zztime_entry_d FIELDS MAX( entryid ) INTO @DATA(max_id_draft).
    IF max_id_draft > id_max.
      id_max = max_id_draft.
    ENDIF.


    "Set ID for new instances w/o ID
    LOOP AT entities_wo_id INTO entity.
      id_max += 1.
      entity-EntryID = id_max.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-zztime_r_entrytp.
    ENDLOOP.

  ENDMETHOD.

  METHOD defaultDate.
    "Read instances of the transferred keys
    READ ENTITIES OF ZZTIME_R_ENTRYTP IN LOCAL MODE
     ENTITY ZZTIME_R_ENTRYTP
       FIELDS ( Entrydate )
       WITH CORRESPONDING #( keys )
     RESULT DATA(entries)
     FAILED DATA(read_failed).

    "If date is already set, do nothing, i.e. remove such instances
    DELETE entries WHERE Entrydate IS NOT INITIAL.
    CHECK entries IS NOT INITIAL.

    "set date to system date
    MODIFY ENTITIES OF ZZTIME_R_ENTRYTP IN LOCAL MODE
      ENTITY ZZTIME_R_ENTRYTP
        UPDATE SET FIELDS
        WITH VALUE #( FOR entry IN entries ( %tky    = entry-%tky
                                              Entrydate = cl_abap_context_info=>get_system_date( ) ) )
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).


  ENDMETHOD.

ENDCLASS.
