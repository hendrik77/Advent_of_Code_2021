CLASS zsubmarine_diagnostics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES
      if_oo_adt_classrun.
    METHODS calc_power_consumption
      IMPORTING
        diagnostic_report        TYPE string_table
      RETURNING
        VALUE(power_consumption) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zsubmarine_diagnostics IMPLEMENTATION.
  METHOD calc_power_consumption.
    DATA: zero            TYPE i,
          one             TYPE i,
          offset          TYPE i,
          gamma_binary    TYPE string,
          epsilon_binaray TYPE string.
    DO strlen( diagnostic_report[ 1 ] ) TIMES.
      LOOP AT diagnostic_report ASSIGNING FIELD-SYMBOL(<binary>).
        DATA(numb) = <binary>+offset(1).
        CASE numb.
          WHEN 0.
            zero += 1.
          WHEN 1.
            one += 1.
        ENDCASE.
      ENDLOOP.

      gamma_binary = gamma_binary && condense( val = COND string( WHEN zero > one  THEN 0 ELSE 1 ) ).
      epsilon_binaray = epsilon_binaray  && condense( val = COND string( WHEN zero > one  THEN 1 ELSE 0 ) ).
      offset += 1.
      CLEAR: zero, one.
    ENDDO.

    DATA(gamma) = zaoc_helper=>base_converter( i_number = gamma_binary from = 2 to = 10 ).
    DATA(epsilon) = zaoc_helper=>base_converter( i_number = epsilon_binaray from = 2 to = 10 ).
    power_consumption = gamma * epsilon.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(riddle) = zaoc_helper=>get_riddle( 3 ).
    out->write( |Day 3 - Part 1: { calc_power_consumption( riddle ) }| ).
  ENDMETHOD.

ENDCLASS.
