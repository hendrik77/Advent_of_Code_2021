CLASS ltcl_bingo DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: bingo TYPE REF TO zbingo_subsystem.
    METHODS mark_7 FOR TESTING RAISING cx_static_check.
    METHODS winner_3rd_row FOR TESTING RAISING cx_static_check.
    METHODS winner_3rd_column FOR TESTING RAISING cx_static_check.
    METHODS no_winner FOR TESTING RAISING cx_static_check.
    METHODS board_score FOR TESTING RAISING cx_static_check.

    METHODS play FOR TESTING RAISING cx_static_check.

    METHODS play_to_loose FOR TESTING RAISING cx_static_check.
    METHODS setup.

ENDCLASS.


CLASS ltcl_bingo IMPLEMENTATION.

  METHOD mark_7.
    DATA(input) =
      |7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n| &&
      |\n| &&
      |22 13 17 11  0\n| &&
      | 8  2 23  4 24\n| &&
      |21  9 14 16  7\n| &&
      | 6 10  3 18  5\n| &&
      | 1 12 20 15 19\n| &&
      |\n| &&
      | 3 15  0  2 22\n| &&
      | 9 18 13 17  5\n| &&
      |19  8  7 25 23\n| &&
      |20 11 10 24  4\n| &&
      |14 21 16 12  6\n| &&
      |\n| &&
      |14 21 17 24  4\n| &&
      |10 16 15  9 19\n| &&
      |18  8 23 26 20\n| &&
      |22 11 13  6  5\n| &&
      | 2  0 12  3  7|.

    bingo->set_bingo( input ).
    bingo->mark( |7| ).
    DATA(board1_3x5) = bingo->boards_x[ 1 ][ 3 ][ 5 ].
    cl_abap_unit_assert=>assert_equals( msg = 'mark 7 on board 1 at 3|5' exp = abap_true act = board1_3x5 ).
  ENDMETHOD.

  METHOD setup.
    bingo = NEW zbingo_subsystem( ).
  ENDMETHOD.

  METHOD play.
    DATA(input) =
      |7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n| &&
      |\n| &&
      |22 13 17 11  0\n| &&
      | 8  2 23  4 24\n| &&
      |21  9 14 16  7\n| &&
      | 6 10  3 18  5\n| &&
      | 1 12 20 15 19\n| &&
      |\n| &&
      | 3 15  0  2 22\n| &&
      | 9 18 13 17  5\n| &&
      |19  8  7 25 23\n| &&
      |20 11 10 24  4\n| &&
      |14 21 16 12  6\n| &&
      |\n| &&
      |14 21 17 24  4\n| &&
      |10 16 15  9 19\n| &&
      |18  8 23 26 20\n| &&
      |22 11 13  6  5\n| &&
      | 2  0 12  3  7|.

    bingo->set_bingo( input ).
    DATA(score) = bingo->play( ).
    cl_abap_unit_assert=>assert_equals( msg = 'score = 4512' exp = 4512 act = score ).
  ENDMETHOD.
METHOD play_to_loose.
    DATA(input) =
      |7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n| &&
      |\n| &&
      |22 13 17 11  0\n| &&
      | 8  2 23  4 24\n| &&
      |21  9 14 16  7\n| &&
      | 6 10  3 18  5\n| &&
      | 1 12 20 15 19\n| &&
      |\n| &&
      | 3 15  0  2 22\n| &&
      | 9 18 13 17  5\n| &&
      |19  8  7 25 23\n| &&
      |20 11 10 24  4\n| &&
      |14 21 16 12  6\n| &&
      |\n| &&
      |14 21 17 24  4\n| &&
      |10 16 15  9 19\n| &&
      |18  8 23 26 20\n| &&
      |22 11 13  6  5\n| &&
      | 2  0 12  3  7|.

    bingo->set_bingo( input ).
    DATA(score) = bingo->play_to_loose( ).
    cl_abap_unit_assert=>assert_equals( msg = 'loosing score = 1924' exp = 1924 act = score ).
  ENDMETHOD.

  METHOD winner_3rd_row.
    DATA board_x TYPE  zbingo_subsystem=>ty_board_x.
    DATA(board_x_str) =
      |- X - X -\n| &&
      |x - - - X\n| &&
      |X X X X X\n| &&
      |x - X - X\n| &&
      |---X-|.
    SPLIT board_x_str AT cl_abap_char_utilities=>newline INTO TABLE DATA(rows).
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      <row> = condense( <row> ).
      SPLIT <row> AT space INTO TABLE DATA(board_row).
      APPEND board_row TO board_x.
    ENDLOOP.

    DATA(win) = bingo->check_win( board_x ).
    cl_abap_unit_assert=>assert_equals( msg = 'winning third row' exp = abap_true act = win ).
  ENDMETHOD.

  METHOD winner_3rd_column.
    DATA board_x TYPE  zbingo_subsystem=>ty_board_x.
    DATA(board_x_str) =
      |- X X X -\n| &&
      |x - X - X\n| &&
      |X - X X X\n| &&
      |x - X - X\n| &&
      |- - X X -|.
    SPLIT board_x_str AT cl_abap_char_utilities=>newline INTO TABLE DATA(rows).
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      <row> = condense( <row> ).
      SPLIT <row> AT space INTO TABLE DATA(board_row).
      APPEND board_row TO board_x.
    ENDLOOP.

    DATA(win) = bingo->check_win( board_x ).
    cl_abap_unit_assert=>assert_true( msg = 'winning third column' act = win ).
  ENDMETHOD.

  METHOD no_winner.
    DATA board_x TYPE  zbingo_subsystem=>ty_board_x.
    DATA(board_x_str) =
      |- X X X -\n| &&
      |x - - - X\n| &&
      |X - X X X\n| &&
      |x - X - X\n| &&
      |- - X X -|.
    SPLIT board_x_str AT cl_abap_char_utilities=>newline INTO TABLE DATA(rows).
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      DATA(row) = condense( <row> ).
      SPLIT <row> AT space INTO TABLE DATA(board_row).
      APPEND board_row TO board_x.
    ENDLOOP.

    DATA(win) = bingo->check_win( board_x ).
    cl_abap_unit_assert=>assert_false( msg = 'winning third column' act = win ).
  ENDMETHOD.

  METHOD board_score.
    DATA(input) =
      |7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n| &&
      |\n| &&
      |14 21 17 24  4\n| &&
      |10 16 15  9 19\n| &&
      |18  8 23 26 20\n| &&
      |22 11 13  6  5\n| &&
      | 2  0 12  3  7|.
    bingo->set_bingo( input ).

    DATA board_x TYPE zbingo_subsystem=>ty_board_x.
    DATA(board_x_str) =
      |X X X X X\n| &&
      |- - - X -\n| &&
      |- - X - -\n| &&
      |- X - - X\n| &&
      |X X - - X|.
    SPLIT board_x_str AT cl_abap_char_utilities=>newline INTO TABLE DATA(rows).
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      DATA(row) = condense( <row> ).
      SPLIT <row> AT space INTO TABLE DATA(board_row).
      APPEND board_row TO board_x.
    ENDLOOP.
    bingo->boards_x[ 1 ] = board_x.

    DATA(board_score) = bingo->calc_score_board( 1 ).
    cl_abap_unit_assert=>assert_equals( msg = 'win socre board 188' exp = 188 act = board_score ).
  ENDMETHOD.
ENDCLASS.
