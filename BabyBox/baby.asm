.386
.model flat, stdcall
option casemap: none

include baby.inc
include babybox.inc

.data

; λͼ�ļ���

initialImagePath byte "./pic/title.bmp", 0h; ��ʼ����ʾ��ͼƬ�������������ŶӺ���Ϸ��
; ��player������baby
boxImagePath byte "./pic/box.bmp", 0h ; ����
babyUPImagePath byte "./pic/player-up.bmp", 0h
babyRIGHTImagePath byte "./pic/player-right.bmp", 0h
babyDOWNImagePath byte "./pic/player-down.bmp", 0h
babyLEFTImagePath byte "./pic/player-left.bmp", 0h
wallImagePath byte "./pic/wall.bmp", 0h ; ǽ��
emptyImagePath byte "./pic/empty.bmp", 0h ; �յĵط�
targetImagePath byte "./pic/target.bmp", 0h ; Ŀ���
boxTargetImagePath byte "./pic/box-target.bmp", 0h  ;�ŵ�Ŀ�������

destinationImagePath byte "./pic/clear.bmp", 0h ; �յ�ͼƬ

; λͼ
initialBitmap HBITMAP ?

boxBitmap HBITMAP ?
babyUPBitmap HBITMAP ?
babyRIGHTBitmap HBITMAP ?
babyDOWNBitmap HBITMAP ?
babyLEFTBitmap HBITMAP ?
wallBitmap HBITMAP ?
emptyBitmap HBITMAP ?
targetBitmap HBITMAP ?
boxTargetBitmap HBITMAP ?

destinationBitmap HBITMAP ?

; ��Ϸ����
scene byte 0
; ��ҳ���
babyDirection dword 0

; ������id
mainWindowsId HWND ?
; DC
; I hate GDI
mainWindowsDC HDC ? ;"Handle to a Device Context" 
mainBitmapDC HDC ?

.code

; ����λͼ
loadSceneBitmap proto
; ��ʼ����
beginDraw proto
; ��������
endDraw proto
; ����λͼ
; bitmap: HBITMAP λͼid
; i32X: sword ����λ��x
; i32Y: sword ����λ��y
; u32Width: dword ���ƿ��
; u32Height: dword ���Ƹ߶�
drawImage proto bitmap: HBITMAP, i32X: sword, i32Y: sword, u32Width: dword, u32Height: dword

setMainWindowsId proc win: HWND
	; ����������id��ʡ�ô�����ȥ
	mov eax, win
	mov mainWindowsId, eax

	ret
setMainWindowsId endp

startGame proc
	mov scene, SCENE_LEVEL

	ret
startGame endp

chooseLevel proc
	mov scene, SCENE_CHOOSE_LEVEL
	invoke updateMap

	ret
chooseLevel endp

endGame proc
	mov scene, SCENE_DESTINATION

	ret
endGame endp

getGridType proc u32Index: dword
	; ��ȡ��������
	local oldebx: dword ; I hate Assembler

	mov oldebx, ebx
	mov ebx, u32Index

	mov eax, CurrentMapText[ebx * 4]

	.if eax == GRID_BABY
		; ���
		mov eax, GRID_BABY_UP
		add eax, babyDirection
	.elseif eax == GRID_BOX
		; ����
		mov eax, OriginMapText[ebx * 4]
		.if eax == GRID_TARGET
			; ��Ŀ���
			mov eax, GRID_BOX_TARGET
		.else
			; ����Ŀ���
			mov eax, GRID_BOX
		.endif
	.endif

	mov ebx, oldebx

	ret
getGridType endp

setPlayerDirection proc u32Face: dword
	mov eax, u32Face
	mov babyDirection, eax

	ret
setPlayerDirection endp

updateMap proc
	; ��Ч����ͼ����
	local rect: RECT

	; [rect.left, rect.top, rect.right, rect.bottom] = [MAP_X, MAP_Y, MAP_X + MAP_SIZE, MAP_Y + MAP_SIZE]
	mov rect.left, MAP_X
	mov rect.top, MAP_Y

	mov eax, MAP_SIZE
	add eax, MAP_X
	mov rect.right, eax

	mov eax, MAP_SIZE
	add eax, MAP_Y
	MOV rect.bottom, eax

	invoke InvalidateRect, mainWindowsId, addr rect, TRUE

	ret
updateMap endp

updateGrid proc u32GridInd: dword
	; ��Ч������
	local rect: RECT
	local p: dword
	
	; p = u32GridInd / 10
	; edx = u32GridInd % 10
	mov eax, u32GridInd
	mov ebx, 10
	div ebx
	mov p, eax

	; rect.left = MAP_X + edx * GRID_SIZE
	mov eax, edx
	mov ebx, GRID_SIZE
	mul ebx
	add eax, MAP_X
	mov rect.left, eax
	; rect.right = rect.left + GRID_SIZE
	add eax, GRID_SIZE
	mov rect.right, eax

	; rect.top = MAP_Y + p * GRID_SIZE
	mov eax, p
	mov ebx, GRID_SIZE
	mul ebx
	add eax, MAP_Y
	mov rect.top, eax
	; rect.bottom = rect.top + GRID_SIZE
	add eax, GRID_SIZE
	MOV rect.bottom, eax

	invoke InvalidateRect, mainWindowsId, addr rect, FALSE

	ret
updateGrid endp

drawMap proc devc: HDC
	; ���Ƶ�ͼ
	local nextX: sword ; ѭ������һ��x
	local nextY: sword ; ѭ������һ��y
	local colInd: dword ; ѭ�����к�
	
	; ����������DC
	mov eax, devc
	mov mainWindowsDC, eax
	invoke loadSceneBitmap
	invoke beginDraw

	.if scene == SCENE_INITIAL
		; �����泡��
		; ����������

		invoke drawImage, initialBitmap, MAP_X, MAP_Y, MAP_SIZE, MAP_SIZE
	.elseif scene == SCENE_LEVEL
		; �ؿ�����
		; �������и��ӣ����Ż���

		; ѭ�����Ʒ���
		mov nextX, MAP_X
		mov nextY, MAP_Y
		mov colInd, 0
		xor ebx, ebx
		.while ebx < REC_LEN
			invoke getGridType, ebx
			; �û�ɶ��ɶ
			.if eax == GRID_WALL
				invoke drawImage, wallBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_EMPTY
				invoke drawImage, emptyBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BABY_UP
				invoke drawImage, babyUPBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BABY_RIGHT
				invoke drawImage, babyRIGHTBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BABY_DOWN
				invoke drawImage, babyDOWNBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BABY_LEFT
				invoke drawImage, babyLEFTBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BOX
				invoke drawImage, boxBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_TARGET
				invoke drawImage, targetBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.elseif eax == GRID_BOX_TARGET
				invoke drawImage, boxTargetBitmap, nextX, nextY, GRID_SIZE, GRID_SIZE
			.endif

			add nextX, GRID_SIZE
			inc colInd
			.if colInd == 10
				; �кŵ�10�ˣ���ʼ��һ��
				mov nextX, MAP_X
				add nextY, GRID_SIZE
				mov colInd, 0
			.endif

			inc ebx
		.endw
	.elseif scene == SCENE_DESTINATION
		; ͨ�س���
		; ����ͨ��ͼ

		invoke drawImage, destinationBitmap, MAP_X, MAP_Y, MAP_SIZE, MAP_SIZE
	.endif
	
	invoke endDraw

	ret
drawMap endp

loadSceneBitmap proc
	; ����λͼ

	.if scene == SCENE_INITIAL
		; �����泡��
		; ����������λͼ

		invoke LoadImage, NULL, offset initialImagePath, IMAGE_BITMAP, MAP_SIZE, MAP_SIZE, LR_LOADFROMFILE
		mov initialBitmap, eax
	.elseif scene == SCENE_LEVEL
		; �ؿ�����
		; ���ظ���λͼ

		invoke LoadImage, NULL, offset boxImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov boxBitmap, eax
		invoke LoadImage, NULL, offset babyUPImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov babyUPBitmap, eax
		invoke LoadImage, NULL, offset babyRIGHTImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov babyRIGHTBitmap, eax
		invoke LoadImage, NULL, offset babyDOWNImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov babyDOWNBitmap, eax
		invoke LoadImage, NULL, offset babyLEFTImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov babyLEFTBitmap, eax
		invoke LoadImage, NULL, offset wallImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov wallBitmap, eax
		invoke LoadImage, NULL, offset emptyImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov emptyBitmap, eax
		invoke LoadImage, NULL, offset targetImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov targetBitmap, eax
		invoke LoadImage, NULL, offset boxTargetImagePath, IMAGE_BITMAP, GRID_SIZE, GRID_SIZE, LR_LOADFROMFILE
		mov boxTargetBitmap, eax
	.elseif scene == SCENE_DESTINATION
		; ͨ�س���
		
		invoke LoadImage, NULL, offset destinationImagePath, IMAGE_BITMAP, MAP_SIZE, MAP_SIZE, LR_LOADFROMFILE
		mov destinationBitmap, eax
	.endif

	ret
loadSceneBitmap endp

beginDraw proc
	; ����DC
	invoke CreateCompatibleDC, mainWindowsDC
	mov mainBitmapDC, eax

	ret
beginDraw endp

drawImage proc bitmap: HBITMAP, i32X: sword, i32Y: sword, u32Width: dword, u32Height: dword
	; ���λͼ����
	invoke SelectObject, mainBitmapDC, bitmap
	invoke BitBlt, mainWindowsDC, i32X, i32Y, u32Width, u32Height, mainBitmapDC, 0, 0, SRCCOPY
	ret
drawImage endp

endDraw proc
	; ɾ��λͼ

	.if scene == SCENE_INITIAL
		; �����泡��
		; ɾ��������λͼ

		invoke DeleteObject, initialBitmap
	.elseif scene == SCENE_LEVEL
		; �ؿ�����
		; ɾ������λͼ

		invoke DeleteObject, boxBitmap
		invoke DeleteObject, babyUPBitmap
		invoke DeleteObject, babyRIGHTBitmap
		invoke DeleteObject, babyDOWNBitmap
		invoke DeleteObject, babyLEFTBitmap
		invoke DeleteObject, wallBitmap
		invoke DeleteObject, emptyBitmap
		invoke DeleteObject, targetBitmap
		invoke DeleteObject, boxTargetBitmap
	.elseif scene == SCENE_DESTINATION
		; ͨ�س���
		; ɾ��ͨ��ͼλͼ

		invoke DeleteObject, destinationBitmap
	.endif

	; ɾ��DC
	invoke DeleteDC, mainBitmapDC

	ret
endDraw endp
end
