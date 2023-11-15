CLASS zztime_cl_generator DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zztime_cl_generator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


*   clear data
    DELETE  FROM ZZTIME_entry_D.
    DELETE  FROM ZZTIME_entry.



    COMMIT WORK.
    out->write( ' data intitialization finished ' ).
  ENDMETHOD.
ENDCLASS.
