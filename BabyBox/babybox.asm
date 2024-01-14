.386
.model flat, stdcall
option casemap: none

include babybox.inc

public CurrentMapText, OriginMapText,CurrPosition,handleMain,handleAcce


.data

handleMain		dd ?						; ��������
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
handleButLEVEL			dd	10	dup(0)		; �ؿ���ť���

LevelNum	dd		9						; �ؿ�����
currentLevel	dd		0					; ��¼��ǰ�ؿ�
tempLevel			dd		5 dup(0)		; ��Ϊ�ַ���������
strZero byte "0", 0h
isWin			db		0					; �ж��Ƿ�ɹ�
CurrPosition	dd		0					; ��¼�˵�λ��
OriginMapText	dd		MAX_LEN dup(0)		; ԭʼ��ͼ����
CurrentMapText  dd      MAX_LEN dup(0)		; ��ǰ��ͼ����


.code

; �Ƿ�ͨ��
IsWin proc
	xor eax, eax
	mov eax, 0
	; ���������Ƿ����е�Ŀ�궼�ѵ���
	.while eax < MAX_LEN
		.if OriginMapText[eax * 4] == 5 
			.if CurrentMapText[eax * 4] == 4
			jmp L1
			.else 
				jmp NotWin
			.endif 
		.endif
L1:		inc eax
	.endw
	mov isWin, 1 
	inc currentLevel ;�ؿ���+1
	
	ret
NotWin:		
	mov isWin, 0 
	ret
IsWin endp

; ������ǰ�ؿ���ͼ
CreateLevelMap proc
	; ���ذ�ť
	mov ebx, 0
	.while ebx < LevelNum
		invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
		inc ebx
	.endw

	invoke dwtoa,currentLevel, offset tempLevel
	invoke SendMessage, handleLevelText, WM_SETTEXT, 0, offset tempLevel

	.if currentLevel == 1
		invoke CreateMap1
	.elseif currentLevel == 2
		invoke CreateMap2
	.elseif currentLevel == 3
		invoke CreateMap3
	.elseif currentLevel == 4
		invoke CreateMap4
	.elseif currentLevel == 5
		invoke CreateMap5
	.elseif currentLevel == 6
		invoke CreateMap6
	.elseif currentLevel == 7
		invoke CreateMap7
	.elseif currentLevel == 8
		invoke CreateMap8
	.elseif currentLevel == 9
		invoke CreateMap9
	.else
		invoke endGame
		jmp UPDATE_MAP
	.endif

	invoke startGame
UPDATE_MAP:
	and isWin, 0
	invoke SendMessage, handleStepText, WM_SETTEXT, 0, offset strZero
	invoke updateMap
	ret
CreateLevelMap endp

Respond proc hWnd : dword, uMsg : UINT, wParam : WPARAM, lParam : LPARAM
	local hdc : HDC
	local ps : PAINTSTRUCT

	.if uMsg == WM_INITDIALOG

		invoke LoadAccelerators, handleMain, IDR_ACCELERATOR2
		mov handleAcce, eax
		; ��ʼ������ͱ�ˢ
		invoke InitRec, hWnd
		invoke InitBrush

	.elseif uMsg == WM_PAINT
	
		invoke BeginPaint, hWnd, addr ps
		mov hdc, eax
		invoke FillRect, hdc, addr ps.rcPaint, handleDialogBrush; ���ƶԻ��򱳾�
		
		invoke drawMap, hdc ; ���Ƶ�ͼ
		invoke EndPaint, hWnd, addr ps

	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		movzx eax, ax

		; ���عؿ���Ӧ��ͼ
		.if eax == IDC_NEW || eax == ID_NEW
			; ��ֹ���ֵ�����¿�ʼû��Ӧ�����
			.if currentLevel == 0
				mov currentLevel,1
			.endif
			mov ebx, 0
			.while ebx < LevelNum
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap

		;ѡ��ؿ�����
		.elseif eax == IDC_REMAKE
			mov currentLevel, 0
			mov isWin, 0
			mov ebx, 0
			.while ebx < LevelNum
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_SHOWNORMAL
				inc ebx
			.endw

			invoke chooseLevel

		; �Ϸ����
		.elseif eax == IDC_UP
			.if !isWin
				invoke MoveUp
				invoke IsWin
			.endif

		; �·����
		.elseif eax == IDC_DOWN
			.if !isWin
				invoke MoveDown
				invoke IsWin
			.endif

		; �����
		.elseif eax == IDC_LEFT
			.if !isWin
				invoke MoveLeft
				invoke IsWin
			.endif

		; �ҷ����
		.elseif eax == IDC_RIGHT
			.if !isWin
				invoke MoveRight
				invoke IsWin
			.endif

		.elseif eax == IDC_BLEVEL1
			mov currentLevel, 1 ;���õ�ǰ�ؿ�

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL2
			mov currentLevel, 2

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL3
			mov currentLevel, 3

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL4
			mov currentLevel, 4

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL5
			mov currentLevel, 5

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL6
			mov currentLevel, 6

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL7
			mov currentLevel, 7

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL8
			mov currentLevel, 8

			invoke CreateLevelMap
		.elseif eax == IDC_BLEVEL9
			mov currentLevel, 9

			invoke CreateLevelMap

		.endif

		; ��ʤ
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
Respond endp

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
	mov handleButLEVEL[0], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL2
	mov handleButLEVEL[4], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL3
	mov handleButLEVEL[8], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL4
	mov handleButLEVEL[12], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL5
	mov handleButLEVEL[16], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL6
	mov handleButLEVEL[20], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL7
	mov handleButLEVEL[24], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL8
	mov handleButLEVEL[28], eax

	invoke GetDlgItem, hWnd, IDC_BLEVEL9
	mov handleButLEVEL[32], eax

	ret
	InitRec endp

InitBrush proc
	; ������ͬ����Ļ�ˢ��ɫ
	invoke CreateSolidBrush, DialogBack
	mov handleDialogBrush, eax
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

end
