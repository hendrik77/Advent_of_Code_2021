class ltcl_diagnostics definition final for testing
  duration short
  risk level harmless.

  private section.
    DATA submarine TYPE REF TO zsubmarine_diagnostics.
    data diagnostic_report TYPE string_table.
    METHODS setup.
    METHODS gamma_rate FOR TESTING RAISING cx_static_check.

endclass.


class ltcl_diagnostics implementation.

  METHOD setup.
    submarine = NEW zsubmarine_diagnostics( ).
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
        |01010\n|
      AT cl_abap_char_utilities=>newline INTO TABLE diagnostic_report.
  ENDMETHOD.
    METHOD gamma_rate.
    data(power_consumption) = submarine->calc_power_consumption( diagnostic_report ).
    cl_abap_unit_assert=>assert_equals( msg = 'power consmption = 198' exp = 198 act = power_consumption ).
  ENDMETHOD.

endclass.
