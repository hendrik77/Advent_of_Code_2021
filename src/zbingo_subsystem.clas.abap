CLASS zbingo_subsystem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES
      if_oo_adt_classrun.
    TYPES ty_board TYPE STANDARD TABLE OF string_table WITH DEFAULT KEY.
    TYPES ty_board_x TYPE STANDARD TABLE OF string_table WITH DEFAULT KEY.
    DATA boards TYPE STANDARD TABLE OF ty_board WITH DEFAULT KEY.
    DATA boards_x TYPE STANDARD TABLE OF ty_board_x WITH DEFAULT KEY.
    METHODS set_board
      IMPORTING
        new_board TYPE string.
    METHODS mark
      IMPORTING
        number TYPE string.
    METHODS set_boards
      IMPORTING
        new_boards TYPE string.
    METHODS set_bingo
      IMPORTING
        input TYPE string.
    METHODS check_win
      IMPORTING
        board_x      TYPE zbingo_subsystem=>ty_board_x
      RETURNING
        VALUE(bingo) TYPE abap_boolean.
    METHODS calc_score_board
      IMPORTING
        board_number       TYPE i
      RETURNING
        VALUE(board_score) TYPE i.
    METHODS play
      RETURNING
        VALUE(score) TYPE i.
    METHODS play_to_loose
      RETURNING
        VALUE(score) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA numbers TYPE string.
ENDCLASS.



CLASS zbingo_subsystem IMPLEMENTATION.

  METHOD set_board.
    DATA board TYPE ty_board.
    DATA board_x TYPE ty_board_x.
    DATA(condensed_board) = condense( new_board ).
    DATA rows TYPE string_table.
    SPLIT condensed_board AT cl_abap_char_utilities=>newline INTO TABLE rows.
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      <row> = condense( <row> ).
      SPLIT <row> AT space INTO TABLE DATA(board_row).
      APPEND board_row TO board.
      APPEND VALUE #( FOR i = 0 WHILE i < lines( board_row ) ( |-| ) ) TO board_x.
    ENDLOOP.
    APPEND board TO boards.
    APPEND board_x TO boards_x.
  ENDMETHOD.


  METHOD mark.
    LOOP AT boards ASSIGNING FIELD-SYMBOL(<board>).
      ASSIGN boards_x[ sy-tabix ] TO FIELD-SYMBOL(<board_x>).
      LOOP AT <board> ASSIGNING FIELD-SYMBOL(<row>).
        DATA(col) = line_index( <row>[ table_line = number ] ).
        IF col IS NOT INITIAL.
          <board_x>[ sy-tabix ][ col ] = abap_true.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_boards.
    DATA(seperator) = cl_abap_char_utilities=>newline && cl_abap_char_utilities=>newline.
    SPLIT new_boards AT seperator INTO TABLE DATA(boards).
    LOOP AT boards ASSIGNING FIELD-SYMBOL(<board>).
      set_board( <board> ).
    ENDLOOP.
  ENDMETHOD.

  METHOD set_bingo.
    DATA(seperator) = cl_abap_char_utilities=>newline && cl_abap_char_utilities=>newline.
    SPLIT input AT seperator INTO numbers DATA(boards).
    set_boards( boards ).
  ENDMETHOD.

  METHOD check_win.
    "check rows
    LOOP AT board_x ASSIGNING FIELD-SYMBOL(<row>).
      IF NOT line_exists( <row>[ table_line = |-| ] ).
        bingo = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

    "check columns
    DATA bingo_str TYPE string.
    DATA: x, y TYPE i.
    DO 5 TIMES.
      CLEAR x.
      y += 1.
      DO 5 TIMES.
        x += 1.
        IF board_x[ x ][ y ] = |-|.
          CONTINUE.
        ELSE.
          bingo_str = bingo_str && |X|.
        ENDIF.
      ENDDO.
      IF strlen( bingo_str ) = 5.
        bingo = abap_true.
      ELSE.
        CLEAR bingo_str.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD calc_score_board.
    DO 5 TIMES.
      DATA(x) = sy-index.
      DO 5 TIMES.
        DATA(y) = sy-index.
        IF boards_x[ board_number ][ x ][ y ] = |-|.
          board_score = board_score + boards[ board_number ][ x ][ y ].
        ENDIF.
      ENDDO.
    ENDDO.
  ENDMETHOD.

  METHOD play.
    SPLIT numbers AT ',' INTO TABLE DATA(number_tab).
    LOOP AT number_tab INTO DATA(number).
      mark( number ).
      LOOP AT boards_x ASSIGNING FIELD-SYMBOL(<board_x>).
        IF check_win( <board_x> ).
          score = calc_score_board( sy-tabix ) * number.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(riddle) = zaoc_helper=>get_riddle_string( 4 ).
    set_bingo( riddle ).
    out->write( |Day 4 - Part 1: { play( ) }| ).
    out->write( |Day 4 - Part 1: { play_to_loose( ) }| ).
  ENDMETHOD.


  METHOD play_to_loose.
    DATA winning_boards TYPE STANDARD TABLE OF i.
    SPLIT numbers AT ',' INTO TABLE DATA(number_tab).
    LOOP AT number_tab INTO DATA(number).
      mark( number ).
      LOOP AT boards_x ASSIGNING FIELD-SYMBOL(<board_x>).
        CHECK NOT line_exists( winning_boards[ table_line = sy-tabix ] ).
        IF check_win( <board_x> ).
          IF lines( boards_x ) - lines( winning_boards ) = 1.
            score = calc_score_board( sy-tabix ) * number.
            return.
          ELSE.
            APPEND sy-tabix TO winning_boards.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
