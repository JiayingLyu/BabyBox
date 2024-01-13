.386
.model flat, stdcall
option casemap : none

include baby.inc
include babybox.inc

.data

levelImagePath1 byte "./pic/level-1.bmp", 0h
levelImagePath2 byte "./pic/level-2.bmp", 0h
levelImagePath3 byte "./pic/level-3.bmp", 0h
levelImagePath4 byte "./pic/level-4.bmp", 0h
levelImagePath5 byte "./pic/level-5.bmp", 0h
levelImagePath6 byte "./pic/level-6.bmp", 0h
levelImagePath7 byte "./pic/level-7.bmp", 0h
levelImagePath8 byte "./pic/level-8.bmp", 0h
levelImagePath9 byte "./pic/level-9.bmp", 0h
levelImagePath10 byte "./pic/level-10.bmp", 0h

handleMain		dd ?					; ��������
handleGuide			dd ?					; �������־��
handleLevel			dd ?					; �ؿ����
handleLevelText      dd ?					; �ؿ��ı����
handleStep			dd ?					; �������
handleStepText		dd ?					; �����ı����
handleMenu			dd ?					; �˵����

handleIcon			dd ?					; ͼ����
handleAcce			dd ?					; �ȼ����
handleStage			dd ?					; �����ⲿ���
handleDialogBrush    dd ?					; �Ի��򱳾���ˢ
handleStageBrush     dd ?					; �����ⲿ������ˢ

currentLevel	dd		0				;��¼��ǰ�ؿ�
cLevel			dd		5 dup(0)
currentStep		dd		0
cStep			dd		5 dup(0)
CurrPosition	dd		0				; ��¼�˵�λ��
OriginMapText	dd		MAX_LEN dup(0)	; ԭʼ��ͼ����
CurrentMapText  dd      MAX_LEN dup(0)	; ��ǰ��ͼ����

CurrBestLevel	dd		10				; ��ǰ��óɼ�������ѡ��

ProgramName		db		"Game", 0		; ��������
GameName		db		"sokoban", 0	; ��������
Author			db		"Ge, Gong, Wang, Xu", 0	; ����
cGuide          db		"Sokoban!", 0	; ������Ϣ
isWin			db		0				; �ж��Ƿ�ɹ�

iprintf			db		"%d", 0ah, 0

cLevel1			db		"1", 0
cLevel2			db		"2", 0
cLevel3			db		"3", 0
cLevel4			db		"4", 0
cLevel5			db		"5", 0
cLevel6			db		"6", 0
cLevel7			db		"7", 0
cLevel8			db		"8", 0
cLevel9			db		"9", 0
cLevel10		db		"10",0

strZero byte "0", 0h

handleButLEVEL1		dd	?	;ѡ�ذ�ť���
handleButLEVEL2		dd	?
handleButLEVEL3		dd	?
handleButLEVEL4		dd	?
handleButLEVEL5		dd	?
handleButLEVEL6		dd	?
handleButLEVEL7		dd	?
handleButLEVEL8		dd	?
handleButLEVEL9		dd	?
handleButLEVEL10	dd	?

handleButLEVEL			dd	10	dup(0)
butLEVELBitmaps HBITMAP 10 dup(0)
.code

WinMain proc hInst : dword, hPrevInst : dword, cmdLine : dword, cmdShow : dword
	; �ֲ���������
	local window : WNDCLASSEX	; ������
	local msg : MSG				; ��Ϣ
	local hWnd : HWND			; �Ի�����

	invoke RtlZeroMemory, addr window, sizeof WNDCLASSEX

	mov window.cbSize, sizeof WNDCLASSEX		; ������Ĵ�С
	mov window.style, CS_HREDRAW or CS_VREDRAW	; ���ڷ��
	mov window.lpfnWndProc, offset Calculate	; ������Ϣ��������ַ
	mov window.cbClsExtra, 0					; �ڴ�����ṹ���ĸ����ֽ����������ڴ�
	mov window.cbWndExtra, DLGWINDOWEXTRA		; �ڴ���ʵ����ĸ����ֽ���

	push hInst
	pop window.hInstance; ��������������

	mov window.hbrBackground, COLOR_WINDOW; ������ˢ���
	mov window.lpszClassName, offset ProgramName; ������������

	; ���ع����
	invoke LoadCursor, NULL, IDC_ARROW
	mov window.hCursor, eax

	mov window.hIconSm, 0; ����Сͼ����

	invoke RegisterClassEx, addr window; ע�ᴰ����
	; ���ضԻ��򴰿�
	invoke CreateDialogParam, hInst, IDD_DIALOG1, 0, offset Calculate, 0
	mov hWnd, eax
	
	; ����������id
	invoke setMainWindowsId, eax

	invoke ShowWindow, hWnd, cmdShow; ��ʾ����
	invoke UpdateWindow, hWnd; ���´���

	; ��Ϣѭ��
	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0; ��ȡ��Ϣ
		.break .if eax == 0
		invoke TranslateAccelerator, hWnd, handleAcce, addr msg; ת����ݼ���Ϣ
		.if eax == 0
			invoke TranslateMessage, addr msg; ת��������Ϣ
			invoke DispatchMessage, addr msg; �ַ���Ϣ
		.endif
	.endw

	mov eax, msg.wParam
	ret
WinMain endp


; �ж���Ӯ
JudgeWin proc
	; ��ͼ�в���������5��֤������ȫ����λ
	xor eax, eax
	xor ebx, ebx; ebx��¼ͼ�����Ӵ�ŵ�����
	mov eax, 0
	.while eax < MAX_LEN
		.if OriginMapText[eax * 4] == 5 
			;���Origin��5��λ�� Current����4������
			.if CurrentMapText[eax * 4] == 4
			jmp L1
			.else ;������4,˵��û�ɹ�
				jmp NotWin
			.endif 
		.endif
L1:		inc eax
	.endw
	mov isWin, 1 ;�þֻ�ʤ
	mov ebx, CurrBestLevel
	.if currentLevel == ebx
		inc CurrBestLevel
	.endif
	inc currentLevel ;�ؿ���+1
	
	ret
NotWin:		
	mov isWin, 0 
	ret
JudgeWin endp


CreateLevelMap proc
	; ������ǰ�ؿ���ͼ
	
	.if currentLevel == 0
		invoke CreateMap1
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel1
	.elseif currentLevel == 1
		invoke CreateMap2
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel2
	.elseif currentLevel == 2
		invoke CreateMap3
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel3
	.elseif currentLevel == 3
		invoke CreateMap4
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel4
	.elseif currentLevel == 4
		invoke CreateMap5
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel5
	.elseif currentLevel == 5
		invoke CreateMap6
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel6
	.elseif currentLevel == 6
		invoke CreateMap7
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel7
	.elseif currentLevel == 7
		invoke CreateMap8
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel8
	.elseif currentLevel == 8
		invoke CreateMap9
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel9
	.elseif currentLevel == 9
		invoke CreateMap10
		invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset cLevel10
	.else
		; ͨ��
		invoke endGame
		jmp UPDATE_MAP
	.endif

	invoke startGame
UPDATE_MAP:
	; �ָ�����Ϊ0���ָ���ʤ��־
	and currentStep, 0
	and isWin, 0
	
	invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset strZero
	invoke updateMap

	ret
CreateLevelMap endp

Calculate proc hWnd : dword, uMsg : UINT, wParam : WPARAM, lParam : LPARAM
	local hdc : HDC
	local ps : PAINTSTRUCT

	.if uMsg == WM_INITDIALOG
		; ��ȡ�˵��ľ������ʾ�˵�
		; invoke LoadMenu, handleMain, IDR_MENU1
		; mov handleMenu, eax
		; invoke SetMenu, hWnd, handleMenu

		; ��ȡ��ݼ��ľ������ʾ�˵�
		invoke LoadAccelerators, handleMain, IDR_ACCELERATOR2
		mov handleAcce, eax

		; ��ʼ������;���
		invoke InitRec, hWnd
		invoke InitBrush


	.elseif uMsg == WM_PAINT
		; ���ƶԻ��򱳾�
		invoke BeginPaint, hWnd, addr ps
		mov hdc, eax
		invoke FillRect, hdc, addr ps.rcPaint, handleDialogBrush

		; ���Ƶ�ͼ
		invoke drawMap, hdc

		invoke EndPaint, hWnd, addr ps

	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		movzx eax, ax; �������
		; ��ʼ����Ϸ����ʱ��Ҫ���ص�ǰ�ؿ���Ӧ�ĵ�ͼ
		.if eax == IDC_NEW || eax == ID_NEW
			; ���ذ�ť
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			; ������ǰ�ؿ���ͼ
			invoke CreateLevelMap
		;���½���ѡ��ؿ�����
		.elseif eax == IDC_REMAKE
			mov currentLevel, 0
			mov currentStep, 0
			mov isWin, 0
			; invoke resetGame
			; ����ť
			mov ebx, 0
			.while ebx <= CurrBestLevel
				invoke SendMessage, handleButLEVEL[ebx * 4], BM_SETIMAGE, IMAGE_BITMAP, butLEVELBitmaps[ebx * 4]
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_SHOWNORMAL
				inc ebx
			.endw

			invoke chooseLevel

		; �Ϸ����
		.elseif eax == IDC_UP
			.if !isWin
				invoke MoveUp
				inc currentStep
				invoke dwtoa, currentStep, offset cStep
				invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset cStep
				invoke JudgeWin
			.endif
		; �·����
		.elseif eax == IDC_DOWN
			.if !isWin
				invoke MoveDown
				inc currentStep
				invoke dwtoa, currentStep, offset cStep
				invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset cStep
				invoke JudgeWin
			.endif
		; �����
		.elseif eax == IDC_LEFT
			.if !isWin
				invoke MoveLeft
				inc currentStep
				invoke dwtoa, currentStep, offset cStep
				invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset cStep
				invoke JudgeWin
			.endif
		; �ҷ����
		.elseif eax == IDC_RIGHT
			.if !isWin
				invoke MoveRight
				inc currentStep
				invoke dwtoa, currentStep, offset cStep
				invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset cStep
				invoke JudgeWin
			.endif
		.elseif eax == IDC_BLEVEL1
			; �ȰѰ�ť����������ת
			mov currentLevel, 0 ;���õ�ǰ�ؿ�������
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL2
			mov currentLevel, 1
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL3
			mov currentLevel, 2
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL4
			mov currentLevel, 3
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL5
			mov currentLevel, 4
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL6
			mov currentLevel, 5
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL7
			mov currentLevel, 6
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL8
			mov currentLevel, 7
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL9
			mov currentLevel, 8
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL10
			mov currentLevel, 9
			mov ebx, 0
			.while ebx <= CurrBestLevel
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap
		.endif

		; ��ʤ����
		.if isWin == 1
			invoke CreateLevelMap
		.endif

	.elseif uMsg == WM_ERASEBKGND
		ret
	.elseif uMsg == WM_CLOSE
		invoke DestroyWindow, hWnd
	.elseif uMsg == WM_DESTROY
		invoke PostQuitMessage, 0
	.else
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	ret

	.endif

	xor eax, eax

	ret
Calculate endp

InitRec proc hWnd : dword
	; ����GetDlgItem������þ��
	; �������屳���ľ����
	invoke GetDlgItem, hWnd, IDC_STEP
	mov handleStep, eax

	invoke GetDlgItem, hWnd, IDC_STEPTEXT
	mov handleStepText, eax

	invoke GetDlgItem, hWnd, IDC_LEVEL
	mov handleLevel, eax

	invoke GetDlgItem, hWnd, IDC_LEVELTEXT
	mov handleLevelText, eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL1
	mov handleButLEVEL1, eax
	mov handleButLEVEL[0], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL2
	mov handleButLEVEL2, eax
	mov handleButLEVEL[4], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL3
	mov handleButLEVEL3, eax
	mov handleButLEVEL[8], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL4
	mov handleButLEVEL4, eax
	mov handleButLEVEL[12], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL5
	mov handleButLEVEL5, eax
	mov handleButLEVEL[16], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL6
	mov handleButLEVEL6, eax
	mov handleButLEVEL[20], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL7
	mov handleButLEVEL7, eax
	mov handleButLEVEL[24], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL8
	mov handleButLEVEL8, eax
	mov handleButLEVEL[28], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL9
	mov handleButLEVEL9, eax
	mov handleButLEVEL[32], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL10
	mov handleButLEVEL10, eax
	mov handleButLEVEL[36], eax

	ret
	InitRec endp

InitBrush proc
	; ������ͬ����Ļ�ˢ��ɫ
	invoke CreateSolidBrush, DialogBack
	mov handleDialogBrush, eax

	; ����ѡ�ذ�ť��Ӧ��λͼ�ļ�
	invoke LoadImage, NULL, offset levelImagePath1, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[0], eax
	invoke LoadImage, NULL, offset levelImagePath2, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[4], eax
	invoke LoadImage, NULL, offset levelImagePath3, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[8], eax
	invoke LoadImage, NULL, offset levelImagePath4, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[12], eax
	invoke LoadImage, NULL, offset levelImagePath5, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[16], eax
	invoke LoadImage, NULL, offset levelImagePath6, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[20], eax
	invoke LoadImage, NULL, offset levelImagePath7, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[24], eax
	invoke LoadImage, NULL, offset levelImagePath8, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[28], eax
	invoke LoadImage, NULL, offset levelImagePath9, IMAGE_BITMAP, 46, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[32], eax
	invoke LoadImage, NULL, offset levelImagePath10, IMAGE_BITMAP, 92, 58, LR_LOADFROMFILE
	mov butLEVELBitmaps[36], eax

	ret
InitBrush endp

MoveUp proc
	; �ҵ���ǰ�˵�λ��
	xor esi, esi
	mov esi, CurrPosition; ����CurrPosition��¼��ǰ�˵�λ��, esi��¼��ǰ��λ��
	mov edi, esi
	sub edi, 10; edi��¼�˵��Ϸ�λ��

	; ���ý�ɫ������
	invoke setPlayerDirection, DIRECTION_UP

	; �ж��Ϸ���������
	; ����ǿյػ������, ���ƶ�
	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov  CurrPosition, edi; �ı��˵ĵ�ǰλ��
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY; �ı��Ϸ���������
		mov eax, OriginMapText[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; ˢ�¸���
		invoke updateGrid, edi
		invoke updateGrid, esi

	; ���������
	.elseif CurrentMapText[edi * 4] == GRID_BOX
		; �ж������Ǳ���ʲô
		xor ecx, ecx
		mov ecx, edi
		sub ecx, 10; ecx���˵����Ϸ�λ��

		; �����Χǽ������
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
			; ˢ�¸���
			invoke updateGrid, esi
		.else
			; ֻ�����ǿյػ��ŵ㣬�����ƶ�
			mov CurrPosition, edi; �ı��˵ĵ�ǰλ��
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMapText[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; ˢ�¸���
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi

		.endif

	.else
		; ��ǽ
		invoke updateGrid, esi
	.endif
	ret
MoveUp endp

MoveDown proc
	; �ҵ���ǰ�˵�λ��
	xor esi, esi
	mov esi, CurrPosition; ����CurrPosition��¼��ǰ�˵�λ��, esi��¼��ǰ��λ��
	mov edi, esi
	add edi, 10; edi��¼�˵��·�λ��

	; ���ý�ɫ������
	invoke setPlayerDirection, DIRECTION_DOWN

	; �ж��·���������
	; ����ǿյػ������, ���ƶ�
	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi; �ı��˵ĵ�ǰλ��
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY; �ı��·���������
		mov eax, OriginMapText[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; ˢ�¸���
		invoke updateGrid, edi
		invoke updateGrid, esi

	; ���������
	.elseif CurrentMapText[edi * 4] == GRID_BOX
		; �ж������Ǳ���ʲô
		xor ecx, ecx
		mov ecx, edi
		add ecx, 10; ecx���˵����·�λ��

		; �����Χǽ������
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
		; ɾ����continue
			; ˢ�¸���
			invoke updateGrid, esi
		.else
			; ֻ�����ǿյػ��ŵ㣬�����ƶ�
			mov CurrPosition, edi; �ı��˵ĵ�ǰλ��
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMapText[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; ˢ�¸���
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		; ��ǽ
		invoke updateGrid, esi
	.endif
	ret
MoveDown endp

MoveLeft proc
	; �ҵ���ǰ�˵�λ��
	xor esi, esi
	mov esi, CurrPosition; ����CurrPosition��¼��ǰ�˵�λ��, esi��¼��ǰ��λ��
	mov edi, esi
	sub edi, 1; edi��¼�˵���λ��

	; ���ý�ɫ������
	invoke setPlayerDirection, DIRECTION_LEFT

	; �ж��󷽸�������
	; ����ǿյػ������, ���ƶ�
	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi; �ı��˵ĵ�ǰλ��
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY; �ı��󷽷�������
		mov eax, OriginMapText[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; ˢ�¸���
		invoke updateGrid, edi
		invoke updateGrid, esi
	; ���������
	.elseif CurrentMapText[edi * 4] == GRID_BOX
		; �ж������Ǳ���ʲô
		xor ecx, ecx
		mov ecx, edi
		sub ecx, 1; ecx���˵�����λ��

		; �����Χǽ������
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
			; .continue
			; ˢ�¸���
			invoke updateGrid, esi
		.else
			; ֻ�����ǿյػ��ŵ㣬�����ƶ�
			mov dword ptr CurrPosition, edi; �ı��˵ĵ�ǰλ��
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMapText[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; ˢ�¸���
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		; ��ǽ
		invoke updateGrid, esi
	.endif
	ret
MoveLeft endp

MoveRight proc
	; �ҵ���ǰ�˵�λ��
	xor esi, esi
	mov esi, CurrPosition; ����CurrPosition��¼��ǰ�˵�λ��, esi��¼��ǰ��λ��
	mov edi, esi
	add edi, 1; edi��¼�˵��ҷ�λ��

	; ���ý�ɫ������
	invoke setPlayerDirection, DIRECTION_RIGHT

	; �ж��󷽸�������
	; ����ǿյػ������, ���ƶ�
	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi; �ı��˵ĵ�ǰλ��
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY; �ı��ҷ���������
		mov eax, OriginMapText[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; ˢ�¸���
		invoke updateGrid, edi
		invoke updateGrid, esi
	; ���������
	.elseif CurrentMapText[edi * 4] == GRID_BOX
		; �ж������Ǳ���ʲô
		xor ecx, ecx
		mov ecx, edi
		add ecx, 1; ecx���˵����ҷ�λ��

		; �����Χǽ������
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
			; .continue
			; ˢ�¸���
			invoke updateGrid, esi
		.else
			; ֻ�����ǿյػ��ŵ㣬�����ƶ�
			mov dword ptr CurrPosition, edi; �ı��˵ĵ�ǰλ��
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMapText[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; ˢ�¸���
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		; ��ǽ
		invoke updateGrid, esi
	; .continue
	.endif
	ret
MoveRight endp

	; ��һ�ص�ͼ��ʼ��
CreateMap1 proc

	xor ebx, ebx
	.while ebx < REC_LEN
	.if (ebx < 13 || (ebx > 15 && ebx < 23) || (ebx > 25 && ebx < 33) || ebx == 39 || ebx == 40 || ebx == 49 || ebx == 50 || ebx == 59 || ebx == 60 || (ebx > 66 && ebx < 74) || (ebx > 76 && ebx < 84) || ebx > 86)
	mov dword ptr CurrentMapText[ebx * 4], 0
	inc ebx
	.elseif((ebx > 12 && ebx < 16) || ebx == 23 || ebx == 25 || ebx == 33 || (ebx > 34 && ebx < 39) || (ebx > 40 && ebx < 44) || ebx == 48 || ebx == 51 || (ebx > 55 && ebx < 59) || (ebx > 60 && ebx < 65) || ebx == 66 || ebx == 74 || ebx == 76 || (ebx > 83 && ebx < 87))
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.elseif(ebx == 34 || ebx == 45 || ebx == 53)
	mov dword ptr CurrentMapText[ebx * 4], 2
	inc ebx
	.elseif ebx == 55
	mov dword ptr CurrentMapText[ebx * 4], 3
	inc ebx
	.elseif(ebx == 44 || ebx == 46 || ebx == 54 || ebx == 65)
	mov dword ptr CurrentMapText[ebx * 4], 4
	inc ebx
	.elseif(ebx == 24 || ebx == 47 || ebx == 52 || ebx == 75)
	mov dword ptr CurrentMapText[ebx * 4], 5
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 55
	ret

CreateMap1 endp

	; �ڶ��ص�ͼ��ʼ��
CreateMap2 proc

	xor ebx, ebx
	.while ebx < REC_LEN
	.if (ebx == 0 || (ebx > 5 && ebx < 11) || (ebx > 15 && ebx < 21) || ebx == 26 || ebx == 30 || ebx == 36 || ebx == 40 || (ebx > 49 && ebx < 52) || (ebx > 59 && ebx < 62) || (ebx > 69 && ebx < 72) || (ebx > 79 && ebx < 82) || ebx > 86)
	mov dword ptr CurrentMapText[ebx * 4], 0
	inc ebx
	.elseif((ebx > 0 && ebx < 6) || ebx == 11 || ebx == 15 || ebx == 21 || ebx == 25 || (ebx > 26 && ebx < 30) || ebx == 31 || ebx == 35 || ebx == 37 || ebx == 39 || (ebx > 40 && ebx < 44) || (ebx > 44 && ebx < 48) || ebx == 49 || ebx == 52 || ebx == 53)
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.elseif(ebx == 59 || ebx == 62 || ebx == 66 || ebx == 69 || ebx == 72 || (ebx > 75 && ebx < 80) || (ebx > 81 && ebx < 87))
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.elseif(ebx == 13 || ebx == 14 || ebx == 22 || ebx == 32 || ebx == 34 || ebx == 44 || (ebx > 53 && ebx < 58) || (ebx > 62 && ebx < 66) || ebx == 67 || ebx == 68 || (ebx > 72 && ebx < 76))
	mov dword ptr CurrentMapText[ebx * 4], 2
	inc ebx
	.elseif ebx == 12
	mov dword ptr CurrentMapText[ebx * 4], 3
	inc ebx
	.elseif(ebx == 23 || ebx == 24 || ebx == 33)
	mov dword ptr CurrentMapText[ebx * 4], 4
	inc ebx
	.elseif(ebx == 38 || ebx == 48 || ebx == 58)
	mov dword ptr CurrentMapText[ebx * 4], 5
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 12
	ret

CreateMap2 endp

	; �����ص�ͼ��ʼ��
CreateMap3 proc

	xor ebx, ebx
	.while ebx < REC_LEN
	.if (ebx < 11 || (ebx > 17 && ebx < 21) || ebx == 69 || ebx == 70 || ebx > 78)
	mov dword ptr CurrentMapText[ebx * 4], 0
	inc ebx
	.elseif((ebx > 21 && ebx < 27) || (ebx > 35 && ebx < 39) || ebx == 41 || ebx == 43 || ebx == 45 || ebx == 46 || ebx == 48 || ebx == 51 || ebx == 55 || ebx == 57 || ebx == 65 || ebx == 66 || ebx == 67)
	mov dword ptr CurrentMapText[ebx * 4], 2
	inc ebx
	.elseif ebx == 42
	mov dword ptr CurrentMapText[ebx * 4], 3
	inc ebx
	.elseif(ebx == 32 || ebx == 44 || ebx == 47 || ebx == 56)
	mov dword ptr CurrentMapText[ebx * 4], 4
	inc ebx
	.elseif(ebx == 52 || ebx == 53 || ebx == 62 || ebx == 63)
	mov dword ptr CurrentMapText[ebx * 4], 5
	inc ebx
	.else
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 42
	ret
CreateMap3 endp

	; ���Ĺص�ͼ��ʼ��
CreateMap4 proc

	xor ebx, ebx
	.while ebx < REC_LEN
	.if ((ebx > 12 && ebx < 17) || ebx == 22 || ebx == 23 || ebx == 26 || ebx == 32 || ebx == 36 || ebx == 42 || ebx == 43 || ebx == 46 || ebx == 47 || ebx == 52 || ebx == 53 || ebx == 57 || ebx == 62 || ebx == 67 || ebx == 72 || ebx == 77 || (ebx > 81 && ebx < 88))
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.elseif(ebx == 24 || ebx == 25 || ebx == 35 || ebx == 45 || ebx == 54 || ebx == 56 || ebx == 65 || ebx == 66)
	mov dword ptr CurrentMapText[ebx * 4], 2
	inc ebx
	.elseif ebx == 33
	mov dword ptr CurrentMapText[ebx * 4], 3
	inc ebx
	.elseif(ebx == 34 || ebx == 44 || ebx == 55 || ebx == 64 || ebx == 75)
	mov dword ptr CurrentMapText[ebx * 4], 4
	inc ebx
	.elseif(ebx == 63 || ebx == 73 || ebx == 74 || ebx == 76)
	mov dword ptr CurrentMapText[ebx * 4], 5
	inc ebx
	.else
	mov dword ptr CurrentMapText[ebx * 4], 0
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	.if ebx == 75
	mov dword ptr OriginMapText[ebx * 4], 5
	.endif
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov	CurrPosition,33
	ret
CreateMap4 endp

	; ����ص�ͼ��ʼ��
CreateMap5 proc
	
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( ebx < 12 || ( ebx > 16 && ebx < 22 ) || ( ebx > 27 && ebx < 32 ) || ( ebx > 37 && ebx < 41 ) || ebx == 49 || ebx == 50 || ebx == 59 || ebx == 60 || ebx == 69 || ebx == 70 || ebx == 79 || ebx == 80 || ebx > 88 )
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 24 || ebx == 33 || ebx == 35 || ebx == 36 || ebx == 44 || ebx == 46 || ebx == 54 || ebx == 56 || ebx == 57 || ebx == 64 || ebx == 65 || ebx == 67 || ebx == 73 || ebx == 74 || ebx == 75 || ebx == 77 )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 23
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 34 || ebx == 63 || ebx == 76 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 52 || ebx == 62 || ebx == 72 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,23
	ret

CreateMap5 endp

;�����س�ʼ��
CreateMap6 proc
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( ebx < 13 || (ebx > 19 && ebx < 22) || (ebx > 29 && ebx < 32) || (ebx > 39 && ebx < 42) || (ebx > 49 && ebx < 52) || ebx == 79 || ebx > 88)
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 24 || ebx == 25 || ebx == 28 || ebx == 33 || ebx == 34 || ebx == 35 || ebx == 37 || ebx == 38 || ebx == 44 || ebx == 46 || ebx == 48 || ebx == 53 || ebx == 57 || ebx == 58 || ebx == 63 || ebx == 65 || ebx == 67 || ebx == 76 || ebx == 77 )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 27
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 43 || ebx == 45 || ebx == 47 || ebx == 54 || ebx == 64)
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx > 70 && ebx < 76 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,27
	ret
CreateMap6 endp

;���߹س�ʼ��
CreateMap7 proc
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( (ebx > 12 && ebx < 19) || ebx == 23 || ebx == 28 || (ebx > 30 && ebx < 34) || ebx == 38 || ebx == 41 || ebx == 48 || ebx == 51 || ebx == 57 || ebx == 58 || (ebx > 60 && ebx < 65) || ebx == 67 || (ebx > 73 && ebx < 78))
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx 
		.elseif ( (ebx > 23 && ebx < 28 ) || ebx == 37 || ebx == 43 || ebx == 47 || ebx == 52 || ebx == 65 || ebx == 66)
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 42
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 34 || ebx == 35 || ebx == 36 || ebx == 44 || ebx == 53 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 45 || ebx == 46 || ebx == 54 || ebx == 55 || ebx == 56 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 42
	ret
CreateMap7 endp

;�ڰ˹س�ʼ��
CreateMap8 proc
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( (ebx > 12 && ebx < 17) || ebx == 23 || ebx == 26 || ebx == 32 || ebx == 33 || ebx == 36 || ebx == 37 || ebx == 42 || ebx == 47 || ebx == 51 || ebx == 52 || ebx == 57 || ebx == 58 || ebx == 61 || ebx == 64 || ebx == 68 || ebx == 71 || ebx == 78 || (ebx > 80 && ebx < 89) )
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx 
		.elseif ( ebx == 34 || ebx == 43 || ebx == 44 || ebx == 53 || ebx == 55 || ebx == 56 || ebx == 62 || ebx == 63 || ebx == 67 || ebx == 72 || (ebx > 73 && ebx < 78) )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 73
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 45 || ebx == 54 || ebx == 65 || ebx == 66)
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 24 || ebx == 25 || ebx == 35 || ebx == 46 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,73
	ret
CreateMap8 endp

;�ھŹس�ʼ��
CreateMap9 proc
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( ebx < 11 || (ebx > 18 && ebx < 21) || (ebx > 28 && ebx < 31) || (ebx > 38 && ebx < 41) || (ebx > 48 && ebx < 51) || (ebx > 58 && ebx < 61) || (ebx > 68 && ebx < 71) || ebx > 78)
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 22 || ebx == 23 || (ebx > 24 && ebx < 28) || ebx == 37 || ebx ==42 || ebx == 46 || ebx == 52 || ebx == 57 || ebx == 62 || ebx == 63 || (ebx > 64 && ebx < 68 ))
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 32
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 33 || ebx == 36 || ebx == 43 || ebx == 45 || ebx == 53 || ebx == 56 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 34 || ebx == 35 || ebx == 44 || ebx == 54 || ebx == 55 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			.if ebx == 45
				mov dword ptr OriginMapText[ebx * 4], 5
			.endif
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 32
	ret
CreateMap9 endp

;��ʮ�س�ʼ��
CreateMap10 proc
	xor ebx, ebx
	.while ebx < REC_LEN
		.if ( ebx < 12 || ( ebx > 17 && ebx < 22) || ( ebx > 27 && ebx < 32) || ( ebx > 37 && ebx < 41 ) || ( ebx > 48 && ebx < 51 ) || ( ebx > 58 && ebx < 61 ) || ( ebx > 68 && ebx < 71 ) || ( ebx > 78 && ebx < 81 ) || ebx > 88  )
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 24 || ebx == 34 || ebx == 44 || ebx == 45 || ebx == 52 || ebx == 54 || ebx == 55 || ebx == 57 || ebx == 62 || ebx == 67 || ebx == 72 || ebx == 73 || ebx == 74 || ebx == 76 || ebx == 77 )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 75
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 35 || ebx == 46 || ebx == 53 || ebx == 56 || ebx == 64)
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 23 || ebx == 25 || ebx == 26 || ebx == 33 || ebx == 36 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < REC_LEN
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 75
	ret
CreateMap10 endp

; ������
main proc

	invoke GetModuleHandle, NULL
	mov handleMain, eax
	invoke WinMain, handleMain, 0, 0, SW_SHOWNORMAL
	invoke ExitProcess, eax

main endp
end main
