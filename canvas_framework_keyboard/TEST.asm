.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf : proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
include digits.inc
include letters.inc
include drawing.inc
include nava.inc
include plan.inc
include moon.inc
include stele.inc
include ufo.inc
include bullet.inc

window_title DB "The Wanderer",0
area_width EQU 400
area_height EQU 400
area DD 0
area_widthEnd EQU 400
area_heightEnd EQU 400
area_widthEnd2 EQU 400
area_heightEnd2 EQU 400

areaEnd DD 0
areaEnd2 DD 0
counter DD 0 ; numara evenimentele de tip timer

tras dd 0

DontShoot dd 0


symbol_width EQU 10
symbol_height EQU 20


navaX dd 175
navaY dd 300

nava2X dd 50
nava2Y dd 50

nava_height dd 40
nava_width  dd 40

enemy_height dd 27
enemy_width  dd 40

bullet_height dd 10
bullet_width dd 10

enemyX dd 200
enemyY dd 100


bulletX dd 190
bulletY dd 300



left dd 0 
right dd 0 


arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20



ufo struct 
	ufoX  dd 0
	ufoY dd 0
	health dd 0
	miscare dd 0
ufo ends

isDead dd 0

enemies	ufo {200 , 100 , 1, 0} , {175 , 50 , 3,0}

.code



make_auto_move2 macro  X , Y , Y_AXIS , bulletX , bulletY , misc , health

	
	LOCAL  DontShowSpace , FINAL_JOC , FINAL_WIN , n0 , n1 , n2 , n3 , nuAfisa , equale , makeChangesRight ,makeChangesLeft , makeChangesDown0 , makeChangesDown1 , dupa , dincolo , incauna , jump , there , nu
	
	cmp health , DWord ptr 0
	je DontShowSpace
	
	push eax 
	mov eax , Y_AXIS
	cmp Y , eax
	jge FINALJOC
	pop eax
	
	
	push edx
	
	mov edx , X
	
	add edx , 25
	
	cmp bulletX , edx
	
	jg n0
	
	sub edx , 50
	
	cmp bulletX , edx
	
	jl n1
	
	mov edx , Y
	
	add edx , 10
	
	cmp bulletY , edx
	
	jg n2
	
	sub edx , 20
	
	cmp bulletY , edx
	
	jl n3
	
	dec health
	cmp health , dword ptr 0
	je nuAfisa
	
	
	
	
	n0:
	n1:
	n2:
	n3:
	
	cmp misc , 1
	
	jne equale
	add y , 50
	jmp dincolo
	equale:
	cmp left , dword ptr 0
	je makeChangesRight
	cmp right , dword ptr 0
	je makeChangesLeft
	
	
	makeChangesRight :
	
	cmp X ,  dword ptr 355
	jge makeChangesDown0
	add x , 3
	
	
	jmp there
	makeChangesLeft: 
	cmp X ,  dword ptr 5
	jle makeChangesDown1
	sub x , 3
	jmp incauna
	makeChangesDown0:
	mov misc , 1
	mov right , dword ptr 0
	mov left , dword ptr 1
	jmp jump
	makeChangesDown1 :
	mov misc , 1
	mov right , dword ptr 1
	mov left , dword ptr 0
	
	jmp dupa
	
	
	dincolo:
	incauna:
	mov misc ,0
	jump :
	there:
	dupa:
	make_ufo_macro area, X , Y
	jmp Nu
	nuAfisa :

	inc isDead
	Nu :
	
	
	pop edx 
	DontShowSpace:
	
	

endm



moveShip macro
	
	
	mov eax ,  [ebp + arg2]
	cmp eax , 'A'					
	je stanga
	cmp eax, 'D'
	je dreapta
	cmp eax , 'W'
	je sus
	cmp eax , 'S'
	je jos
	
	jmp niciuna
	stanga:
	cmp navaX , dword ptr 0
	je ajuns_la_margine
	sub navaX , 5
	pop eax
	jmp salt
	dreapta :
	cmp navaX , dword ptr 360
	je ajuns_la_margine
	add navaX , 5
	pop eax
	jmp salt
	sus :
	sub navaY , 5
	pop eax
	jmp salt
	jos : 
	cmp navaY , dword ptr 355
	je ajuns_la_margine
	add navaY , 5
	pop eax
	jmp over 
	
	over: 
	ajuns_la_margine:
	salt:
	niciuna:
	make_ship_macro area , navaX , navaY
	



endm

	make_auto_bullet macro  X , Y , navaX , navaY , tras 
	local a , over 
	
	push eax
	mov eax , enemies[16].ufoY
	cmp Y , eax
	jle verificaX
	
	jmp nuVerifica
	
	verificaX:
	mov eax , enemies[16].ufoX
	
	add eax , 25
	cmp X , eax
	jg cmp1
	
	sub eax , 50
	cmp X , eax
	jl cmp2
	jmp NuSeTrage
	
	cmp1 :
	cmp2 : 
	nuVerifica: 
	
	cmp [ebp + arg2] , dword ptr ' ' 
	
	je ApasatSpace
	
	jmp NuSaApasat
	ApasatSpace : 
	mov tras , dword ptr 1
	NuSaApasat : 
	
	cmp tras , dword ptr 1
	
	je seTrage 
	
	jmp NuSeTrage 
	
	seTrage :
	
	
	
	cmp Y , dword ptr 10
	jle a
	sub y , 10
	
	make_bullet_macro area , X , Y
	
	jmp over
	a:
	NuSeTrage :
	
	push ebx
	
	mov ebx , navaY
	mov Y , ebx
	pop ebx
	mov tras , dword ptr 0
	
	push eax 
	mov eax,navaX
	add eax , 15 
	mov X , eax
	
	
	mov eax , navaY
	mov y , eax
	pop eax
	
	
	over : 
	pop eax
  
	
	endm
 
	
	

make_text5 proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, ufo_0
	
draw_image:
	mov ecx, enemy_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, enemy_height 
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, enemy_width ; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_text5 endp



make_ufo_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_text5
	add esp, 12
endm






make_text6 proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, nava_0
	
draw_image:
	mov ecx, nava_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, nava_height 
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, nava_width ; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_text6 endp

; simple macro to call the procedure easier

make_ship_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_text6
	add esp, 12
endm


make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	

draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_widthEnd
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	
	mov dword ptr [edi] , 00ff0000h
	jmp simbol_pixel_next 
	
simbol_pixel_alb:
	mov dword ptr [edi], 00000000h   			;    am schimbat pixeul ala cu culoarea backroundului # 3
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
	
	
	
	
	
	make_textE proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	

draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_widthEnd2
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	
	mov dword ptr [edi] , 0000ff00h
	jmp simbol_pixel_next 
	
simbol_pixel_alb:
	mov dword ptr [edi], 00000000h   			;    am schimbat pixeul ala cu culoarea backroundului # 3
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_textE endp

make_textE_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_textE
	add esp, 16
endm
	
	
	
	
	
	
	
	
	
	
	
	make_text7	proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, bullet_0
	
draw_image:
	mov ecx, bullet_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, bullet_height 
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, bullet_width ; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_text7 endp



make_bullet_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_text7
	add esp, 12
endm


	
	
	
	
	
	

draw proc


	push ebp 
	mov ebp , esp
	pusha
	
	
	
	mov eax , area_width
	mov ebx , area_height
	mul ebx
	

	push ecx 
	push esi
	push eax
	mov ecx, eax
	mov esi , area
	mov eax  ,0														; area are adresa catre pointer nu adresa in sine care pointeaza la prima celula
	loop_desen :													; desen un fundal diferit #2 
		mov dword ptr [esi + eax] ,    80
		mov dword ptr [esi + eax + 1] ,	0
		mov dword ptr [esi + eax + 2] , 0
		add eax , 4
	loop loop_desen
	pop eax
	pop esi
	pop ecx		
	



	moveShip
	
	
	
;	make_auto_move2 enemyX , enemyY   , navaY   , bulletX , bulletY , isShot
	
	make_auto_move2 enemies[0].ufoX , enemies[0].ufoY , navaY , bulletX , bulletY , enemies[0].miscare , enemies[0].health
	make_auto_move2 enemies[16].ufoX , enemies[16].ufoY , navaY , bulletX , bulletY , enemies[16].miscare , enemies[16].health
	
	
	
	make_auto_bullet bulletX , bulletY , navaX , navaY , tras
	
	
	cmp isDead, dword ptr 2
	je FINALWIN
	
	
	
	
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp


drawEnding proc


	push ebp 
	mov ebp , esp
	pusha
	
	
	
	mov eax , area_widthEnd
	mov ebx , area_heightEnd
	mul ebx
	
	
	push ecx 
	push esi
	push eax
	mov ecx, eax
	mov esi , areaEnd
	mov eax  , 0													; area are adresa catre pointer nu adresa in sine care pointeaza la prima celula
	loop_desen :													; desen un fundal diferit #2 
		mov dword ptr [esi + eax] ,     0
		mov dword ptr [esi + eax + 1] ,	0
		mov dword ptr [esi + eax + 2] , 0
		add eax , 4
	loop loop_desen
	pop eax
	pop esi
	pop ecx		
	
	make_text_macro 'T', areaEnd, 100, 100
	make_text_macro 'H', areaEnd, 110, 100
	make_text_macro 'E', areaEnd, 120, 100
	make_text_macro 'A', areaEnd, 110, 120
	make_text_macro 'L', areaEnd, 120, 120
	make_text_macro 'I', areaEnd, 130, 120
	make_text_macro 'E', areaEnd, 140, 120
	make_text_macro 'N', areaEnd, 150, 120
	make_text_macro 'S', areaEnd, 160, 120
	make_text_macro 'I', areaEnd, 130, 140
	make_text_macro 'N', areaEnd, 140, 140
	make_text_macro 'V', areaEnd, 150, 140
	make_text_macro 'A', areaEnd, 160, 140
	make_text_macro 'D', areaEnd, 170, 140
	make_text_macro 'E', areaEnd, 180, 140
	make_text_macro 'D', areaEnd, 190, 140
	make_text_macro 'T', areaEnd, 170, 160
	make_text_macro 'H', areaEnd, 180, 160
	make_text_macro 'E', areaEnd, 190, 160
	make_text_macro 'W', areaEnd, 180, 180
	make_text_macro 'O', areaEnd, 190, 180
	make_text_macro 'R', areaEnd, 200, 180
	make_text_macro 'L', areaEnd, 210, 180
	make_text_macro 'D', areaEnd, 220, 180
	
	
	
	make_text_macro 'Y', areaEnd, 150, 280
	make_text_macro 'O', areaEnd, 160, 280
	make_text_macro 'U', areaEnd, 170, 280
	make_text_macro 'L', areaEnd, 160, 300
	make_text_macro 'O', areaEnd, 170, 300
	make_text_macro 'S', areaEnd, 180, 300
	make_text_macro 'T', areaEnd, 190, 300
	
	
	popa
	mov esp, ebp
	pop ebp
	ret
drawEnding endp




drawEnding2 proc


	push ebp 
	mov ebp , esp
	pusha
	
	
	
	mov eax , area_widthEnd2
	mov ebx , area_heightEnd2
	mul ebx
	
	
	push ecx 
	push esi
	push eax
	mov ecx, eax
	mov esi , areaEnd2
	mov eax  ,0														; area are adresa catre pointer nu adresa in sine care pointeaza la prima celula
	loop_desen :													; desen un fundal diferit #2 
		mov dword ptr [esi + eax] ,     0
		mov dword ptr [esi + eax + 1] ,	0
		mov dword ptr [esi + eax + 2] , 0
		add eax , 4
	loop loop_desen
	pop eax
	pop esi
	pop ecx		
	
	make_textE_macro 'T', areaEnd2, 100, 100
	make_textE_macro 'H', areaEnd2, 110, 100
	make_textE_macro 'E', areaEnd2, 120, 100
	
	make_textE_macro 'A', areaEnd2, 110, 120
	make_textE_macro 'L', areaEnd2, 120, 120
	make_textE_macro 'I', areaEnd2, 130, 120
	make_textE_macro 'E', areaEnd2, 140, 120
	make_textE_macro 'N', areaEnd2, 150, 120
	make_textE_macro 'S', areaEnd2, 160, 120
	
	make_textE_macro 'H', areaEnd2, 130, 140
	make_textE_macro 'A', areaEnd2, 140, 140
	make_textE_macro 'V', areaEnd2, 150, 140
	make_textE_macro 'E', areaEnd2, 160, 140
	
	make_textE_macro 'B', areaEnd2, 170, 160
	make_textE_macro 'E', areaEnd2, 180, 160
	make_textE_macro 'E', areaEnd2, 190, 160
	make_textE_macro 'N', areaEnd2, 200, 160
	
	make_textE_macro 'S', areaEnd2, 180, 180
	make_textE_macro 'L', areaEnd2, 190, 180
	make_textE_macro 'A', areaEnd2, 200, 180
	make_textE_macro 'Y', areaEnd2, 210, 180
	make_textE_macro 'E', areaEnd2, 220, 180
	make_textE_macro 'D', areaEnd2, 230, 180
	
	make_textE_macro 'Y', areaEnd2, 210, 200
	make_textE_macro 'O', areaEnd2, 220, 200
	make_textE_macro 'U', areaEnd2, 230, 200
	
	make_textE_macro 'W', areaEnd2, 220, 220
	make_textE_macro 'O', areaEnd2, 230, 220
	make_textE_macro 'N', areaEnd2, 240, 220
	
	
	
	popa
	mov esp, ebp
	pop ebp
	ret
drawEnding2 endp









start:
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	

	
	jmp final
	FINALJOC:
	pop eax
	final :
	
	
	mov eax, area_widthEnd
	mov ebx, area_heightEnd
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov areaEnd, eax
	
	push offset drawEnding
	push areaEnd
	push area_heightEnd
	push area_widthEnd
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	jmp gameover
	
	
	
	FINALWIN :
	pop eax
	 
	mov eax, area_widthEnd2
	mov ebx, area_heightEnd2
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov areaEnd2, eax
	
	push offset drawEnding2
	push areaEnd2
	push area_heightEnd2
	push area_widthEnd2
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	
	gameover:
	
	call exit
	push 0
	
 end start  