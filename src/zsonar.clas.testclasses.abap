CLASS ltcl_sonar DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      count_increased_measurements FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_sonar IMPLEMENTATION.

  METHOD count_increased_measurements.
    data(measurements) =
      |199\n| &&
      |200\n| &&
      |208\n| &&
      |210\n| &&
      |200\n| &&
      |207\n| &&
      |240\n| &&
      |269\n| &&
      |260\n| &&
      |263|.
      data(sonar) = new zsonar( ).
     cl_abap_unit_assert=>assert_equals( msg = 'increased = 7' exp = 7 act = sonar->count_increased( measurements = measurements ) ).
  ENDMETHOD.

ENDCLASS.
