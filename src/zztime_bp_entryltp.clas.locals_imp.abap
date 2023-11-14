CLASS lhc_zztime_r_entrytp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zztime_r_entrytp
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE zztime_r_entrytp.
ENDCLASS.

CLASS lhc_zztime_r_entrytp IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.

    DATA:
      entity           TYPE STRUCTURE FOR CREATE zztime_r_entrytp,
      id_max           TYPE zztime_entry_id,
      " change to abap_false if you get the ABAP Runtime error 'BEHAVIOR_ILLEGAL_STATEMENT'
      use_number_range TYPE abap_bool VALUE abap_false.

    "Ensure ID is not set yet (idempotent)- must be checked when BO is draft-enabled
    LOOP AT entities INTO entity WHERE EntryID IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-zztime_r_entrytp.
    ENDLOOP.

    DATA(entities_wo_id) = entities.
    "Remove the entries with an existing  ID
    DELETE entities_wo_id WHERE EntryID IS NOT INITIAL.

    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = '/DMO/TRV_M'
              quantity          = CONV #( lines( entities_wo_id ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_id INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-zztime_r_entrytp.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-zztime_r_entrytp.
          ENDLOOP.
          EXIT.
      ENDTRY.

      "determine the first free ID from the number range
      id_max = number_range_key - number_range_returned_quantity.
    ELSE.
      "determine the first free ID without number range
      "Get max ID from active table
      SELECT SINGLE FROM zztime_entry FIELDS MAX( entry_id ) AS entryID INTO @id_max.
      "Get max ID from draft table
      SELECT SINGLE FROM zztime_entry_d FIELDS MAX( entryid ) INTO @DATA(max_id_draft).
      IF max_id_draft > id_max.
        id_max = max_id_draft.
      ENDIF.
    ENDIF.

    "Set ID for new instances w/o ID
    LOOP AT entities_wo_id INTO entity.
      id_max += 1.
      entity-EntryID = id_max.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-ZZTIME_R_ENTRYTP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
