CLASS ltcl_sonar DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: measurement_tab TYPE string_table,
          diagnostic_report TYPE string_table,
          sonar        TYPE REF TO zsonar.
    METHODS:
      count_increased_measurements FOR TESTING RAISING cx_static_check,
      convert_window_a FOR TESTING RAISING cx_static_check,
      convert_window_b FOR TESTING RAISING cx_static_check,
      convert_window_f FOR TESTING RAISING cx_static_check,
      count_increased_windows FOR TESTING RAISING cx_static_check,
    count_increased_window_size_1 FOR TESTING RAISING cx_static_check,
    gamma_rate FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS ltcl_sonar IMPLEMENTATION.

  METHOD count_increased_measurements.
    cl_abap_unit_assert=>assert_equals( msg = 'increased = 7' exp = 7 act = sonar->count_increased( measurements = measurement_tab ) ).
  ENDMETHOD.

  METHOD setup.
    sonar = NEW zsonar( ).
    split
          |199\n| &&
          |200\n| &&
          |208\n| &&
          |210\n| &&
          |200\n| &&
          |207\n| &&
          |240\n| &&
          |269\n| &&
          |260\n| &&
          |263|
    AT cl_abap_char_utilities=>newline INTO TABLE measurement_tab.

    split
      |00100\n| &&
      |11110\n| &&
      |10110\n| &&
      |10111\n| &&
      |10101\n| &&
      |01111\n| &&
      |00111\n| &&
      |11100\n| &&
      |10000\n| &&
      |11001\n| &&
      |00010\n| &&
      |01010\n|
    AT cl_abap_char_utilities=>newline INTO TABLE diagnostic_report.
  ENDMETHOD.

  METHOD convert_window_a.
    DATA(window) = sonar->build_windows( measurements = measurement_tab ).
    cl_abap_unit_assert=>assert_equals( msg = 'a = 607' exp = 607 act = window[ 1 ] ).
  ENDMETHOD.

  METHOD convert_window_b.
    DATA(window) = sonar->build_windows( measurements = measurement_tab ).
    cl_abap_unit_assert=>assert_equals( msg = 'b = 618' exp = 618 act = window[ 2 ] ).
  ENDMETHOD.

  METHOD convert_window_f.
    DATA(window) = sonar->build_windows( measurements = measurement_tab ).
    cl_abap_unit_assert=>assert_equals( msg = 'f = 716' exp = 716 act = window[ 6 ] ).
  ENDMETHOD.

  METHOD count_increased_windows.
    DATA(inc_win) = sonar->count_increased_win( measurement_tab ).
    cl_abap_unit_assert=>assert_equals( msg = 'increased = 5' exp = 5 act = inc_win ).
  ENDMETHOD.

  METHOD count_increased_window_size_1.
    sonar->set_windows_size( 1 ).
    DATA(inc_win) = sonar->count_increased_win( measurement_tab ).
    cl_abap_unit_assert=>assert_equals( msg = 'increased = 7' exp = 7 act = inc_win ).
  ENDMETHOD.

  METHOD gamma_rate.

    data(power_consumption) = sonar->calc_power_consumption( diagnostic_report ).
    cl_abap_unit_assert=>assert_equals( msg = 'power consmption = 198' exp = 198 act = power_consumption ).
  ENDMETHOD.

ENDCLASS.
