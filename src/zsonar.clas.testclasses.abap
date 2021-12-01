CLASS ltcl_sonar DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: measurements TYPE string,
          sonar        TYPE REF TO zsonar.
    METHODS:
      count_increased_measurements FOR TESTING RAISING cx_static_check,
      convert_window_a FOR TESTING RAISING cx_static_check,
      convert_window_b FOR TESTING RAISING cx_static_check,
    convert_window_f FOR TESTING RAISING cx_static_check,
    count_increased_windows FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS ltcl_sonar IMPLEMENTATION.

  METHOD count_increased_measurements.
    cl_abap_unit_assert=>assert_equals( msg = 'increased = 7' exp = 7 act = sonar->count_increased( measurements = measurements ) ).
  ENDMETHOD.

  METHOD setup.
    sonar = NEW zsonar( ).
    measurements =
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

  ENDMETHOD.



  METHOD convert_window_a.
    DATA(window) = sonar->build_windows( measurement_list = measurements ).
    cl_abap_unit_assert=>assert_equals( msg = 'a = 607' exp = 607 act = window[ 1 ] ).
  ENDMETHOD.

  METHOD convert_window_b.
    DATA(window) = sonar->build_windows( measurement_LIST = measurements ).
    cl_abap_unit_assert=>assert_equals( msg = 'b = 618' exp = 618 act = window[ 2 ] ).
  ENDMETHOD.

  METHOD convert_window_F.
    DATA(window) = sonar->build_windows( measurement_LIST = measurements ).
    cl_abap_unit_assert=>assert_equals( msg = 'f = 716' exp = 716 act = window[ 6 ] ).
  ENDMETHOD.

  METHOD count_increased_windows.

    data(inc_win) = sonar->count_increased_win( measurements ).
    cl_abap_unit_assert=>assert_equals( msg = 'increased = 5' exp = 5 act = inc_win ).
  ENDMETHOD.

ENDCLASS.
