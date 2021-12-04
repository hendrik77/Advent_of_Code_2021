CLASS ltcl_diagnostics DEFINITION DEFERRED.
CLASS zsubmarine_diagnostics DEFINITION LOCAL FRIENDS ltcl_diagnostics.
CLASS ltcl_diagnostics DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA diagnostics TYPE REF TO zsubmarine_diagnostics.
    METHODS setup.
    METHODS gamma_rate FOR TESTING RAISING cx_static_check.
    METHODS most_common_1 FOR TESTING RAISING cx_static_check.
    METHODS most_common_2 FOR TESTING RAISING cx_static_check.
    METHODS reduce_list_1 FOR TESTING RAISING cx_static_check.
    METHODS o2_rating_23 FOR TESTING RAISING cx_static_check.
    METHODS co2_rating_10 FOR TESTING RAISING cx_static_check.
    METHODS life_support_230 FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_diagnostics IMPLEMENTATION.

  METHOD setup.
    diagnostics = NEW zsubmarine_diagnostics( ).

  ENDMETHOD.
  METHOD gamma_rate.
    SPLIT
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
    |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).
    DATA(power_consumption) = diagnostics->calc_power_consumption( diagnostic_report ).
    cl_abap_unit_assert=>assert_equals( msg = 'power consmption = 198' exp = 198 act = power_consumption ).
  ENDMETHOD.

  METHOD most_common_1.
    SPLIT
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
    |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).
    diagnostics->calc_binary( diagnostic_report ).
    DATA(most_1) = diagnostics->gamma_binary(1).
    cl_abap_unit_assert=>assert_equals( msg = 'most common first Pos = 1' exp = |1| act = most_1 ).
  ENDMETHOD.

  METHOD most_common_2.
    SPLIT
    |11110\n| &&
    |10110\n| &&
    |10111\n| &&
    |10101\n| &&
    |11100\n| &&
    |10000\n| &&
    |11001\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).
    diagnostics->calc_binary( diagnostic_report ).
    DATA(most_2) = diagnostics->gamma_binary+1(1).
    cl_abap_unit_assert=>assert_equals( msg = '2nd round - 2 pos = 0' exp = |0| act = most_2 ).
  ENDMETHOD.

  METHOD reduce_list_1.
    SPLIT
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
    |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).
    DATA(reduced_list) = diagnostics->reduce_list( list = diagnostic_report pos = 0 val = 1 ).

    SPLIT
    |11110\n| &&
    |10110\n| &&
    |10111\n| &&
    |10101\n| &&
    |11100\n| &&
    |10000\n| &&
    |11001\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(expected_list).
    cl_abap_unit_assert=>assert_equals( msg = 'list with only 1 at position 1' exp = expected_list act = reduced_list ).
  ENDMETHOD.

  METHOD o2_rating_23.
    SPLIT
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
      |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).

    DATA(actual_rating) = diagnostics->get_part_rating( diagnostic_report = diagnostic_report
                                                                position = 0
                                                                part = zsubmarine_diagnostics=>o2_generator ).
    DATA(expected_rating) = 23.
    cl_abap_unit_assert=>assert_equals( msg = 'o2 rating 23' exp = expected_rating act = actual_rating ).
  ENDMETHOD.

  METHOD co2_rating_10.
    SPLIT
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
      |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).

    DATA(actual_rating) = diagnostics->get_part_rating( diagnostic_report = diagnostic_report
                                                                position = 0
                                                                part = zsubmarine_diagnostics=>co2_srubber ).
    DATA(expected_rating) = 10.
    cl_abap_unit_assert=>assert_equals( msg = 'co2 rating 10' exp = expected_rating act = actual_rating ).
  ENDMETHOD.

  METHOD life_support_230.
SPLIT
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
      |01010\n| AT cl_abap_char_utilities=>newline INTO TABLE DATA(diagnostic_report).
    data(life_support_rating) = diagnostics->calc_life_support_rating( diagnostic_report ).
cl_abap_unit_assert=>assert_equals( msg = 'life support = 230' exp = 230 act = life_support_rating ).
  ENDMETHOD.
ENDCLASS.
