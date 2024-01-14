.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern CurrentMapText: dword, OriginMap: dword


.data

scene byte 0				; ��Ϸ�������ͣ�0~3
babyDirection dword 0		; ��ҷ���
mainWindowsId HWND ?		; windowid

mainWindowsDC HDC ?			; "Handle to a Device Context" 
mainBitmapDC HDC ?			; "Handle to a Device Context" 

; bmpͼƬ·����bitmap
initialImagePath byte "./asset/choose.bmp", 0h
initialBitmap HBITMAP ?
destinationImagePath byte "./asset/choose.bmp", 0h
destinationBitmap HBITMAP ?
boxImagePath byte "./asset/box.bmp", 0h
boxBitmap HBITMAP ?
babyUPImagePath byte "./asset/baby_up.bmp", 0h
babyUPBitmap HBITMAP ?
babyRIGHTImagePath byte   "./asset/baby_right.bmp",0h
babyRIGHTBitmap HBITMAP ?
babyDOWNImagePath byte  "./asset/baby_down.bmp", 0h
babyDOWNBitmap HBITMAP ?
babyLEFTImagePath byte  "./asset/baby_left.bmp", 0h
babyLEFTBitmap HBITMAP ?
wallImagePath byte "./asset/wall.bmp", 0h
wallBitmap HBITMAP ?
emptyImagePath byte "./asset/empty.bmp", 0h
emptyBitmap HBITMAP ?
targetImagePath byte "./asset/target.bmp", 0h
targetBitmap HBITMAP ?
boxTargetImagePath byte "./asset/box_target.bmp", 0h
boxTargetBitmap HBITMAP ?


.code

; ����������id
setMainWindowsId proc id: HWND
	mov eax, id
	mov mainWindowsId, eax
	ret
setMainWindowsId endp

; ��ʼ��Ϸ
startGame proc
	mov scene, SCENE_LEVEL
	ret
startGame endp

; ������Ϸ
endGame proc
	mov scene, SCENE_DESTINATION
	ret
endGame endp

; ѡ��ؿ�
chooseLevel proc
	mov scene, SCENE_INITIAL
	invoke updateMap
	ret
chooseLevel endp

; �趨��ɫ����
setPlayerDirection proc direction: dword
	mov eax, direction
	mov babyDirection, eax

	ret
setPlayerDirection endp

; ��ȡ��������
getGridType proc index: dword	
	mov edi, index
	mov eax, CurrentMapText[edi * 4]

	.if eax == GRID_BABY
		mov eax, GRID_BABY_UP
		add eax, babyDirection
	.elseif eax == GRID_BOX
		mov eax, OriginMap[edi * 4]
		.if eax == GRID_TARGET
			mov eax, GRID_BOX_TARGET
		.else
			mov eax, GRID_BOX
		.endif
	.endif

	ret
getGridType endp

; ���»��Ƶ�ͼ����
updateMap proc	
	local rect: RECT	;  ��������

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

; ���»����ض�դ��
updateGrid proc index: dword
	local rect: RECT

	mov eax, index
	mov ebx, 10
	div ebx
	mov ecx, eax

	mov eax, edx
	mov ebx, GRID_SIZE
	mul ebx
	add eax, MAP_X
	mov rect.left, eax

	add eax, GRID_SIZE
	mov rect.right, eax

	mov eax, ecx
	mov ebx, GRID_SIZE
	mul ebx
	add eax, MAP_Y
	mov rect.top, eax

	add eax, GRID_SIZE
	MOV rect.bottom, eax

	; ֪ͨ��������Ч��Ҫ����
	invoke InvalidateRect, mainWindowsId, addr rect, FALSE

	ret
updateGrid endp

; ���Ƶ�ͼ
drawMap proc dc: HDC
	local nextX: sword 
	local nextY: sword
	local colInd: dword 

	mov eax, dc
	mov mainWindowsDC, eax

	invoke loadSceneBitmap
	invoke beginDraw

	.if scene == SCENE_INITIAL	; ������
		invoke drawImage, initialBitmap, MAP_X, MAP_Y, MAP_SIZE, MAP_SIZE
	.elseif scene == SCENE_LEVEL ; ��Ϸ
		mov nextX, MAP_X
		mov nextY, MAP_Y
		mov colInd, 0
		xor ebx, ebx
		.while ebx < MAX_LEN
			invoke getGridType, ebx
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
				mov nextX, MAP_X
				add nextY, GRID_SIZE
				mov colInd, 0
			.endif

			inc ebx
		.endw
	.elseif scene == SCENE_DESTINATION
		invoke drawImage, destinationBitmap, MAP_X, MAP_Y, MAP_SIZE, MAP_SIZE
	.else
		invoke drawImage, initialBitmap, MAP_X, MAP_Y, MAP_SIZE, MAP_SIZE
	.endif
	
	invoke endDraw

	ret
drawMap endp

; ���ظ���������Ҫ��bitmap
loadSceneBitmap proc
	.if scene == SCENE_INITIAL
		invoke LoadImage, NULL, offset initialImagePath, IMAGE_BITMAP, MAP_SIZE, MAP_SIZE, LR_LOADFROMFILE
		mov initialBitmap, eax

	.elseif scene == SCENE_LEVEL
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
		invoke LoadImage, NULL, offset destinationImagePath, IMAGE_BITMAP, MAP_SIZE, MAP_SIZE, LR_LOADFROMFILE
		mov destinationBitmap, eax

	.endif

	ret
loadSceneBitmap endp

; �����豸�����ģ�׼�����ش���
beginDraw proc
	invoke CreateCompatibleDC, mainWindowsDC
	mov mainBitmapDC, eax
	ret
beginDraw endp

; ɾ������bitmap��ɾ��DC
endDraw proc
	.if scene == SCENE_INITIAL
		invoke DeleteObject, initialBitmap
	.elseif scene == SCENE_LEVEL
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
		invoke DeleteObject, destinationBitmap
	.endif

	invoke DeleteDC, mainBitmapDC

	ret
endDraw endp

; ����ͼ��
drawImage proc bitmap: HBITMAP, i32X: sword, i32Y: sword, u32Width: dword, u32Height: dword
	invoke SelectObject, mainBitmapDC, bitmap
	invoke BitBlt, mainWindowsDC, i32X, i32Y, u32Width, u32Height, mainBitmapDC, 0, 0, SRCCOPY
	ret
drawImage endp
end
