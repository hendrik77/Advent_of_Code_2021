CLASS zsonar DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES
      if_oo_adt_classrun.
    METHODS count_increased
      IMPORTING
        measurements TYPE string_table
      RETURNING
        VALUE(count) TYPE i.
    METHODS build_windows
      IMPORTING
        measurements   TYPE string_table
      RETURNING
        VALUE(windows) TYPE string_table.
    METHODS count_increased_win
      IMPORTING
        measurements         TYPE string_table
      RETURNING
        VALUE(increased_win) TYPE i.
    METHODS: set_windows_size IMPORTING windows_size TYPE i,
      calc_power_consumption
        IMPORTING
          diagnostic_report        TYPE string_table
        RETURNING
          VALUE(power_consumption) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA windows_size TYPE i VALUE 3.

ENDCLASS.



CLASS zsonar IMPLEMENTATION.

  METHOD count_increased.
    count = REDUCE #( INIT i = 0 old = 999999
                      FOR measurement IN measurements
                      NEXT i = COND #( WHEN CONV i( measurement ) > old THEN i + 1 ELSE i )
                           old = measurement ).
  ENDMETHOD.

  METHOD count_increased_win.
    increased_win = count_increased( build_windows( measurements ) ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(riddle) = zaoc_helper=>get_riddle( 1 ).
    out->write( |Day 1 - Part 1: { count_increased( riddle ) }| ).
    out->write( |Day 1 - Part 2: { count_increased_win( riddle ) }| ).

    riddle = zaoc_helper=>get_riddle( 3 ).
    out->write( |Day 3 - Part 1: { calc_power_consumption( riddle ) }| ).
  ENDMETHOD.

    METHOD build_windows.
      WHILE sy-index + windows_size - 1 <= lines( measurements ).
        APPEND REDUCE #(
          INIT w = 0
          FOR i = 0 THEN i + 1 WHILE i < windows_size
          NEXT w = w + measurements[ sy-index + i ]
        ) TO windows.
      ENDWHILE.
    ENDMETHOD.

    METHOD set_windows_size.
      me->windows_size = windows_size.
    ENDMETHOD.


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

ENDCLASS.
