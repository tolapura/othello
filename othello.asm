;OTHELLO GAME (4X4 GRID VERSION)
;MEMBERS: COBO MARK, LAPURA LEIGH
;13 DECEMBER 2017
TITLE               OTHELLO (EXE)
                    .MODEL  SMALL
                    .STACK  64
                    .DATA
;-------------------------------------------------------------------------
; FILLS SELECTED CELL
;-------------------------------------------------------------------------
FILL                MACRO   ROW_START, COL_START
                    MOV     DI, ROW_START                   ;DECLARES THE VALUES [0-3]
                    MOV     SI, COL_START                   ;DECLARES THE VALUES [0-3]
                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     CH, Y_ARRAY[SI]                 ;SETS STARTING Y COORDINATE
                    MOV     CL, X_ARRAY[DI]                 ;SETS STARTING X COORDINATE
                    MOV     DL, X_ARRAY[DI]                 ;SETS ENDING X COORDINATE
                    ADD     DL, 10                          ;ADDS 10 UNITS TO THE RIGHT
                    MOV     DH, Y_ARRAY[SI]                 ;SETS ENDING Y COORDINATE
                    ADD     DH, 3                           ;ADDS 3 UNITS DOWNWARD
                    INT     10H

                    MOV     DL, X_ARRAY[DI]
                    MOV     DH, Y_ARRAY[SI]
                    CALL    SET_CURSOR
                    LEA     DX, BLOCK
                    CALL    DISPLAY

                    MOV     DL, X_ARRAY[DI]
                    MOV     DH, Y_ARRAY[SI]
                    ADD     DH, 01
                    CALL    SET_CURSOR
                    LEA     DX, BLOCK
                    CALL    DISPLAY

                    MOV     DL, X_ARRAY[DI]
                    MOV     DH, Y_ARRAY[SI]
                    ADD     DH, 02
                    CALL    SET_CURSOR
                    LEA     DX, BLOCK
                    CALL    DISPLAY

                    MOV     DL, X_ARRAY[DI]
                    MOV     DH, Y_ARRAY[SI]
                    ADD     DH, 03
                    CALL    SET_CURSOR
                    LEA     DX, BLOCK
                    CALL    DISPLAY
ENDM
;-------------------------------------------------------------------------
MOUSEX              DW      ?                               ;X COORDINATE OF MOUSE [640 X 200]
MOUSEY              DW      ?                               ;Y COORDINATE OF MOUSE [640 X 200]
POSX                DB      ?                               ;MOUSEX DIVIDED BY 8   [80 X 25]
POSY                DB      ?                               ;MOUSEY DIVIDED BY 8   [80 X 25]
EIGHT               DB      08H                             ;EIGHT
TEN                 DB      0AH                             ;TEN
FOUR                DB      04H                             ;FOUR
X_ARRAY             DB      16,28,40,52                     ;X ARRAY FOR X COORDINATES
Y_ARRAY             DB      3,8,13,18                       ;Y ARRAY FOR Y COORDINATES
GRID_ARRAY          DB      0,0,0,0,0,1,2,0,0,2,1,0,0,0,0,0 ;0=NONE 1=BLACK 2=WHITE , ARRAY FOR GRID
TEMP                DB      ?                               ;TEMPORARY VARIABLE
FILE_HANDLE         DW      ?                               ;FILE HANDLE
TURN_BOL            DB      1                               ;CURRENT TURN 1=BLACK 2=WHITE
READ_ERR1           DB      'ERROR IN OPENING FILE.$'       ;ERROR STRING
READ_ERR2           DB      'ERROR READING FROM FILE.$'     ;ERROR STRING
READ_ERR3           DB      'NO RECORD READ FROM FILE.$'    ;ERROR STRING
WRITE_ERR1          DB      'ERROR IN CREATING FILE.$'      ;ERROR STRING
WRITE_ERR2          DB      'ERROR WRITING IN FILE.$'       ;ERROR STRING
WRITE_ERR3          DB      'RECORD NOT WRITTEN PROPERLY.$' ;ERROR STRING
PREV_WINNER         DB      'PREVIOUS WINNER: $'            ;PREVIOUS WINNER STRING
PROMPT_NAME         DB      'PLEASE ENTER YOUR NAME: $'     ;PROMPT FOR WINNERS NAME
WINNER_NAME         DB      10 DUP (' ') ,'$'               ;NAME OF THE WINNER
RECORD_STR          DB      10 DUP (' ') ,'$'               ;LENGTH OF FILE
DRAW_STR            DB      "  IT'S A DRAW $"               ;DRAW STRING
BLACKW_STR          DB      'BLACK WINS!$'                  ;BLACK WINS STRING
WHITEW_STR          DB      'WHITE WINS!$'                  ;WHITE WINS STRING
TURN_STR            DB      'TURN: $'                       ;TURN STRING
P1TURN_STR          DB      'BLACK$'                        ;BLACK STRING
P2TURN_STR          DB      'WHITE$'                        ;WHITE STRING
STATUS_STR          DB      'STATUS: $'                     ;STATUS STRING
INVALID_STR         DB      'INVALID MOVE!$'                ;INVALID MOVE STRING
VALID_STR           DB      'VALID MOVE!  $'                ;VALID MOVE STRING
LOAD_STR            DB      '     INITIALIZING    $'        ;INITIALIZING STRING
COMPLT_STR          DB      'PRESS ANY KEY TO START$'       ;PRESS ANY KEY STRING
RFILEHANDLE         DW      ?                               ;READ FILE HANDLE
WFILEHANDLE         DW      ?                               ;WRITE FILE HANDLE
WINNER_FILE         DB      'WINNER.TXT', 00H               ;WINNER NAME FILE
LOADING             DB      'LOADING.TXT', 0                ;LOADING.TXT FILE
HELP                DB      'HELP.TXT', 0                   ;HELP.TXT FILE
MENU                DB      'MAINMENU.TXT',0                ;MAINMENU.TXT FILE
GAMEOVER            DB      'GAMEOVER.TXT',0                ;GAMEOVER.TXT FILE
FILE_BUFFER         DB      2000 DUP ('$')                  ;FILE BUFFER
ERROR_STR           DB      'ERROR!$'                       ;ERROR STRING
ARROW               DB      175, '$'                        ;ASCII FOR ARROW
SPACE               DB      ' ', '$'                        ;SPACE
BEEPCX              DW      ?                               ;FOR BEEP SOUND
BEEPBX              DB      ?                               ;FOR BEEP SOUND
HAS_MOVE            DW      0                               ;HAS MOVE BOOLEAN
ROW                 DB      0                               ;ROW VARIABLE FOR MENU [>]
COL                 DB      0                               ;COL VARIABLE FOR MENU [>]
PCS_TO_FLIP         DW      0                               ;NUMBER OF PCS TO FLIP
VALID_CTR           DW      0                               ;VALID MOVES CTR
VALID_MOVE_CTR      DW      0                               ;VALID MOVES CTR
GRID_ROW            DW      0                               ;GRID ROW [0-3]
GRID_COL            DW      0                               ;GRID COLUMN [0-3]
CURR_ROW            DW      0                               ;CURR_ROW [0-3]
CURR_COL            DW      0                               ;CURR_COL [0-3]
LOADING_FLAG        DB      0                               ;LOADING FLAG
BLACK_STR           DB      'BLACK: $'                      ;BLACK STRING FOR SCORING
WHITE_STR           DB      'WHITE: $'                      ;WHITE STRING FOR SCORING
BLACK_SCORE         DW      0                               ;BLACK SCORE
WHITE_SCORE         DW      0                               ;WHITE SCORE
BLOCK               DB      11 DUP (0DBH), '$'              ;ASCII USED AS DISCS
BOARD               DB      0C9H, 11 DUP (0CDH), 0CBH, 11 DUP (0CDH), 0CBH, 11 DUP (0CDH), 0CBH, 11 DUP (0CDH), 0BBH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0CCH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0B9H, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0CCH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0B9H, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0CCH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0CEH, 11 DUP (0CDH), 0B9H, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 11 DUP (020H), 0BAH, 13, 10
                    DB      15 DUP (020H),  0C8H, 11 DUP (0CDH), 0CAH, 11 DUP (0CDH), 0CAH, 11 DUP (0CDH), 0CAH, 11 DUP (0CDH), 0BCH, 13, 10,'$'
                                                            ;ASCII USED AS GRID
;-------------------------------------------------------------------------
;MAIN PROCEDURE
;-------------------------------------------------------------------------
                    .CODE
A10MAIN             PROC    FAR
                    MOV     AX, @DATA                       ;SETS DS TO ADDRESS OF CODE SEGMENT
                    MOV     DS, AX
                    CALL    HIDE_MOUSE                      ;HIDES CURSOR
                    CALL    LOADING_SCREEN                  ;DISPLAYS LOADING SCREEN
A10MAIN             ENDP
;-------------------------------------------------------------------------
;DISPLAYS LOADING SCREEN
;-------------------------------------------------------------------------
LOADING_SCREEN      PROC    NEAR
                    CALL    CLEAR_SCREEN
                    LEA     DX,LOADING                      ;DISPLAYS LOADING FILE
                    CALL    FILE_READ
                    MOV     DL, 20H                         ;SETS CURSOR [X-COORDINATE]
                    MOV     DH, 11                          ;SETS CURSOR [Y-COORDINATE]
                    CALL    SET_CURSOR
                    LEA     DX, LOAD_STR                    ;DISPLAYS LOADING TEXT
                    CALL    DISPLAY

                    MOV     CH, 32                          ;HIDES BLINKING CURSOR
                    MOV     AH, 1
                    INT     10H

                    MOV     TEMP, 00                        ;Y-UNITS TO BE FILLED
            ITERATE:
                    MOV     DL, TEMP                        ;SETS CURSOR
                    MOV     DH, 12
                    CALL    SET_CURSOR
                    MOV     AL, 0DBH                        ;DISPLAYS ASCII CHAR [0DBH] FROM REGISTER
                    MOV     AH, 02H

                    MOV     DL, AL
                    INT     21H                             ;PRINTS THE BLOCK
                    CALL    DELAY
                    INC     TEMP
                    CMP     TEMP, 79                        ;CHECKS IF THE BLOCK REACHES THE END
                    JE      LOADING_COMPLETE
                    JMP     ITERATE
LOADING_SCREEN      ENDP
;-------------------------------------------------------------------------
;READS FILE AND DISPLAYS THE CONTENT
;-------------------------------------------------------------------------
FILE_READ           PROC    NEAR
                    MOV     AX, 3D02H                       ;OPENS FILE
                    INT     21H
                    JC      FILE_ERROR
                    MOV     FILE_HANDLE, AX
                    CALL    CLEARFB
                    MOV     AH, 3FH                         ;READS FILE
                    MOV     BX, FILE_HANDLE
                    MOV     CX, 2000
                    LEA     DX, FILE_BUFFER
                    INT     21H
                    JC      FILE_ERROR
                    MOV     DX, 0000H                       ;DISPLAYS FILE
                    CALL    SET_CURSOR
                    LEA     DX, FILE_BUFFER
                    CALL    DISPLAY
                    MOV     AH, 3EH                         ;CLOSES FILE
                    MOV     BX, FILE_HANDLE
                    INT     21H
                    JC      FILE_ERROR
                    RET
            FILE_ERROR:
                    LEA     DX, ERROR_STR                   ;ERROR IN FILE OPERATION
                    CALL    DISPLAY
                    RET
FILE_READ           ENDP
;-------------------------------------------------------------------------
;CLEARS FILE BUFFER
;-------------------------------------------------------------------------
CLEARFB             PROC    NEAR
                    PUSH    CX
                    LEA     SI, FILE_BUFFER
                    MOV     CX, 2000
            L1:
                    MOV     BYTE PTR[SI], '$'
                    INC     SI
                    LOOP    L1
                    POP     CX
                    RET
CLEARFB             ENDP
;-------------------------------------------------------------------------
;PRINTS CONTENT
;-------------------------------------------------------------------------
DISPLAY             PROC    NEAR
                    MOV     AH, 09H
                    INT     21H
                    RET
DISPLAY             ENDP
;-------------------------------------------------------------------------
;DISPLAYS COMPLT_STR
;-------------------------------------------------------------------------
LOADING_COMPLETE    PROC    NEAR
                    MOV     DL, 20H                         ;SETS CURSOR [X-COORDINATE]
                    MOV     DH, 11                          ;SETS CURSOR [Y-COORDINATE]
                    CALL    SET_CURSOR
                    LEA     DX, COMPLT_STR
                    CALL    DISPLAY                         ;DISPLAYS THE COMPLT_STR
                    CALL    LOADING_WAIT_KEY
LOADING_COMPLETE    ENDP
;-------------------------------------------------------------------------
;WAITS FOR USER TO PRESS ANY KEY TO PROCEED TO HOME_SCREEN
;-------------------------------------------------------------------------
LOADING_WAIT_KEY    PROC    NEAR
                    MOV     AH, 00H                         ;GET INPUT
                    INT     16H
                    CALL    HOME_SCREEN
LOADING_WAIT_KEY    ENDP
;-------------------------------------------------------------------------
;TERMINATES PROGRAM
;-------------------------------------------------------------------------
TERMINATE           PROC    NEAR
                    MOV     DL, 00                          ;SET CURSOR
                    MOV     DH, 13
                    CALL    SET_CURSOR
                    MOV     AX, 4C00H                       ;TERMINATES
                    INT     21H
TERMINATE           ENDP
;-------------------------------------------------------------------------
;CLEARS SCREEN
;-------------------------------------------------------------------------
CLEAR_SCREEN        PROC    NEAR
                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     BH, 02H                         ;BACKGROUND [0=BLACK], FOREGROUND [2=GREEN]
                    MOV     CX, 0000H                       ;ROW COORDINATES
                    MOV     DX, 184FH                       ;COL COORDINATES
                    INT     10H
                    RET
CLEAR_SCREEN        ENDP
;-------------------------------------------------------------------------
;SETS THE CURSOR'S POSITION
;-------------------------------------------------------------------------
SET_CURSOR          PROC    NEAR
                    MOV     AH, 02H
                    MOV     BH, 00
                    INT     10H
                    RET
SET_CURSOR          ENDP
;-------------------------------------------------------------------------
;PROVIDES A DELAY EFFECT
;-------------------------------------------------------------------------
DELAY               PROC    NEAR
                    MOV     BP, 2                           ;LOWER VALUE FASTER
                    MOV     SI, 2                           ;LOWER VALUE FASTER
            DELAY2:
                    DEC     BP
                    NOP
                    JNZ     DELAY2
                    DEC     SI
                    CMP     SI, 0
                    JNZ     DELAY2
                    RET
DELAY               ENDP
;-------------------------------------------------------------------------
;DELAYS THE PROGRAM LONGER THAN DELAY (PROC)
;-------------------------------------------------------------------------
DELAYMORE           PROC    NEAR
                    MOV     BP, 5                           ;LOWER VALUE FASTER
                    MOV     SI, 5                           ;LOWER VALUE FASTER
            DELAY1:
                    DEC     BP
                    NOP
                    JNZ     DELAY1
                    DEC     SI
                    CMP     SI, 0
                    JNZ     DELAY1
                    RET
DELAYMORE           ENDP
;-------------------------------------------------------------------------
;DISPLAYS HOME SCREEN
;-------------------------------------------------------------------------
HOME_SCREEN         PROC    NEAR
                    CALL    CLEAR_SCREEN
                    MOV     DH, 0                           ;SETS CURSOR [X-COORDINATE]
                    MOV     DL, 0                           ;SETS CURSOR [Y-COORDINATE]
                    CALL    SET_CURSOR
                    LEA     DX, MENU
                    CALL    FILE_READ
                    CALL    MENU_CH                         ;DISPLAYS MENU SCREEN
HOME_SCREEN         ENDP
;-------------------------------------------------------------------------
;MENU FOR HOME SCREEN
;-------------------------------------------------------------------------
MENU_CH             PROC     NEAR
                    MOV     ROW, 11                         ;POSITION THE ASCII [>]
                    MOV     COL, 15
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, ARROW
                    CALL    DISPLAY
            CHOOSE:
                    MOV     AH, 10H                         ;GET INPUT
                    INT     16H
                    CMP     AL, 0DH                         ;COMPARE IF INPUT IS ENTER
                    JE      CHOICE
                    CMP     AH, 4BH                         ;COMPARE IF INPUT IS LEFT
                    JE      _LEFT
                    CMP     AH, 4DH                         ;COMPARE IF INPUT IS RIGHT
                    JE      _RIGHT
                    JMP     CHOOSE
            _RIGHT:
                    CALL    BEEP_1
                    CMP     COL, 49                         ;IF IT IS IN THE RIGHMOST POSITION
                    JE      CHOOSE                          ;USER CHOOSES AGAIN
                    MOV     DH, ROW                         ;SET INITIAL COORDINATES TO SPACE
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, SPACE
                    CALL    DISPLAY
                    ADD     COL, 17                         ;SET COL TO CURRENT COORDINATE
                    CALL    DISP_ARR
            _LEFT:
                    CALL    BEEP_1
                    CMP     COL, 15                         ;IF IT IS IN THE LEFTMOST POSITION
                    JE      CHOOSE                          ;USER CHOOSES AGAIN
                    MOV     DH, ROW                         ;SET INITIAL COORDINATES TO SPACE
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, SPACE
                    CALL    DISPLAY
                    SUB     COL, 17                         ;SET COL TO CURRENT COORDINATE
                    CALL    DISP_ARR
            CHOICE:
                    CMP     COL, 15
                    JE      GO_GAME                         ;START GAME
                    CMP     COL, 32
                    JE      GO_HELP                         ;HELP SCREEN
                    CMP     COL, 49
                    JE      GO_EXIT                         ;EXIT SCREEN
            DISP_ARR:
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR                      ;DISPLAY ARROW [>]
                    LEA     DX, ARROW
                    CALL    DISPLAY
                    JMP     CHOOSE
            GO_GAME:
                    CALL    GAME_SCREEN
            GO_HELP:
                    CALL    HELP_SCREEN
            GO_EXIT:
                    CALL    EXIT_SCREEN
MENU_CH             ENDP
;-------------------------------------------------------------------------
;MAIN LOGIC FOR GAMEPLAY
;-------------------------------------------------------------------------
GAME_SCREEN         PROC    NEAR
                    CALL    CLEAR_SCREEN                    ;CLEARS SCREEN
                    CALL    SET_GAME_DETAILS                ;SETS GAME DETAILS
                    CALL    INIT_MOUSE                      ;MOUSE RESET/GET MOUSE INSTALLED FLAG
                    CALL    MOUSE_INPUT                     ;GET MOUSE INPUT
GAME_SCREEN         ENDP
;-------------------------------------------------------------------------
;SETS GAME SCREEN DETAILS (SCORE,STATUS,TURN)
;-------------------------------------------------------------------------
SET_GAME_DETAILS    PROC    NEAR
                    MOV     BLACK_SCORE,0                   ;SET SCORES TO 0
                    MOV     WHITE_SCORE,0
                    MOV     SI, 0
            INIT_GRID:
                    MOV     GRID_ARRAY[SI], 0               ;SET GRID_ARRAY TO 0
                    INC     SI
                    CMP     SI,16
                    JE      SET_BG
                    JMP     INIT_GRID
            SET_BG:
                    MOV     SI,9                            ;SET STARTING DISCS
                    MOV     GRID_ARRAY[SI],2
                    MOV     SI,6
                    MOV     GRID_ARRAY[SI],2
                    MOV     SI,5
                    MOV     GRID_ARRAY[SI],1
                    MOV     SI,10
                    MOV     GRID_ARRAY[SI],1
                    MOV     TURN_BOL, 1                     ;SET STARTING PLAYER TURN [BLACK=1]
                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     BH, 20H                         ;SET BACKGROUND [2=GREEN], FOREGROUND [0=BLACK]
                    MOV     CX, 020FH                       ;ROW COORDINATES [02, 16]
                    MOV     DX, 163FH                       ;COL COORDINATES [15, 63]
                    INT     10H
                    MOV     DL, 15                          ;SET CURSOR [COL]
                    MOV     DH, 02                          ;SET CURSOR [ROW]
                    CALL    SET_CURSOR
                    LEA     DX, BOARD                       ;DISPLAY BOARD
                    CALL    DISPLAY

                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     BH, 0FH                         ;SET BACKGROUND [0=BLACK], FOREGROUND [F=WHITE]
                    MOV     CX, 0000H                       ;ROW COORDINATES [00, 01], FOR THE STATUS PART
                    MOV     DX, 014FH                       ;COL COORDINATES [00, 79], FOR THE STATUS PART
                    INT     10H

                    MOV     DH, 01                          ;COORDINATES FOR STATUS_STR
                    MOV     DL, 15
                    CALL    SET_CURSOR
                    LEA     DX, STATUS_STR                  ;PRINT STATUS STRING
                    CALL    DISPLAY
                    MOV     DH, 01                          ;COORDINATES FOR TURN_STR
                    MOV     DL, 53
                    CALL    SET_CURSOR
                    LEA     DX, TURN_STR                    ;PRINT TURN STRING
                    CALL    DISPLAY


                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     BH, 0FH                         ;SET BACKGROUND [0=BLACK], FOREGROUND [F=WHITE]
                    MOV     CX, 0800H                       ;ROW COORDINATES [08, 0E], FOR THE SCORING PART
                    MOV     DX, 0E09H                       ;COL COORDINATES [00, 09], FOR THE SCORING PART
                    INT     10H

                    MOV     DL, 2
                    MOV     DH, 8
                    CALL    SET_CURSOR
                    LEA     DX, BLACK_STR                   ;PRINT BLACK STRING
                    CALL    DISPLAY
                    MOV     DL, 2
                    MOV     DH, 13
                    CALL    SET_CURSOR
                    LEA     DX, WHITE_STR                   ;PRINT WHITE STRING
                    CALL    DISPLAY

                    MOV     AX, 0600H                       ;AH=06(SCROLL UP WINDOW), AL=00(ENTIRE WINDOW)
                    MOV     BH, 0FH                         ;SET BACKGROUND [0=BLACK], FOREGROUND [F=WHITE]
                    MOV     CX, 1700H                       ;ROW COORDINATES [17, 17], FOR THE SCORING PART
                    MOV     DX, 174FH                       ;COL COORDINATES [00, 79], FOR THE SCORING PART
                    INT     10H

                    MOV     DH,23
                    MOV     DL,15
                    CALL    SET_CURSOR
                    LEA     DX,PREV_WINNER
                    CALL    DISPLAY
                    CALL    LOAD_WINNER

                    CALL    UPDATE_SCORE
                    RET
SET_GAME_DETAILS    ENDP
;-------------------------------------------------------------------------
;LOAD FILE THEN DISPLAY PREVIOUS WINNER
;-------------------------------------------------------------------------
LOAD_WINNER         PROC    NEAR
                    MOV     AH, 3DH                         ;REQUEST OPEN FILE
                    MOV     AL, 00                          ;READ ONLY; 01 (WRITE ONLY); 10 (READ/WRITE)
                    LEA     DX, WINNER_FILE
                    INT     21H
                    JC      DIS_READERR1
                    MOV     RFILEHANDLE, AX

                    MOV     AH, 3FH                         ;REQUEST READ RECORD
                    MOV     BX, RFILEHANDLE                 ;FILE HANDLE
                    MOV     CX, 10                          ;RECORD LENGTH
                    LEA     DX, RECORD_STR                  ;ADDRESS OF INPUT AREA
                    INT     21H
                    JC      DIS_READERR2
                    CMP     AX, 00                          ;ZERO BYTES READ
                    JE      DIS_READERR3

                    LEA     SI, RECORD_STR
                    MOV     DH, 23
                    MOV     DL, 33
                    CALL    SET_CURSOR

            LOAD_ITER:
                    MOV     DL, [SI]
                    INC     SI
                    MOV     AH,02
                    INT     21H
                    MOV     DL,13
                    CMP     [SI], DL
                    JE      LEAVE_LOAD
                    MOV     DL,'$'
                    CMP     [SI], DL
                    JE      LEAVE_LOAD
                    JMP     LOAD_ITER
            LEAVE_LOAD:
                    MOV AH, 3EH                             ;REQUEST CLOSE FILE
                    MOV BX, RFILEHANDLE                     ;FILE HANDLE
                    INT 21H
                    RET
            DIS_READERR1:
                    LEA DX, READ_ERR1
                    MOV AH, 09
                    INT 21H
                    RET
            DIS_READERR2:
                    LEA DX, READ_ERR2
                    MOV AH, 09
                    INT 21H
                    RET
            DIS_READERR3:
                    LEA DX, READ_ERR3
                    MOV AH, 09
                    INT 21H
                    RET
LOAD_WINNER         ENDP
;-------------------------------------------------------------------------
;INITIALIZES MOUSE
;-------------------------------------------------------------------------
INIT_MOUSE          PROC    NEAR
                    MOV     AX, 0000H
                    INT     33H
                    CALL    SET_MOUSE                       ;SET MOUSE CURSOR POSITION
                    CALL    SET_MINMAX_VER_MOUSE
                    CALL    SET_MINMAX_HOR_MOUSE
                    CALL    DISP_MOUSE                      ;SHOW MOUSE CURSOR
                    RET
INIT_MOUSE          ENDP
;-------------------------------------------------------------------------
;SETS MOUSE'S POSITION
;-------------------------------------------------------------------------
SET_MOUSE           PROC    NEAR
                    MOV     AX, 04H
                    MOV     CX, 10H                         ;X - COORDINATE
                    MOV     DX, 80H                         ;Y - COORDINATE
                    INT     33H
SET_MOUSE           ENDP
;-------------------------------------------------------------------------
;SHOWS MOUSE CURSOR
;-------------------------------------------------------------------------
DISP_MOUSE          PROC    NEAR
                    MOV     BL, 00H
                    MOV     AX, 01H
                    INT     33H
                    RET
DISP_MOUSE          ENDP
;-------------------------------------------------------------------------
;HIDES MOUSE CURSOR
;-------------------------------------------------------------------------
HIDE_MOUSE          PROC    NEAR
                    MOV     AX, 02H
                    INT     33H
                    RET
HIDE_MOUSE          ENDP
;-------------------------------------------------------------------------
;SETS MINIMUM AND MAXIMUM ROW OF MOUSE
;-------------------------------------------------------------------------
SET_MINMAX_VER_MOUSE PROC   NEAR
                    MOV     AX,08H
                    MOV     CX,18H                          ;SET LOWER ROW LIMIT TO 1
                    MOV     DX,0A8H                         ;SET UPPER ROW LIMIT TO 21
                    INT     33H
SET_MINMAX_VER_MOUSE ENDP
;-------------------------------------------------------------------------
;SETS MINIMUM AND MAXIMUM COLUMN OF MOUSE
;-------------------------------------------------------------------------
SET_MINMAX_HOR_MOUSE PROC   NEAR
                    MOV     AX,07H
                    MOV     CX,80H                          ;SET LOWER COLUMN LIMIT TO 16
                    MOV     DX,1F0H                         ;SET UPPER COLUMN LIMIT TO 62
                    INT     33H
SET_MINMAX_HOR_MOUSE ENDP
;-------------------------------------------------------------------------
;UPDATES SCORES AND GRID
;-------------------------------------------------------------------------
UPDATE_SCORE        PROC    NEAR
                    MOV     SI, 0
                    MOV     BLACK_SCORE, 0                  ;SETS SCORES TO 0 AFTER EVERY TURN
                    MOV     WHITE_SCORE, 0
            ITERATE_GRID:
                    CMP     GRID_ARRAY[SI],0                ;COMPARE IF 0=EMPTY
                    JNE     CMP_1
                    JMP     INCREMENT_SI
            CMP_1:
                    CMP     GRID_ARRAY[SI],1                ;COMPARE IF 1=BLACK
                    JNE     CMP_2
                    INC     BLACK_SCORE                     ;INCREASE BLACK_SCORE
                    JMP     INCREMENT_SI
            CMP_2:
                    INC     WHITE_SCORE                     ;INCREASE WHITE_SCORE
            INCREMENT_SI:                                   ;INCREASE SI
                    INC     SI
                    CMP     SI,16
                    JE      UPDATE_EXIT
                    JMP     ITERATE_GRID
            UPDATE_EXIT:
                    MOV     DH,9
                    MOV     DL,2
                    CALL    SET_CURSOR
                    MOV     AX, BLACK_SCORE
                    DIV     TEN
                    ADD     AL, '0'
                    MOV     DL, AL
                    MOV     AH, 02
                    INT     21H                             ;PRINT BLACK_SCORE TEN'S PLACE
                    MOV     AX, BLACK_SCORE
                    DIV     TEN
                    ADD     AH, '0'
                    MOV     DL, AH
                    MOV     AH, 02
                    INT     21H                             ;PRINT BLACK_SCORE ONE'S PLACE
                    MOV     DH,14
                    MOV     DL,2
                    CALL    SET_CURSOR
                    MOV     AX, WHITE_SCORE
                    DIV     TEN
                    ADD     AL, '0'
                    MOV     DL, AL
                    MOV     AH, 02
                    INT     21H                             ;PRINT WHITE_SCORE TEN'S PLACE
                    MOV     AX, WHITE_SCORE
                    DIV     TEN
                    ADD     AH, '0'
                    MOV     DL, AH
                    MOV     AH, 02
                    INT     21H                             ;PRINT WHITE_SCORE ONE'S PLACE
                    MOV     SI,0
                    MOV     CURR_COL,0                      ;COLUMN COORDINATE [0-3]
                    MOV     CURR_ROW,0                      ;ROW COORDINATE [0-3]
                    CALL    HIDE_MOUSE                      ;HIDE MOUSE CURSOR
            FILL_GRID:
                    CMP     GRID_ARRAY[SI],0                ;COMPARE IF EMPTY
                    JNE     ARRAY_1
                    JMP     INC_CURR
            ARRAY_1:
                    PUSH    SI
                    CALL    DELAY
                    MOV     BH,20H                          ;SET COLOR TO BLACK [BACKGROUND=GREEN] [FOREGROUND=BLACK]
                    FILL    CURR_COL, CURR_ROW              ;FILL GRID
                    POP     SI
                    CMP     GRID_ARRAY[SI],1                ;COMPARE GRID_ARRAY[SI] IF [BLACK=1]
                    JNE     ARRAY_2
                    JMP     INC_CURR
            ARRAY_2:
                    MOV     BH,2FH                          ;SET COLOR TO WHITE [BACKGROUND=GREEN] [FOREGROUND=WHITE]
                    PUSH    SI
                    FILL    CURR_COL,CURR_ROW               ;FILL GRID
                    POP     SI
            INC_CURR:
                    INC     CURR_COL
                    CMP     CURR_COL,4
                    JNE     SIMPLIFY
                    MOV     CURR_COL,0
                    INC     CURR_ROW
            SIMPLIFY:                                       ;COMPUTE FOR SI
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX,CURR_COL
                    MOV     SI,AX
                    CMP     SI,16
                    JE      __UPDATE_EXIT
                    JMP     FILL_GRID
            __UPDATE_EXIT:
                    CALL    DISP_MOUSE
                    RET
UPDATE_SCORE        ENDP
;-------------------------------------------------------------------------
;COMPUTES FOR GRID ROW AND COL, CONVERT UNITS TO 0-3
;-------------------------------------------------------------------------
FIND_GRID           PROC    NEAR
                    CALL    DELAYMORE
                    ADD     MOUSEX,CX                       ;GET MOUSE X COORDINATE
                    MOV     AX, MOUSEX
                    DIV     EIGHT                           ;DIVIDED BY 8
                    MOV     POSX, AL
                    ADD     MOUSEY,DX
                    MOV     AX, MOUSEY                      ;GET MOUSE Y COORDINATE
                    DIV     EIGHT                           ;DIVIDED BY 8
                    MOV     POSY, AL
                    MOV     DH, 00
                    MOV     DL, 23
                    CALL    SET_CURSOR
                    CMP     POSX, 27                        ;CHECK ROW BORDER
                    JE      INVALID
                    CMP     POSX, 39                        ;CHECK ROW BORDER
                    JE      INVALID
                    CMP     POSX, 51                        ;CHECK ROW BORDER
                    JE      INVALID
                    CMP     POSY, 7                         ;CHECK COLUMN BORDER
                    JE      INVALID
                    CMP     POSY, 12                        ;CHECK COLUMN BORDER
                    JE      INVALID
                    CMP     POSY, 17                        ;CHECK COLUMN BORDER
                    JE      INVALID

                    CMP     POSX, 26
                    JBE     FIND_GRID_ROW
                    INC     GRID_COL
                    CMP     POSX, 38
                    JBE     FIND_GRID_ROW
                    INC     GRID_COL
                    CMP     POSX, 50
                    JBE     FIND_GRID_ROW
                    INC     GRID_COL
            FIND_GRID_ROW:
                    CMP     POSY, 6
                    JBE     IS_EMPTY
                    INC     GRID_ROW
                    CMP     POSY, 11
                    JBE     IS_EMPTY
                    INC     GRID_ROW
                    CMP     POSY, 16
                    JBE     IS_EMPTY
                    INC     GRID_ROW
                    CALL    IS_EMPTY
FIND_GRID           ENDP
;-------------------------------------------------------------------------
;PRINTS INVALID_STR
;-------------------------------------------------------------------------
INVALID             PROC    NEAR
                    MOV     DH, 01
                    MOV     DL, 23
                    CALL    SET_CURSOR
                    LEA     DX, INVALID_STR
                    CALL    DISPLAY
                    CALL    MOUSE_INPUT
INVALID             ENDP
;-------------------------------------------------------------------------
;CHECKS IF CELL IS EMPTY
;-------------------------------------------------------------------------
IS_EMPTY            PROC    NEAR
                    MOV     AX, GRID_ROW
                    MUL     FOUR                            ;MULTIPLY BY 4
                    ADD     AX, GRID_COL                    ;ADD GRID_COL
                    MOV     SI, AX
                    MOV     DL, GRID_ARRAY[SI]
                    CMP     DL, 0                           ;CHECK IF GRID_ARRAY[SI] IS EMPTY
                    JNE     INVALID
                    CALL    IS_VALID
IS_EMPTY            ENDP
;-------------------------------------------------------------------------
;CHECKS IF MOVE IS VALID, FLIPS DISCS
;-------------------------------------------------------------------------
IS_VALID            PROC    NEAR
                    MOV     HAS_MOVE,0                      ;WILL CHECK LATER IF MOVE IS VALID BASED ON HAS_MOVE'S VALUE
                    MOV     PCS_TO_FLIP,0                   ;SET PCS_TO_FLIP TO 0, INCREASE EVERYTIME AN OPPOSITE DISCS IS ENCOUNTERED
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX                    ;CURR_COL AND CURR_ROW USED FOR LOOPING
                    CMP     GRID_COL, 0                     ;IF GRID_COL IS 0, NO NEED TO PROCEED CHECKING. PRECHECK FOR LEFT
                    JNE     LC1
                    JMP     START_RIGHT
            LC1:
                    CMP     GRID_COL, 1                     ;IF GRID_COL IS 1, NO NEED TO PROCEED CHECKING. PRECHECK FOR LEFT
                    JNE     LINT
                    JMP     START_RIGHT
            LINT:
                    MOV     CX, CURR_COL
                    INC     CX
            LEFT:
                    MOV     AX, CURR_ROW                    ;CONVERT CURR_ROW AND CURR_COL TO SI BY USING THE FORMULA
                    MUL     FOUR                            ;( CURR_ROW * 4 ) + CURR_COL
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AH,GRID_ARRAY[SI]               ;MOVE GRID_ARRAY[SI]'S VALUE TO AH
                    MOV     AL,TURN_BOL                     ;MOVE TURN_BOL'S VALUE TO AL
                    CMP     AL,AH                           ;CHECKS IF CURRENT DISCS IS EQUAL TO TURN BOL. IF EQUAL, CHECK PCS_TO_FLIP
                    JE      LEFT_FLAG
                    CMP     GRID_ARRAY[SI],0                ;IF AN EMPTY CELL IS SEEN, PROCEED TO NEXT CHECKPOINT
                    JE      START_RIGHT
                    INC     PCS_TO_FLIP                     ;IF CELL IS OPPOSITE OF TURN_BOL, INCREASE PCS_TO_FLIP
                    DEC     CURR_COL
                    LOOP    LEFT
                    JMP     START_RIGHT
            LEFT_FLAG:
                    CMP     PCS_TO_FLIP,0                   ;IF PCS_TO_FLIP IS NOT 0, FLIP DISCS.
                    JE      START_RIGHT                     ;IF PCS_TO_FLIP IS 0, PROCEED TO NEXT CHECKPOINT
                    INC     HAS_MOVE                        ;INITIALIZE VALUES FOR FLIPPING
                    MOV     AX, GRID_COL                    ;CURR_COL AND CURR_ROW USED FOR LOOPING
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX

                    MOV     CX, PCS_TO_FLIP                 ;FLIP DISCS BASED ON NUMBER OF PCS_TO_FLIP
            LEFT_FLIP:
                    MOV     AX, CURR_ROW                    ;CONVERT CURR_ROW AND CURR_COL TO SI BY USING THE FORMULA
                    MUL     FOUR                            ;( CURR_ROW * 4 ) + CURR_COL
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL, TURN_BOL
                    MOV     GRID_ARRAY[SI],AL               ;FLIP DISCS
                    DEC     CURR_COL
                    LOOP    LEFT_FLIP

            START_RIGHT:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX
                    CMP     GRID_COL, 2                     ;IF GRID_COL IS 2 , NO NEED TO PROCEED CHECKING.
                    JE      START_UP
                    CMP     GRID_COL, 3                     ;IF GRID_COL IS 3 , NO NEED TO PROCEED CHECKING.
                    JE      START_UP
            RIGHT:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      RIGHT_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_UP
                    INC     PCS_TO_FLIP
                    INC     CURR_COL
                    CMP     CURR_COL, 3
                    JG      START_UP
                    JMP     RIGHT
            RIGHT_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      START_UP
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            RIGHT_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL, TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    INC     CURR_COL
                    LOOP    RIGHT_FLIP
            START_UP:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 0                     ;IF GRID_ROW IS 0 , NO NEED TO PROCEED CHECKING.
                    JE      START_DOWN
                    CMP     GRID_ROW, 1                     ;IF GRID_ROW IS 1 , NO NEED TO PROCEED CHECKING.
                    JE      START_DOWN
            UP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      UP_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_DOWN
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    CMP     CURR_ROW, 0
                    JL      START_DOWN
                    JMP     UP
            UP_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      START_DOWN
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            UP_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    DEC     CURR_ROW
                    LOOP    UP_FLIP
            START_DOWN:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 2
                    JE      START_TL                        ;IF GRID_ROW IS 2 , NO NEED TO PROCEED CHECKING.
                    CMP     GRID_ROW, 3
                    JE      START_TL                        ;IF GRID_COL IS 3 , NO NEED TO PROCEED CHECKING.
            DOWN:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      DOWN_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_TL
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    CMP     CURR_ROW, 3
                    JG      START_TL
                    JMP     DOWN
            DOWN_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      START_TL
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            DOWN_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    INC     CURR_ROW
                    LOOP    DOWN_FLIP
            START_TL:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 0                     ;IF GRID_ROW IS 0 , NO NEED TO PROCEED CHECKING.
                    JNE     TL_R1
                    JMP     START_TR
            TL_R1:
                    CMP     GRID_ROW, 1                     ;IF GRID_ROW IS 1 , NO NEED TO PROCEED CHECKING.
                    JNE     TL_C0
                    JMP     START_TR
            TL_C0:
                    CMP     GRID_COL, 0                     ;IF GRID_COL IS 0 , NO NEED TO PROCEED CHECKING.
                    JNE     TL_C1
                    JMP     START_TR
            TL_C1:
                    CMP     GRID_COL ,1                     ;IF GRID_COL IS 1 , NO NEED TO PROCEED CHECKING.
                    JNE     TL
                    JMP     START_TR
            TL:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      TL_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_TR
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    DEC     CURR_COL
                    CMP     CURR_ROW, 0
                    JL      START_TR
                    CMP     CURR_COL, 0
                    JL      START_TR
                    JMP     TL
            TL_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JZ      START_TR
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX,PCS_TO_FLIP
            TL_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    DEC     CURR_ROW
                    DEC     CURR_COL
                    LOOP    TL_FLIP
            START_TR:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 0                     ;IF GRID_ROW IS 0 , NO NEED TO PROCEED CHECKING.
                    JNE     TR_R3
                    JMP     START_DL
            TR_R3:
                    CMP     GRID_ROW, 1                     ;IF GRID_ROW IS 1 , NO NEED TO PROCEED CHECKING.
                    JNE     TR_C2
                    JMP     START_DL
            TR_C2:
                    CMP     GRID_COL, 2                     ;IF GRID_COL IS 2 , NO NEED TO PROCEED CHECKING.
                    JNE     TR_C3
                    JMP     START_DL
            TR_C3:
                    CMP     GRID_COL ,3                     ;IF GRID_COL IS 3 , NO NEED TO PROCEED CHECKING.
                    JE      START_DL
            TR:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      TR_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_DL
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    INC     CURR_COL
                    CMP     CURR_ROW, 0
                    JL      START_DL
                    CMP     CURR_COL, 3
                    JG      START_DL
                    JMP     TR
            TR_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      START_DL
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            TR_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    DEC     CURR_ROW
                    INC     CURR_COL
                    LOOP    TR_FLIP
            START_DL:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 2                     ;IF GRID_ROW IS 2 , NO NEED TO PROCEED CHECKING.
                    JNE     DL_R1
                    JMP     START_DR
            DL_R1:
                    CMP     GRID_ROW, 3                     ;IF GRID_ROW IS 3 , NO NEED TO PROCEED CHECKING.
                    JNE     DL_C0
                    JMP     START_DR
            DL_C0:
                    CMP     GRID_COL, 0                     ;IF GRID_COL IS 0 , NO NEED TO PROCEED CHECKING.
                    JNE     DL_C1
                    JMP     START_DR
            DL_C1:
                    CMP     GRID_COL ,1                     ;IF GRID_COL IS 1 , NO NEED TO PROCEED CHECKING.
                    JE      START_DR
            _DL:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      DL_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      START_DR
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    DEC     CURR_COL
                    CMP     CURR_ROW, 3
                    JG      START_DR
                    CMP     CURR_COL, 0
                    JL      START_DR
                    JMP     _DL
            DL_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      START_DR
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            DL_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    INC     CURR_ROW
                    DEC     CURR_COL
                    LOOP    DL_FLIP
            START_DR:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 2                     ;IF GRID_ROW IS 2 , NO NEED TO PROCEED CHECKING.
                    JNE     DR_R3
                    JMP     VALID_END
            DR_R3:
                    CMP     GRID_ROW, 3                     ;IF GRID_COL IS 3 , NO NEED TO PROCEED CHECKING.
                    JNE     DR_C2
                    JMP     VALID_END
            DR_C2:
                    CMP     GRID_COL, 2                     ;IF GRID_COL IS 2 , NO NEED TO PROCEED CHECKING.
                    JNE     DR_C3
                    JMP     VALID_END
            DR_C3:
                    CMP     GRID_COL ,3                     ;IF GRID_COL IS 3 , NO NEED TO PROCEED CHECKING.
                    JNE     DR
                    JMP     VALID_END

            DR:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      DR_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      VALID_END
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    INC     CURR_COL
                    CMP     CURR_ROW, 3
                    JG      VALID_END
                    CMP     CURR_COL, 3
                    JG      VALID_END
                    JMP     DR
            DR_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      VALID_END
                    INC     HAS_MOVE
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    MOV     CX, PCS_TO_FLIP
            DR_FLIP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     GRID_ARRAY[SI],AL
                    INC     CURR_ROW
                    INC     CURR_COL
                    LOOP    DR_FLIP
            VALID_END:
                    CMP     HAS_MOVE,0
                    JE      MOVE_INVALID
                    CALL    CHANGE_TURN
            MOVE_INVALID:
                    CALL    INVALID
IS_VALID            ENDP
;-------------------------------------------------------------------------
;CHECKS IF PLAYER PRESSED LEFT MOUSE BUTTON
;-------------------------------------------------------------------------
MOUSE_INPUT         PROC    NEAR
                    ;CALL   GAME_OVER
                    CALL    GAME_STILL_ON                   ;CHECK IF PLAYER CAN MOVE
            MOUSE_CLICKED:
                    CALL    DISP_MOUSE
                    MOV     GRID_ROW, 0
                    MOV     GRID_COL, 0
                    MOV     DH, 01
                    MOV     DL, 59
                    CALL    SET_CURSOR                      ;SET CURSOR FOR TURN
                    CMP     TURN_BOL, 1
                    JNE     PRINT_P2
                    LEA     DX, P1TURN_STR                  ;PRINT BLACK STRING
                    JMP     CHECK_BUTTON
            PRINT_P2:
                    LEA     DX, P2TURN_STR                  ;PRINT WHITE STRING
            CHECK_BUTTON:
                    CALL    DISPLAY
                    MOV     MOUSEX, 0
                    MOV     MOUSEY, 0
                    MOV     AX, 03                          ;GET MOUSE POSITION AND BUTTON STATUS
                    INT     33H
                    CMP     BX, 0001H                       ;CHECK IF LEFT BUTTON IS CLICKED
                    JNE     MOUSE_CLICKED
                    CALL    BEEP_1
                    CALL    FIND_GRID                       ;IF LEFT BUTTON IS CLICKED, LOCATE WHICH GRID
MOUSE_INPUT ENDP
;-------------------------------------------------------------------------
;UPDATES TURN
;-------------------------------------------------------------------------
CHANGE_TURN         PROC    NEAR
                    MOV     AX, GRID_ROW
                    MUL     FOUR                            ;MULTIPLY BY 4
                    ADD     AX, GRID_COL                    ;ADD GRID_COL
                    MOV     SI, AX
                    CMP     TURN_BOL, 1
                    JNE     DEC_TURN_BOL
                    MOV     BH, 20H
                    MOV     GRID_ARRAY[SI],1                ;SET GRID_ARRAY[SI] TO BLACK
                    INC     TURN_BOL
                    JMP     PRINT_VALID
            DEC_TURN_BOL:
                    MOV     BH, 2FH
                    MOV     GRID_ARRAY[SI],2                ;SET GRID_ARRAY[SI] TO WHITE
                    DEC     TURN_BOL
            PRINT_VALID:
                    CALL    DELAYMORE
                    CALL    UPDATE_SCORE
                    MOV     DH, 01
                    MOV     DL, 23
                    CALL    SET_CURSOR
                    LEA     DX, VALID_STR
                    CALL    DISPLAY
                    CALL    MOUSE_INPUT
CHANGE_TURN         ENDP
;-------------------------------------------------------------------------
;CHECKS IF CELL IS VALID FOR MOVEMENT
;-------------------------------------------------------------------------
CHECK_POSSIBLE      PROC    NEAR
                    MOV     PCS_TO_FLIP,0                   ;WILL CHECK LATER IF MOVE IS VALID BASED ON HAS_MOVE'S VALUE
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX

                    CMP     GRID_COL, 0
                    JNE     _LC1
                    JMP     _START_RIGHT
            _LC1:                                           ;IF GRID_COL IS 1, NO NEED TO PROCEED CHECKING. PRECHECK FOR LEFT
                    CMP     GRID_COL, 1
                    JNE     _LINT
                    JMP     _START_RIGHT
            _LINT:
                    MOV     CX, CURR_COL
                    INC     CX
            __LEFT:                                         ;CONVERT CURR_ROW AND CURR_COL TO SI BY USING THE FORMULA
                    MOV     AX, CURR_ROW                    ;( CURR_ROW * 4 ) + CURR_COL
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AH,GRID_ARRAY[SI]
                    MOV     AL,TURN_BOL
                    CMP     AL,AH
                    JE      _LEFT_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_RIGHT
                    INC     PCS_TO_FLIP
                    DEC     CURR_COL
                    JL      _START_RIGHT
                    LOOP    __LEFT
                    JMP     _START_RIGHT
            _LEFT_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_RIGHT
                    JMP     _HAS_MOVE
            _START_RIGHT:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    MOV     CURR_ROW, AX

                    CMP     GRID_COL, 2
                    JE      _START_UP
                    CMP     GRID_COL, 3
                    JE      _START_UP
            __RIGHT:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _RIGHT_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_UP
                    INC     PCS_TO_FLIP
                    INC     CURR_COL
                    CMP     CURR_COL, 3
                    JG      _START_UP
                    JMP     __RIGHT
            _RIGHT_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_UP
                    JMP     _HAS_MOVE
            _START_UP:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX

                    CMP     GRID_ROW, 0
                    JE      _START_DOWN
                    CMP     GRID_ROW, 1
                    JE      _START_DOWN
            _UP:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _UP_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_DOWN
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    CMP     CURR_ROW, 0
                    JL      _START_DOWN
                    JMP     _UP
            _UP_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_DOWN
                    JMP     _HAS_MOVE
            _START_DOWN:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX

                    CMP     GRID_ROW, 2
                    JE      _START_TL
                    CMP     GRID_ROW, 3
                    JE      _START_TL
            _DOWN:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _DOWN_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_TL
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    CMP     CURR_ROW, 3
                    JG      _START_TL
                    JMP     _DOWN
            _DOWN_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_TL
                    JMP     _HAS_MOVE
            _START_TL:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 0
                    JNE     _TL_R1
                    JMP     _START_TR
            _TL_R1:
                    CMP     GRID_ROW, 1
                    JNE     _TL_C0
                    JMP     _START_TR
            _TL_C0:
                    CMP     GRID_COL, 0
                    JNE     _TL_C1
                    JMP     _START_TR
            _TL_C1:
                    CMP     GRID_COL ,1
                    JNE     _TL
                    JMP     _START_TR
            _TL:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _TL_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_TR
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    DEC     CURR_COL
                    CMP     CURR_ROW, 0
                    JL      _START_TR
                    CMP     CURR_COL, 0
                    JL      _START_TR
                    JMP     _TL
            _TL_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_TR
                    JMP     _HAS_MOVE
            _START_TR:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    DEC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 0
                    JNE     _TR_R3
                    JMP     _START_DL
            _TR_R3:
                    CMP     GRID_ROW, 1
                    JNE     _TR_C2
                    JMP     _START_DL
            _TR_C2:
                    CMP     GRID_COL, 2
                    JNE     _TR_C3
                    JMP     _START_DL
            _TR_C3:
                    CMP     GRID_COL ,3
                    JE      _START_DL
            _TR:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _TR_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_DL
                    INC     PCS_TO_FLIP
                    DEC     CURR_ROW
                    INC     CURR_COL
                    CMP     CURR_ROW, 0
                    JL      _START_DL
                    CMP     CURR_COL, 3
                    JG      _START_DL
                    JMP     _TR
            _TR_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_DL
                    JMP     _HAS_MOVE
            _START_DL:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    DEC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX

                    CMP     GRID_ROW, 2
                    JNE     _DL_R1
                    JMP     _START_DR
            _DL_R1:
                    CMP     GRID_ROW, 3
                    JNE     _DL_C0
                    JMP     _START_DR
            _DL_C0:
                    CMP     GRID_COL, 0
                    JNE     _DL_C1
                    JMP     _START_DR
            _DL_C1:
                    CMP     GRID_COL ,1
                    JE      _START_DR
            __DL:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _DL_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _START_DR
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    DEC     CURR_COL
                    CMP     CURR_ROW, 3
                    JG      _START_DR
                    CMP     CURR_COL, 0
                    JL      _START_DR
                    JMP     __DL
            _DL_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JE      _START_DR
                    JMP     _HAS_MOVE
            _START_DR:
                    MOV     PCS_TO_FLIP,0
                    MOV     AX, GRID_COL
                    INC     AX
                    MOV     CURR_COL, AX
                    MOV     AX,GRID_ROW
                    INC     AX
                    MOV     CURR_ROW, AX
                    CMP     GRID_ROW, 2
                    JNE     _DR_R3
                    JMP     _VALID_END
            _DR_R3:
                    CMP     GRID_ROW, 3
                    JNE     _DR_C2
                    JMP     _VALID_END
            _DR_C2:
                    CMP     GRID_COL, 2
                    JNE     _DR_C3
                    JMP     _VALID_END
            _DR_C3:
                    CMP     GRID_COL ,3
                    JNE     _DR
                    JMP     _VALID_END
            _DR:
                    MOV     AX, CURR_ROW
                    MUL     FOUR
                    ADD     AX, CURR_COL
                    MOV     SI, AX
                    MOV     AL,TURN_BOL
                    MOV     AL,TURN_BOL
                    MOV     AH,GRID_ARRAY[SI]
                    CMP     AL,AH
                    JE      _DR_FLAG
                    CMP     GRID_ARRAY[SI],0
                    JE      _VALID_END
                    INC     PCS_TO_FLIP
                    INC     CURR_ROW
                    INC     CURR_COL
                    CMP     CURR_ROW, 3
                    JG      _VALID_END
                    CMP     CURR_COL, 3
                    JG      _VALID_END
                    JMP     _DR
            _DR_FLAG:
                    CMP     PCS_TO_FLIP,0
                    JNE     _HAS_MOVE
            _VALID_END:
                    MOV     HAS_MOVE,0
                    RET
            _HAS_MOVE:
                    MOV     HAS_MOVE,1
                    RET
CHECK_POSSIBLE      ENDP
;-------------------------------------------------------------------------
;CHECKS IF GAME IS STILL ON
;-------------------------------------------------------------------------
GAME_STILL_ON       PROC    NEAR
                    MOV     GRID_COL,0
                    MOV     GRID_ROW,0
                    MOV     SI,0
            GAME_LOOP:
                    CMP     GRID_ARRAY[SI], 0               ;CHECKS IF CELL IS EMPTY
                    JNE     INCREMENT
                    CALL    CHECK_POSSIBLE                  ;IF EMPTY, CHECK IF MOVE IS VALID
                    CMP     HAS_MOVE,1                      ;CHECKS IF A PLAYER CAN STILL MOVE
                    JE      ___RETURN                       ;IF YES, RETURN. GAME IS STILL ON
            INCREMENT:
                    INC     GRID_COL                        ;INCREMENTS GRID_COL AND GRID_ROW
                    CMP     GRID_COL,4
                    JNE     COMPUTE_SI
                    INC     GRID_ROW
                    MOV     GRID_COL,0
            COMPUTE_SI:                                     ;COVERT GRID_ROW AND GRID_COL TO SI
                    MOV     AX, GRID_ROW                    ;FORMULA: ROW * 4 + COL
                    MUL     FOUR
                    ADD     AX, GRID_COL
                    MOV     SI, AX
                    CMP     SI,16
                    JE      __GAME_OVER
                    JMP     GAME_LOOP
            ___RETURN:
                    RET                                     ;RETURN, GAME IS STILL ON
            __GAME_OVER:
                    CALL    GAME_OVER                       ;IF NO VALD MOVE POSSIBLE, GAME ENDS
GAME_STILL_ON       ENDP
;-------------------------------------------------------------------------
;GAME OVER SCREEN, DISPLAYS WINNER
;-------------------------------------------------------------------------
GAME_OVER           PROC    NEAR
                    CALL    DELAYMORE
                    CALL    HIDE_MOUSE
                    CALL    CLEAR_SCREEN
                    MOV     DH, 0
                    MOV     DL, 0
                    CALL    SET_CURSOR
                    LEA     DX, GAMEOVER
                    CALL    FILE_READ
                    MOV     DH,7
                    MOV     DL,33
                    CALL    SET_CURSOR
                    CALL    COMBI1
                    MOV     AX, BLACK_SCORE
                    DIV     TEN
                    MOV     CL,AL
                    MOV     AX, WHITE_SCORE
                    DIV     TEN
                    MOV     CH,AL
                    CMP     CL,CH
                    JE      COMPARE_ONES
                    JL      WHITE_WINS
                    JG      BLACK_WINS
            COMPARE_ONES:
                    MOV     AX, BLACK_SCORE
                    DIV     TEN
                    MOV     CL,AH
                    MOV     AX, WHITE_SCORE
                    DIV     TEN
                    MOV     CH,AH
                    CMP     CL,CH
                    JE      DRAW
                    JL      WHITE_WINS
                    JG      BLACK_WINS
            DRAW:
                    LEA     DX, DRAW_STR
                    CALL    DISPLAY
                    JMP     ENTER_NAME
            BLACK_WINS:
                    LEA     DX, BLACKW_STR
                    CALL    DISPLAY
                    JMP     ENTER_NAME
            WHITE_WINS:
                    LEA     DX, WHITEW_STR
                    CALL    DISPLAY
            ENTER_NAME:
                    MOV     DH, 15
                    MOV     DL, 35
                    CALL    SET_CURSOR
                    LEA     DX, WINNER_NAME                 ;GET WINNER NAME INPUT
                    MOV     AH, 3FH
                    MOV     BX, 00
                    MOV     CX, 20
                    INT     21H

                    CALL    WRITE_WINNER
                    CALL    GAME_CH
GAME_OVER           ENDP
;-------------------------------------------------------------------------
;WRITE WINNER NAME TO FILE
;-------------------------------------------------------------------------
WRITE_WINNER        PROC    NEAR
                    MOV     AH, 3CH                         ;REQUEST CREATE FILE
                    MOV     CX, 00                          ;NORMAL ATTRIBUTE
                    LEA     DX, WINNER_FILE                 ;LOAD PATH AND FILE NAME
                    INT     21H
                    JC      DIS_WRITEERR1                   ;IF THERE'S ERROR IN CREATING FILE, CARRY FLAG = 1, OTHERWISE 0
                    MOV     WFILEHANDLE, AX

                    MOV     AH, 40H                         ;REQUEST WRITE RECORD
                    MOV     BX, WFILEHANDLE                 ;FILE HANDLE
                    MOV     CX, 10                          ;RECORD LENGTH
                    LEA     DX, WINNER_NAME                 ;ADDRESS OF OUTPUT AREA
                    INT     21H
                    JC      DIS_WRITEERR2                   ;IF CARRY FLAG = 1, THERE'S ERROR IN WRITING (NOTHING IS WRITTEN)
                    CMP     AX, 10                          ;AFTER WRITING, SET AX TO SIZE OF CHARS NGA NA WRITE
                    JNE     DIS_WRITEERR3
                    JMP     CLOSE_FILE_HANDLE

            DIS_WRITEERR1:
                    LEA     DX, WRITE_ERR1
                    MOV     AH, 09
                    INT     21H
                    JMP     CLOSE_FILE_HANDLE

            DIS_WRITEERR2:
                    LEA     DX, WRITE_ERR2
                    MOV     AH, 09
                    INT     21H
                    JMP     CLOSE_FILE_HANDLE

            DIS_WRITEERR3:
                    LEA     DX, WRITE_ERR3
                    MOV     AH, 09
                    INT     21H
                    JMP     CLOSE_FILE_HANDLE

            CLOSE_FILE_HANDLE:
                    MOV     AH, 3EH                         ;REQUEST CLOSE FILE
                    MOV     BX, WFILEHANDLE                 ;FILE HANDLE
                    INT     21H

                    RET

WRITE_WINNER        ENDP
;-------------------------------------------------------------------------
;MENU FOR GAME OVER
;-------------------------------------------------------------------------
GAME_CH             PROC    NEAR
                    MOV     ROW, 11
                    MOV     COL, 15
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, ARROW
                    CALL    DISPLAY
            GAME_CHOOSE:
                    MOV     AH, 10H                         ;GET INPUT
                    INT     16H
                    CMP     AL, 0DH                         ;ENTER
                    JE      GAME_CHOICE
                    CMP     AH, 4BH                         ;LEFT
                    JE      GAME_LEFT
                    CMP     AH, 4DH                         ;RIGHT
                    JE      GAME_RIGHT
                    JMP     GAME_CHOOSE
            GAME_RIGHT:
                    CALL    BEEP_1
                    CMP     COL, 49                         ;IF RIGHT KEY
                    JE      GAME_CHOOSE
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, SPACE
                    CALL    DISPLAY
                    ADD     COL, 17
                    CALL    GAME_DISP_ARR
            GAME_LEFT:
                    CALL    BEEP_1
                    CMP     COL, 15                         ;IF LEFT KEY
                    JE      GAME_CHOOSE
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR
                    LEA     DX, SPACE
                    CALL    DISPLAY
                    SUB     COL, 17
                    CALL    GAME_DISP_ARR
            GAME_CHOICE:
                    CMP     COL, 15                         ;START GAME SCREEN
                    JE      GAME_GO_PLAY
                    CMP     COL, 32
                    JE      GAME_GO_HOME                    ;HELP SCREEN
                    CMP     COL, 49
                    JE      GAME_GO_EXIT                    ;EXIT SCREEN
            GAME_DISP_ARR:
                    MOV     DH, ROW
                    MOV     DL, COL
                    CALL    SET_CURSOR                      ;DISPLAY ARROW ASCII [>]
                    LEA     DX, ARROW
                    CALL    DISPLAY
                    JMP     GAME_CHOOSE
            GAME_GO_PLAY:
                    CALL    GAME_SCREEN
            GAME_GO_HOME:
                    CALL    HOME_SCREEN
            GAME_GO_EXIT:
                    CALL    EXIT_SCREEN
GAME_CH             ENDP
;-------------------------------------------------------------------------
;DISPLAYS HELP SCREEN
;-------------------------------------------------------------------------
HELP_SCREEN         PROC    NEAR
                    MOV     DH, 0                           ;X COORDINATE
                    MOV     DL, 0                           ;Y COORDINATE
                    CALL    SET_CURSOR
                    CALL    CLEAR_SCREEN                    ;CLEARS SCREEN
                    LEA     DX, HELP                        ;DISPLAYS CONTENT FROM FILE
                    CALL    FILE_READ
                    MOV     AH, 00H                         ;GETS INPUT
                    INT     16H
                    JMP     HOME_SCREEN                     ;RETURNS TO HOME SCREEN
HELP_SCREEN         ENDP
;-------------------------------------------------------------------------
;TERMINATES PROGRAM, DOUBLE JMP
;-------------------------------------------------------------------------
EXIT_SCREEN         PROC    NEAR
                    CALL    TERMINATE
EXIT_SCREEN         ENDP
;-------------------------------------------------------------------------
;PRODUCES BEEP SOUND
;-------------------------------------------------------------------------
BEEP_1              PROC    NEAR
                    MOV     AL, 182
                    OUT     43H, AL
                    MOV     AX, 4304
                    OUT     42H, AL
                    MOV     AL, AH
                    OUT     42H, AL
                    IN      AL, 61H
                    OR      AL, 00000011B
                    OUT     61H, AL
                    MOV     BEEPBX, 25
            .PAUSEA:
                    MOV     BEEPCX, 2900
            .PAUSEB:
                    DEC     BEEPCX
                    JNE     .PAUSEB
                    DEC     BEEPBX
                    JNE     .PAUSEA
                    IN      AL, 61H
                    AND     AL, 11111100B
                    OUT     61H, AL
                    RET
BEEP_1              ENDP
;-------------------------------------------------------------------------
;PRODUCES MUSIC
;-------------------------------------------------------------------------
MUSIC               PROC    NEAR                            ;PRODUCES MUSIC FOR THE GAMEOVER SCREEN
                    MOV     AL, 182
                    OUT     43H, AL

                    OUT     42H, AL
                    MOV     AL, AH
                    OUT     42H, AL
                    IN      AL, 61H

                    OR      AL, 00000011B
                    OUT     61H, AL
                    MOV     BEEPBX, 25

            .PAUSE1:                                        ;DELAY TO MAKE THE BEEP LONGER
            .PAUSE2:
                    DEC     BEEPCX
                    JNE     .PAUSE2
                    DEC     BEEPBX
                    JNE     .PAUSE1
                    IN      AL, 61H

                    AND     AL, 11111100B
                    OUT     61H, AL
                    RET
MUSIC               ENDP
;-------------------------------------------------------------------------
;PRODUCES MUSIC COMBO
;-------------------------------------------------------------------------
COMBI1              PROC    NEAR                            ;MUSIC COMBINATION 1
                    MOV     AX, 2152
                    MOV     BEEPCX, 500
                    CALL    MUSIC
                    MOV     AX, 3403
                    MOV     BEEPCX, 10
                    CALL    MUSIC
                    MOV     AX, 3224
                    MOV     BEEPCX, 1
                    CALL    MUSIC
                    MOV     AX, 3416
                    MOV     BEEPCX, 10
                    CALL    MUSIC
                    MOV     AX, 3834
                    MOV     BEEPCX, 10
                    CALL    MUSIC
                    RET
COMBI1     ENDP
END                 A10MAIN
