	org 50000
last_k	equ 23560
wstr	equ 8252
paddr	equ 22816
	call 8859
	ld hl, udgs
	ld (23675), hl
	;fancy font
	ld hl,15616		; ROM font.
	ld de,60000		; address of our font.
	ld bc,768		; 96 chars * 8 rows to alter.
font1	ld a,(hl)		; get bitmap.
	rlca			; rotate it left.
	or (hl)			; combine 2 images.
	ld (de),a		; write to new font.
	inc hl			; next byte of old.
	inc de			; next byte of new.
	dec bc			; decrement counter.
	ld a,b			; high byte.
	or c			; combine with low byte.
	jr nz,font1		; repeat until bc=zero.
	ld hl,60000-256		; font minus 32*8.
	ld (23606),hl		; point to new font.
	ld a, 2			; move to upper left
	call 5633
	ld de, string		; write Connect 4
	ld bc, eostr-string
	call wstr
	ld de, btop		; top of board
	ld bc, eobtop-btop
	call wstr
	ld b, 6
	ld c, 10
loop	ld a, 22		; draw row of board
	rst 16
	ld a, c
	push bc
	rst 16
	ld de, board
	ld bc, eoboard-board
	call wstr
	pop bc
	inc c
	djnz loop
ploop	ld hl, paddr		; main loop draws counter and checks for keypresses
	ld bc, (ppos)
	add hl, bc
	ld a, (pcol)
	ld (hl), a
	ld hl, last_k
	ld a, (hl)
	cp 112
	jr z, pright
	cp 111
	jr z, pleft
	cp 110
	jp z, pdrop
	jr ploop
pright	ld a, (ppos)		; move player cursor to the right
	cp 18
	jr z, ploop
	ld hl, paddr
	ld bc, (ppos)
	add hl, bc
	ld (hl), 63
	ld a, (ppos)
	inc a
	ld (ppos), a
	jp clrkey
pleft	ld a, (ppos)		; move player cursor to the left
	cp 12
	jr z, ploop
	ld hl, paddr
	ld bc, (ppos)
	add hl, bc
	ld (hl), 63
	ld a, (ppos)
	dec a
	ld (ppos), a
	jp clrkey
pdrop	ld hl, paddr		; drop counter
	ld bc, (ppos)
	add hl, bc
	ld b, 6
dloop	push bc			; loop to move counter down
	push hl
	ld bc, 32
	add hl, bc
	ld a, (hl)
	cp 15
	jr nz, switch
	pop hl
	ld a, 15
	ld (hl), a
	add hl, bc
	ld a, (pcol + 1)
	ld (hl), a
	pop bc
	djnz dloop
switch	ld hl, p1col		; switch from p1 to p2 and back
	ld a, (hl)
	ld hl, pcol
	ld b, (hl)
	cp b
	jr nz, p1up
	jr p2up
	jr clrkey
p1up	ld hl, p1col		; set player 1 active
	ld b, (hl)
	inc hl
	ld c, (hl)
	ld hl, pcol
	ld (hl), b
	inc hl
	ld (hl), c
	jr clrkey
p2up	ld hl, p2col		; set player 2 active
	ld b, (hl)
	inc hl
	ld c, (hl)
	ld hl, pcol
	ld (hl), b
	inc hl
	ld (hl), c
	jr clrkey
clrkey	ld hl, last_k		; clears last keypress and returns to ploop
	ld (hl), 0
	jp ploop
	ret
string	defb 22, 7, 11, 16, 2, "C", 16, 1, "O", 16, 3, "N", 16, 4, "N", 16, 5, "E", 16, 0, "C", 16, 1, "T", 16, 2, " 4"
eostr	equ $
btop	defb 22, 9, 12
	defb 16, 7, 17, 7
	defb 144, 144, 144, 144, 144, 144, 144
eobtop	equ $
board	defb 12, 17, 1, 16, 7, 144, 144, 144, 144, 144, 144, 144
eoboard	equ $
ppos	defb 15, 0
pcol	defb 58, 10
p1col	defb 58, 10
p2col	defb 62, 14
udgs	defb 0, 24, 60, 126, 126, 60, 24, 0