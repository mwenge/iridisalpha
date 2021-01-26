# DNA by Jeff Minter

<img src="https://user-images.githubusercontent.com/58846/103443219-cfab3580-4c54-11eb-8046-0f5f3bac9c79.gif" width=700>


This is the disassembled and [commented source code] for the demo DNA by Jeff Minter. 

## Requirements

* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/iridisalpha/blob/master/dna/src/dna.asm
To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`dna.prg`) do:

```sh
$ make dna
```

## Notes on the Code

### Sprite and Character Set compression
Minter uses a compression scheme for storing character sets and sprites:

- The sprite and charset data is read from the end instead of the front.          
- When a sequence such as $00,$05,$1E is encountered it is treated as a tag length
  value (TLV) where $1E is the tag, $00 is the character to output and $05 is the 
  number of instances to output. So $00,$05,$1E translates to $00,$00,$00,$00,$00.

In practice this scheme is most effective when storing long sequences of zeroes in sprite data. Here is an example:

```asm
; SPRITE $02                                                    
; $00,$00,$00 000000000000000000000000                          
; $00,$A8,$00 000000001010100000000000         * * *            
; $0B,$AA,$80 000010111010101010000000     * *** * * * *        
; $2E,$AA,$A0 001011101010101010100000   * *** * * * * * *      
; $2A,$AA,$A0 001010101010101010100000   * * * * * * * * *      
; $2A,$AA,$A0 001010101010101010100000   * * * * * * * * *      
; $FE,$AA,$A8 111111101010101010101000 ******* * * * * * * *    
; $5E,$AA,$A8 010111101010101010101000  * **** * * * * * * *    
; $5E,$AA,$A8 010111101010101010101000  * **** * * * * * * *    
; $5E,$AA,$A8 010111101010101010101000  * **** * * * * * * *    
; $FE,$AA,$A8 111111101010101010101000 ******* * * * * * * *    
; $2A,$AA,$A0 001010101010101010100000   * * * * * * * * *      
; $2A,$AA,$A0 001010101010101010100000   * * * * * * * * *      
; $2A,$AA,$A0 001010101010101010100000   * * * * * * * * *      
; $0A,$AA,$80 000010101010101010000000     * * * * * * *        
; $00,$A8,$00 000000001010100000000000         * * *            
; $00,$00,$00 000000000000000000000000                          
; $00,$00,$00 000000000000000000000000                          
; $00,$00,$00 000000000000000000000000                          
; $00,$00,$00 000000000000000000000000                          
; $00,$00,$00 000000000000000000000000                          
.BYTE $00,$06,$1E,$A8                                           
.BYTE $00,$0B,$AA,$80,$2E,$AA,$A0,$2A                           
.BYTE $AA,$A0,$2A,$AA,$A0,$FE,$AA,$A8                           
.BYTE $5E,$AA,$A8,$5E,$AA,$A8,$5E,$AA                           
.BYTE $A8,$FE,$AA,$A8,$2A,$AA,$A0,$2A                           
.BYTE $AA,$A0,$2A,$AA,$A0,$0A,$AA,$80                           
.BYTE $00,$A8,$00,$15,$1E                                       

```
So in this instance the sprite is stored in 49 bytes rather than 64.

This is the routine used to decompress the sprite and charset data and store it to the locations in memory where it will be used when the program is running:

```asm
; Copy the charset and sprite data to banks $2000 and $3000. Sprites                                    
; are copied to $3000.                                                                                  
; - The sprite and charset data is read from the end instead of the front.                              
; - When a sequence such as $00,$05,$1E is encountered it is treated as a tag length                    
;   value (TLV) where $1E is the tag, $00 is the character to output and $05 is the                     
;   number of instances to output. So $00,$05,$1E translates to $00,$00,$00,$00,$00.                    
;                                                                                                       
b1425   DEY                                                                                             
        CPY #$FF                                                                                        
        BNE e035A                                                                                       
        DEC CharSetPtrHi                                                                                
e035A                                                                                                   
        LDA (CharSetPtrLo),Y                                                                            
        STA ZeroesToCopy                                                                                
        DEY                                                                                             
        CPY #$FF                                                                                        
        BNE b1437                                                                                       
        DEC CharSetPtrHi                                                                                
                                                                                                        
;CopyCharSetData                                                                                        
b1437   LDA (CharSetPtrLo),Y                                                                            
        ; The first byte at $13E4 is $01 so this falls through.                                         
        CMP #$1E                                                                                        
        BEQ FinishLoadingCharsetData                                                                    
                                                                                                        
        ; Copies the zeros specified by a TLV sequence.                                                 
b143D   STA f3430,X ; a036D - The high byte '34' in this address gets manipulated by this routine       
        DEX                                                                                             
        CPX #$FF                                                                                        
        BNE b144B                                                                                       
        DEC a036D                                                                                       
        DEC a038C                                                                                       
b144B   DEC ZeroesToCopy                                                                                
        BNE b143D                                                                                       
                                                                                                        
b144F   DEY                                                                                             
        CPY #$FF                                                                                        
        BNE b1456                                                                                       
        DEC CharSetPtrHi                                                                                
b1456   LDA (CharSetPtrLo),Y                                                                            
        CMP #$1E                                                                                        
        BEQ b1425                                                                                       
        ; Copy the data to the position in $2000 - $3000                                                
        STA f3430,X   ; a038C - The high byte '34' in this address gets manipulated by this routine     
        DEX                                                                                             
        CPX #$FF                                                                                        
        BNE b144F                                                                                       
        DEC a036D                                                                                       
        DEC a038C                                                                                       
        BNE b144F                                                                                       

```

### Self-Modifying Code
The program's initialization sequence modifies itself the runs from the start again. Maybe the purpose of this is to obfuscate the code?

It starts out by bootstrapping to address $0811, which is regular enough.
```asm
;--------------------------------------------------------           
; Start executing at position $0811 (2065)                          
;--------------------------------------------------------           
        ; 10 SYS 2065                                               
        .BYTE $0F,$08,$CF,$07,$9E,$32,$30,$36,$35,$20               
        .BYTE $41,$42,$43,$00,$00,$00                               
                                                                    
;--------------------------------------------------------           
; Execution starts here                                             
; e0811 (SYS 2065)                                                  
;--------------------------------------------------------           
        NOP                                                         
        NOP                                                         
        NOP                                                         
        NOP                                                         
        NOP                                                         
        LDA #$36                                                    
        STA a01                                                     
        JMP CopyCodeCharsetAndSprites 
```
From $0811 it branches to the routine `CopyCodeCharsetAndSprites`. As well as setting up the Character Set and Sprite data as described above, this routine also does the following:

```asm

; Copy 123 bytes of code from $1405 to $0333    
        LDX #$7B                                
b13FA   LDA f1405,X                             
        STA f0333,X                             
f1400   DEX                                     
        BNE b13FA                               
f1405   =*+$02                                  
        JMP CopyCharSetData                     

; This is the boot code executed by FinishLoadingCharsetData.        
; It's copied to $0801 below. The bytes disassemble to:              
; * = $0801                                                          
;         ; 10 SYS 2064                                              
;         .BYTE $0B,$08,$0A,$00,$9E,$32,$30,$36,$34,$00              
;         .BYTE $00,$00,$08,$02,$00                                  
;                                                                    
; ;--------------------------------------------------------          
; ; Execute                                                          
; ; e0810 (SYS 2064)                                                 
; ;--------------------------------------------------------          
;         LDA #$7F                                                   
;         STA $DC0D                                                  
;         LDA #$00                                                   
;         STA $D020                                                  
;         STA $D021                                                  
;         LDA #$18                                                   
;         STA $D018  ; Sets character set to 2000?                   
;         LDA                                                        
       .BYTE $0B,$08,$0A                                 ; $1401:    
       .BYTE $00,$9E,$32,$30,$36,$34,$00,$00             ; $1409:    
       .BYTE $00,$08,$02,$00,$A9,$7F,$8D,$0D             ; $1411:    
       .BYTE $DC,$A9,$00,$8D,$20,$D0,$8D,$21             ; $1419:    
       .BYTE $D0,$A9,$18,$8D                             ; $1421:    
                                                                     
                                                                    

; Copy the 31 bytes of code in $0333 (see aboved) to $0800 and execute it?                       
                                                                                                 
FinishLoadingCharsetData                                                                         
        LDX #$1F                                                                                 
b146E   LDA f0333,X                                                                              
        STA f0800,X                                                                              
        DEX                                                                                      
        BNE b146E                                                                                
        LDA #$1E                                                                                 
        LDA #$37                                                                                 
        STA a01                                                                                  
        CLI                                                                                      
        JMP eA8BC ; Value at this address is $00,$00 - so presumably execution returns to $0810? 
                                                                                                 
        BRK #$00                                                                                 
```
That is, it copies a chunk of data from $1400 to $0333, and from there to $0800. It then branches to an invalid address ($A8BC), which presumably has the effect of returning exeuction to $0801 - where the newly copied code at $0801 is waiting to execute again:

```asm
* = $0801                                                              
        ; 10 SYS 2064                                                  
        .BYTE $0B,$08,$0A,$00,$9E,$32,$30,$36,$34,$00                  
        .BYTE $00,$00,$08,$02,$00                                      
                                                                       
;--------------------------------------------------------              
; Execute                                                              
; e0810 (SYS 2064)                                                     
;--------------------------------------------------------              
        LDA #$7F                                                       
        STA $DC0D                                                      
        LDA #$00                                                       
        STA $D020                                                      
        STA $D021                                                      
        LDA #$18                                                       
        STA $D018  ; Sets character set to 2000?                       
        LDA #$FF                                                       
        STA $D015                                                      
        STA $D01B                                                      
        LDA #$00                                                       
        STA $D010                                                      
        STA $D017    ;Sprites Expand 2x Vertical (Y)                   
        STA $D01D    ;Sprites Expand 2x Horizontal (X)                 
        LDA #$3F                                                       
        STA $D01C    ;Sprites Multi-Color Mode Select                  
        LDA #$01                                                       
        STA $D02D    ;Sprite 6 Color                                   
        STA $D026    ;Sprite Multi-Color Register 1                    
        LDA #$02                                                       
        STA $D025    ;Sprite Multi-Color Register 0                    
        LDA #$0B                                                       
        STA $D02E    ;Sprite 7 Color                                   
        JSR ClearTextFromScreen                                        
        JMP Main_Loop                                                  

```
The code that lives there now initializes the sprite settings, clears any text on the screen and jumps to the main loop.

This shuffling of code makes disassembly harder later as it mungs relative addresses in the disassembly - meaning that it is harder to find the actual entry point for some routines.

For example in the CheckKeyboardInput routine, the entry point is at the `;CheckKeyboardInput` comment, not the `CheckKeyboardInput` label itself:

```asm
;------------------------------------------                         
; CheckKeyboardInput                                                
; Check if the user has pressed any key and update the display      
; settings accordingly.                                             
;------------------------------------------                         
                                                                    
;CheckKeyboardInput                                                 
        ASL                                                         
        CMP #$40 ; No Key pressed                                   
        BEQ b0A69                                                   
        LDA LastKeyPressed                                          
        STA LastRecordedKey                                         
        RTS                                                         
                                                                    
b0A69   LDA LastKeyPressed                                          
        STA LastRecordedKey                                         
        CMP #$0C ; Z pressed                                        
        BNE b0A78                                                   
        DEC Wave1Frequency                                          
        JMP UpdateDisplay                                           
                                                                    
b0A78   CMP #$17 ; X pressed                                        
CheckKeyboardInput   =*+$01    ; Not the real label, see above.     
        BNE b0A82                                                   
        INC Wave1Frequency                                          
        JMP UpdateDisplay                                           
                                                                    
```
