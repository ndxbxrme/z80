	org 50000
last_k	equ 23560
wstr	equ 8252
paddr	equ 22816
	call 8859
	ld hl, udgs
	ld (23675), hl
	ld a, 2
	call 5633
	ld de, string
	ld bc, eostr-string
	call wstr
	ld de, btop
	ld bc, eobtop-btop
	call wstr
	ld b, 6
	ld c, 10
loop	ld a, 22
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
ploop	ld hl, paddr
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
pright	ld a, (ppos)
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
pleft	ld a, (ppos)
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
pdrop	ld hl, paddr
	ld bc, (ppos)
	add hl, bc
	ld b, 6
dloop	push bc
	push hl
	ld bc, 32
	add hl, bc
	ld a, (hl)
	cp 15
	jp nz, clrkey
	pop hl
	ld a, 15
	ld (hl), a
	add hl, bc
	ld a, (pcol + 1)
	ld (hl), a
	pop bc
	djnz dloop
	ld hl, p1col
	ld a, (hl)
	ld hl, pcol
	ld b, (hl)
	cp b
	jr nz, p1up
	jr p2up
	jp clrkey
p1up	ld hl, p1col
	ld a, "1"
	rst 16
	ld b, (hl)
	inc hl
	ld c, (hl)
	ld hl, pcol
	ld (hl), b
	inc hl
	ld (hl), c
	jp clrkey
p2up	ld hl, p2col
	ld a, "2"
	rst 16
	ld b, (hl)
	inc hl
	ld c, (hl)
	ld hl, pcol
	ld (hl), b
	inc hl
	ld (hl), c
	jp clrkey
clrkey	ld hl, last_k
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
	