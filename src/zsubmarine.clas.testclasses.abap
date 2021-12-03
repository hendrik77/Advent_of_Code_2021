CLASS ltcl_submarine DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: submarine TYPE REF TO zsubmarine.

    METHODS: forward_5 FOR TESTING RAISING cx_static_check,
      fdf FOR TESTING RAISING cx_static_check,
      course_forward_5 FOR TESTING RAISING cx_static_check,
      course FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS ltcl_submarine IMPLEMENTATION.

  METHOD forward_5.
    submarine->dive( value #( ( |forward 5| ) ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'horizontal = 5' exp = 5 act = submarine->horizontal ).
    cl_abap_unit_assert=>assert_equals( msg = 'depth = 0' exp = 0 act = submarine->depth ).
    cl_abap_unit_assert=>assert_equals( msg = 'aim = 0' exp = 0 act = submarine->aim ).
  ENDMETHOD.

  METHOD setup.
    submarine = NEW zsubmarine( ).
  ENDMETHOD.

  METHOD fdf.
    DATA(course_str) =
        |forward 5\n| &&
        |down 5\n| &&
        |forward 8|.
    split course_str at cl_abap_char_utilities=>newline into table data(course).
    submarine->dive( course ).

    cl_abap_unit_assert=>assert_equals( msg = 'depth = 8*5=40' exp = 40 act = submarine->depth ).
    cl_abap_unit_assert=>assert_equals( msg = 'horizonatl = 13' exp = 13 act = submarine->horizontal ).
    cl_abap_unit_assert=>assert_equals( msg = 'aim = 5' exp = 5 act = submarine->aim ).
  ENDMETHOD.

  METHOD course_forward_5.
    submarine->dive( value #( ( |forward 5| ) ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'forward 5' exp = 5 act = submarine->horizontal ).
  ENDMETHOD.

  METHOD course.
    DATA(course_str) =
      |forward 5\n| &&
      |down 5\n| &&
      |forward 8\n| &&
      |up 3\n| &&
      |down 8\n| &&
      |forward 2|.
    split course_str at cl_abap_char_utilities=>newline into table data(course).
    submarine->dive( course ).
    cl_abap_unit_assert=>assert_equals( msg = 'horizontal = 15' exp = 15 act = submarine->horizontal ).
    cl_abap_unit_assert=>assert_equals( msg = 'depth = 60' exp = 60 act = submarine->depth ).
    cl_abap_unit_assert=>assert_equals( msg = 'aim = 10' exp = 10 act = submarine->aim ).
  ENDMETHOD.
ENDCLASS.
