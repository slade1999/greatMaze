
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
include 'emu8086.inc'

org 100h

;STEP 1 PRINT MAZE
mov CX, rows
mov BX, 0
printRow: ;main loop for printing maze
    mov holdCount, CX;holdCount now holds the number of rows
    mov cx, cols 
    printAnother: ;prints a row
        mov al, maze + bx;add bx to ensure whole row is printed
        call symbol
        putc al
        inc bx
        loop printAnother
    printn ;goes to the next line
    mov cx, holdCount
    loop printRow
    CURSOROFF 
call move  

;----------------------------------------
     ;function for changing symbols
    
symbol PROC;start
    cmp maze + bx, 1   ;if the value is the wall
    jz wall
    cmp maze + bx, 2   ;if the value is the goal
    jz goal
    jmp done   
    wall: 
        mov al, 219d   ;wall icon
        jmp done
        
    goal:
        mov al, 15d    ;goal icon
        jmp done 
        
    done:
    ret
symbol ENDP;end
    
;------------------------------------------
         ;function for moving

move PROC;start function 
code: 
    gotoxy x, y
    mov bx, pos
    mov al, maze + bx
    cmp al, 2
    jz win;when player reaches goal
    
    
    mov ah, 0
    int 16h    ;reads user input
    cmp al, 'd' ;if user wants to go right
    je right
    cmp al, 'a' ;if user wants to go left
    je left
    cmp al, 'w' ;if user wants to go up
    je up
    cmp al, 's' ;if user wants to go down
    je down 
    
    right:
        gotoxy x,y  ;sets cursor to player location
        inc x       ;adds 1
        inc pos     ;update pos location
        mov bx, pos 
        mov al, maze + bx ;sets al to the value at players next location
        cmp al, 1        
        jz mRight ;if collision beep will happen and player will not move
        jmp rNext
       mRight:
        putc 07;beep
        putc 03
        sub pos, 1 ;neccessary to keep pos at correct place
        sub x, 1
        jmp code ;restarts move function       
       rNext:    ;label for when no wall 
        putc 00
        gotoxy x,y 
        putc 03     ;sets the new location for player 
        jmp code 
        
    left:
        gotoxy x,y
        sub x, 1    ;go left one value in maze
        sub pos, 1
        mov bx, pos
        mov al, maze + bx
        cmp al, 1
        jz mLeft
        jmp lNext
       mLeft:
        putc 07
        putc 03
        inc pos
        inc x
        jmp code
       lNext:
        putc 00
        gotoxy x,y
        putc 03     ;sets the new location for player 
        jmp code
        
    up:
        gotoxy x,y
        sub y, 1   ;for up and down we replace x with y in the operations
        sub pos, cols ;sets pos to 1 above
        mov bx, pos
        mov al, maze + bx
        cmp al, 1
        jz mUp
        jmp uNext
       mUp:
        putc 07
        putc 03
        add pos, cols ;resets pos position before collision
        inc y
        jmp code
       uNext:
        putc 00
        gotoxy x,y
        putc 03     ;sets the new location for player 
        jmp code
        
    down:
        gotoxy x,y 
        inc y
        add pos, cols ;sets pos to 1 below
        mov bx, pos
        mov al, maze + bx
        cmp al, 1
        jz mDown
        jmp dNext
       mDown:
        putc 07
        putc 03
        sub pos, cols
        sub y, 1
        jmp code
       dNext:
        putc 00
        gotoxy x,y
        putc 03     ;sets the new location for player 
        jmp code    
        
        
    ret 
move ENDP;ends function  

;--------------------------------------------------------
 
win:
    call CLEAR_SCREEN     ;clears screen
    printn "You did poorly." ;enthusiastic congratulations


ret
 
;outline of the maze
maze db 1,1,1,1,1,1,1,1,1,1
     db 1,3,0,0,0,0,0,0,0,1
     db 1,0,1,1,1,0,1,1,0,1
     db 1,0,1,0,0,0,1,0,0,1
     db 1,0,1,0,1,1,1,1,0,1
     db 1,0,1,0,1,0,0,0,1,1
     db 1,0,1,0,1,0,1,0,1,1
     db 1,0,1,0,0,0,1,0,1,1
     db 1,0,1,1,1,1,1,0,2,1
     db 1,1,1,1,1,1,1,1,1,1 
    cols = 10
    rows = 10
    holdCount dw 0
    pos dw 11d ;player postion
    x db 1
    y db 1;x and y coordinates of player
    
    
DEFINE_CLEAR_SCREEN 


;Tried coloring, made blob



