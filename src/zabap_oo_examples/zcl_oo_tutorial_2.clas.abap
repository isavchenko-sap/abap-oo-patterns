"! <p class="shorttext synchronized" lang="en">Flight Data as Static Methods</p>
CLASS ZCL_OO_TUTORIAL_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES IF_OO_ADT_CLASSRUN.

    "! <p class="shorttext synchronized" lang="en">Get Booking Details</p>
    CLASS-METHODS GET_FLIGHT_DETAILS
      IMPORTING
                !CARRIER_ID    TYPE /DMO/CARRIER_ID
                !CONNECTION_ID TYPE /DMO/CONNECTION_ID
                !FLIGHT_DATE   TYPE /DMO/FLIGHT_DATE
      RETURNING VALUE(FLIGHT)  TYPE /DMO/FLIGHT.


    "! <p class="shorttext synchronized" lang="en">Calculate Flight Price</p>
    CLASS-METHODS CALCULATE_FLIGHT_PRICE
      IMPORTING
        !CARRIER_ID    TYPE /DMO/CARRIER_ID
        !CONNECTION_ID TYPE /DMO/CONNECTION_ID
        !FLIGHT_DATE   TYPE /DMO/FLIGHT_DATE
      EXPORTING
        !PRICE         TYPE /DMO/FLIGHT_PRICE
        !CURRENCY_CODE TYPE /DMO/CURRENCY_CODE.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OO_TUTORIAL_2 IMPLEMENTATION.


  METHOD CALCULATE_FLIGHT_PRICE.
    DATA PLANE_TYPE TYPE /DMO/PLANE_TYPE_ID.

    SELECT SINGLE PRICE, CURRENCY_CODE, PLANE_TYPE_ID FROM /DMO/FLIGHT
      WHERE CARRIER_ID = @CARRIER_ID
        AND CONNECTION_ID = @CONNECTION_ID
        AND FLIGHT_DATE = @FLIGHT_DATE
       INTO (@PRICE, @CURRENCY_CODE, @PLANE_TYPE).

    CASE PLANE_TYPE.
      WHEN `747-400`.
        PRICE = PRICE + 40.
      WHEN `A321-200`.
        PRICE = PRICE + 25.
      WHEN OTHERS.
        PRICE = PRICE + 10.
    ENDCASE.
  ENDMETHOD.


  METHOD GET_FLIGHT_DETAILS.

    SELECT SINGLE * FROM /DMO/FLIGHT
      WHERE CARRIER_ID = @CARRIER_ID
        AND CONNECTION_ID = @CONNECTION_ID
        AND FLIGHT_DATE = @FLIGHT_DATE
       INTO @FLIGHT.

  ENDMETHOD.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.

    ME->CALCULATE_FLIGHT_PRICE(
      EXPORTING
        CARRIER_ID    = `AA`
        CONNECTION_ID = `0017`
        FLIGHT_DATE   = `20230222`
      IMPORTING
        PRICE         = DATA(PRICE)
        CURRENCY_CODE = DATA(CURRENCY_CODE) ).
    OUT->WRITE( |Flight Price for AA-0017 on {  CONV /DMO/FLIGHT_DATE( `20230222` ) DATE = ENVIRONMENT }: | &&
                |{ PRICE CURRENCY = CURRENCY_CODE } { CURRENCY_CODE }| ).

    ME->CALCULATE_FLIGHT_PRICE(
      EXPORTING
        CARRIER_ID    = `UA`
        CONNECTION_ID = `0058`
        FLIGHT_DATE   = `20220426`
      IMPORTING
        PRICE         = DATA(PRICE_BAD)
        CURRENCY_CODE = DATA(CURRENCY_CODE_BAD) ).
    OUT->WRITE( |Flight Price for UA-0058 on {  CONV /DMO/FLIGHT_DATE( `20220426` ) DATE = ENVIRONMENT }: | &&
                |{ PRICE_BAD CURRENCY = CURRENCY_CODE_BAD } { CURRENCY_CODE_BAD }| ).

    OUT->WRITE( ME->GET_FLIGHT_DETAILS(
                  CARRIER_ID    = `AA`
                  CONNECTION_ID = `0017`
                  FLIGHT_DATE   = `20230222` ) ).

    OUT->WRITE( ME->GET_FLIGHT_DETAILS(
                  CARRIER_ID    = `UA`
                  CONNECTION_ID = `0058`
                  FLIGHT_DATE   = `20220426` ) ).
  ENDMETHOD.
ENDCLASS.
