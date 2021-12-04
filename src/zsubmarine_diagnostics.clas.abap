CLASS zsubmarine_diagnostics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES
      if_oo_adt_classrun.
    TYPES: BEGIN OF ENUM enum_part,
             o2_generator,
             co2_srubber,
           END OF ENUM enum_part.
    METHODS calc_power_consumption
      IMPORTING
        diagnostic_report        TYPE string_table
      RETURNING
        VALUE(power_consumption) TYPE i.
    METHODS reduce_list
      IMPORTING
        list                TYPE string_table
        pos                 TYPE i
        val                 TYPE i
      RETURNING
        VALUE(reduced_list) TYPE string_table.
    METHODS get_part_rating
      IMPORTING
        VALUE(position)   TYPE i OPTIONAL
        part              TYPE enum_part
        diagnostic_report TYPE string_table
      RETURNING
        VALUE(o2_rating)  TYPE i.
    METHODS calc_life_support_rating
      IMPORTING
        diagnostic_report          TYPE string_table
      RETURNING
        VALUE(life_support_rating) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: gamma_binary    TYPE string,
          epsilon_binaray TYPE string.
    METHODS calc_binary
      IMPORTING
        diagnostic_report TYPE string_table.
ENDCLASS.

CLASS zsubmarine_diagnostics IMPLEMENTATION.
  METHOD calc_power_consumption.

    calc_binary( diagnostic_report ).

    DATA(gamma) = zaoc_helper=>base_converter( i_number = gamma_binary from = 2 to = 10 ).
    DATA(epsilon) = zaoc_helper=>base_converter( i_number = epsilon_binaray from = 2 to = 10 ).
    power_consumption = gamma * epsilon.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(riddle) = zaoc_helper=>get_riddle( 3 ).
    out->write( |Day 3 - Part 1: { calc_power_consumption( riddle ) }| ).
    out->write( |Day 3 - Part 2: { calc_life_support_rating( riddle ) }| ).
  ENDMETHOD.


  METHOD calc_binary.
    CLEAR gamma_binary.
    CLEAR epsilon_binaray.
    DATA: zero   TYPE i,
          one    TYPE i,
          offset TYPE i.
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

  ENDMETHOD.


  METHOD reduce_list.
    LOOP AT list ASSIGNING FIELD-SYMBOL(<l>).
      IF <l>+pos(1) = val.
        APPEND <l> TO reduced_list.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_part_rating.
    calc_binary( diagnostic_report ).
    DATA(bit) = COND #( WHEN part = o2_generator THEN CONV i( gamma_binary+position(1) )
                        WHEN part = co2_srubber THEN CONV i( epsilon_binaray+position(1) ) ).
    DATA(new_list) = reduce_list( list = diagnostic_report pos = position val = bit ).
    IF lines( new_list ) > 1.
      o2_rating = get_part_rating( diagnostic_report = new_list
                                           position = position + 1
                                           part = part ).
    ELSE.
      o2_rating = zaoc_helper=>base_converter(
        i_number   = new_list[ 1 ]
        from       = 2
        to         = 10 ).
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD calc_life_support_rating.
    DATA(o2_rating) = get_part_rating( diagnostic_report = diagnostic_report
                                       part = o2_generator ).
    DATA(co2_rating) = get_part_rating( diagnostic_report = diagnostic_report
                                        part = co2_srubber ).
    life_support_rating = o2_rating * co2_rating.
  ENDMETHOD.

ENDCLASS.
