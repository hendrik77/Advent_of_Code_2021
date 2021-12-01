CLASS zcl_sonar DEFINITION CREATE PRIVATE FINAL.

PUBLIC SECTION.

  CLASS-METHODS: create
    RETURNING
      VALUE(ro_obj) TYPE REF TO zcl_sonar.

  METHODS: run.

PROTECTED SECTION.
PRIVATE SECTION.

ENDCLASS.

CLASS zcl_sonar IMPLEMENTATION.

  METHOD create.
    ro_obj = NEW zcl_sonar( ).
  ENDMETHOD.

  METHOD run.
    cl_demo_output=>display( |Hello World!| ).
  ENDMETHOD.

ENDCLASS.