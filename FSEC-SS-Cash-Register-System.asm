.model small 

.stack 100h 

.data 

        CRLF db 13, 10, '$' 

        header db "FSEC-SS CASH REGISTER SYSTEM",13,10,'$' 

        menu db "Select an option:", 13, 10, '$' 

        option1 db "1. RSA Conference - RM 6", 13, 10,'$' 

        option2 db "2. CyberUK - RM 6", 13, 10,'$' 

        option3 db "3. CyberTalks - RM 6", 13, 10,'$' 

        option4 db "4. Secure Coding Practices - RM 4", 13, 10,'$' 

        option5 db "5. Advanced Persistent Threats - RM 4", 13, 10,'$' 

        option6 db "6. National Cyber League - RM 12", 13, 10,'$' 

        option7 db "7. SANS CyberStart Game - RM 12", 13, 10,'$' 

        option8 db 13,10,"8. Calculate total price", 13, 10,'$' 

        category1 db "Workshop: " , 13,10,'$' 

        category2 db "Competitions: " , 13,10,'$' 

        category3 db "Activities: " , 13,10,'$' 

        prompt db "Option: $" 

        options db 7 dup(0) ; Array to store the selected options 

        compNCL dw 3 

        compSCG dw 5 

        compFull db "The option selected is sold out. Please join another event", 13, 10, '$' 

        invalidOp db "Option not available, Please enter a valid option.", 13, 10, '$' 

        alreadySelected db "Option already selected, please select a different option.", 13, 10,'$' 

        selected db "You have selected: ", 13, 10, '$' 

        more db "Do you want to select another option? (y/n) $" 

        sum dw 0 

        total1 db "Total fees: RM $" 

        total2 db "Total fees as member(50% discount): RM $" 

        new db "Do you want to start a new registration? (y/n) $" 

         

.code 

showMess Macro Mess 

        mov ah,09h 

        mov dx,offset Mess 

        int 21h 

ENDM 

  

showMenu Macro 

        ; Print menu 

        showMess header 

        showMess menu 

        showMess category1 

        showMess option1 

        showMess option2 

        showMess option3 

        showMess category3 

        showMess option4 

        showMess option5 

        showMess category2 

        showMess option6 

        showMess option7 

        showMess option8 

ENDM 

  

newLine Macro 

        ;Line feed 

        mov ah, 09h 

        mov dx, offset CRLF 

        int 21h 

ENDM 

  

show2Digit Macro 

        aam 

        add ax, 3030h 

        mov dh,al 

        mov dl,ah 

        mov ah,2h 

        int 21h 

        mov dl,dh 

        mov ah,2h 

        int 21h 

ENDM 

  

MAIN PROC 

  

        mov ax,@Data 

        mov ds,ax     

     

        newRes: 

        mov sum, 0; Initialize sum 

        mov bx,0 ; initialize for reset array 

        resetA: ; reset array 

        mov options[bx],0 

        inc bx 

        cmp bx,7 

        je resetA 

        mov bx, 0 ; Initialize the counter for the number of options selected 

         

        ask: 

        showMenu 

  

        ; Print prompt 

        newLine 

        mov ah, 09h 

        mov dx, offset prompt 

        int 21h 

  

        ; Read option 

        mov ah, 01h 

        int 21h 

  

        newLine 

        newLine 

         

        ;Check input within options 

        cmp al, '1' 

        jl invalid ; jump to invalid if input less than 1 

        cmp al, '8' 

        jg invalid ; jump to invalid if input more than 8 

        jmp check2 

         

        invalid: 

        mov ah, 09h 

        mov dx, offset invalidOp 

        int 21h 

        ;Line feed 

        mov ah, 09h 

        mov dx, offset CRLF 

        int 21h 

        jmp ask 

         

        check2: 

        ;calculate fees option 

        cmp al,'8' 

        jne check3 

        jmp stopAsk 

         

        check3: 

        ;check is option selected 

        mov cx,bx 

        search: 

        dec bx 

        cmp al, options[bx] 

        je invalid2 

        cmp bx, 0 

        jg search 

        mov bx,cx 

        newLine 

        jmp check4 

         

        invalid2: 

        mov bx,cx 

        mov ah, 09h 

        mov dx, offset alreadySelected 

        int 21h 

        newLine 

        jmp ask 

         

        check4: 

        ;Dec comp space 

        cmp al,'6' 

        jne c2 

        mov cx,compNCL 

        cmp cx,0 

        je full 

        dec cx 

        mov compNCL,cx 

        jmp valid 

        c2: 

        cmp al,'7' 

        jne valid 

        mov cx,compSCG 

        cmp cx,0 

        je full 

        dec cx 

        mov compSCG,cx 

        jmp valid 

         

        ;comp full 

        full: 

        showMess compFull 

        newLine 

        jmp ask 

         

        valid: 

        ; Store the option in the array 

        mov options[bx], al 

         

        ;add fee 

        cmp al,'3' 

        jg L2 

        mov ax,sum 

        add ax,6 

        mov sum,ax 

        jmp FL 

        L2: 

        cmp al,'5' 

        jg L3 

        mov ax,sum 

        add ax,4 

        mov sum,ax 

        jmp FL 

        L3: 

        mov ax,sum 

        add ax,12 

        mov sum,ax 

        FL: 

         

        ; Increase the counter for options array 

        inc bx 

  

        ; Print prompt to ask if the user wants to select another option 

        mov ah, 09h 

        mov dx, offset more 

        int 21h 

  

        ; Read user response 

        mov ah, 01h 

        int 21h 

  

        newLine 

        newLine 

         

        ; Check if the user wants to select another option 

        cmp al, 'y' 

        jne stopAsk 

        jmp ask ;ask again 

         

        stopAsk: 

        ; Print the selected options 

        mov ah, 09h 

        mov dx, offset selected 

        int 21h 

  

        mov cx, bx 

        mov bx, 0 

  

        printSelected: 

        ; Print option selected 

        cmp options[bx],'1' 

        jne s2 

        showMess option1 

        jmp ns 

        s2: 

        cmp options[bx],'2' 

        jne s3 

        showMess option2 

        jmp ns 

        s3: 

        cmp options[bx],'3' 

        jne s4 

        showMess option3 

        jmp ns 

        s4: 

        cmp options[bx],'4' 

        jne s5 

        showMess option4 

        jmp ns 

        s5: 

        cmp options[bx],'5' 

        jne s6 

        showMess option5 

        jmp ns 

        s6: 

        cmp options[bx],'6' 

        jne s7 

        showMess option6 

        jmp ns 

        s7: 

        cmp options[bx],'7' 

        jne ns 

        showMess option7 

        ns: 

        inc bx 

        dec cx 

        cmp cx,0 

        jle stopPS 

        jmp printSelected 

        stopPS: 

        newLine 

         

         

        ; Print the total 

        printt: 

        newLine 

        mov ah,09h 

        mov dx, offset total1 

        int 21h 

        mov ax,sum 

        show2Digit 

        newLine 

         

        mov ah, 09h 

        mov dx, offset total2 

        int 21h 

        mov ax,sum 

        sar ax,1 

        show2Digit 

        newLine 

         

         

        newLine 

        newLine 

         

        ;New registration 

        mov ah, 09h 

        mov dx, offset new 

        int 21h 

         

        ; Read user response 

        mov ah, 01h 

        int 21h 

  

        newLine 

        newLine 

         

        ; Check if the user wants to start new registration 

        cmp al, 'y' 

        jne bot 

        jmp newRes ;new registration 

         

        bot: 

        ;end program 

        mov ah,4ch 

        int 21h   

         

         

MAIN ENDP 

END MAIN 
