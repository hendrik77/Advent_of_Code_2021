CLASS zsubmarine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES
      if_oo_adt_classrun.
    DATA horizontal TYPE i.
    DATA depth TYPE i.
    DATA aim TYPE i.
    METHODS dive
      IMPORTING
        course TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS direction_forward TYPE string VALUE 'forward' ##NO_TEXT.
    CONSTANTS direction_down TYPE string VALUE 'down' ##NO_TEXT.
    CONSTANTS direction_up TYPE string VALUE 'up' ##NO_TEXT.

ENDCLASS.

CLASS zsubmarine IMPLEMENTATION.

  METHOD dive.
    LOOP AT course ASSIGNING FIELD-SYMBOL(<course>).
      SPLIT <course> AT space INTO DATA(direction) DATA(units).
      CASE direction.
        WHEN direction_forward.
          horizontal = horizontal + units.
          depth = depth + aim * units.
        WHEN direction_down.
          aim = aim  + units.
        WHEN direction_up.
          aim = aim - units.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    dive( zaoc_helper=>get_riddle( 2 ) ).
    out->write( |day 2: { horizontal * depth }| ).
  ENDMETHOD.

ENDCLASS.
