.386
.model flat, stdcall
option casemap: none

include babybox.inc

public CurrentMapText, OriginMap,CurrPosition,handleMain,handleAcce


.data

handleMain		dd ?						; 主程序句柄
handleGuide			dd ?					; 引导文字句柄
handleLevel			dd ?					; 关卡句柄
handleLevelText      dd ?					; 关卡文本句柄
handleStep			dd ?					; 步数句柄
handleStepText		dd ?					; 步数文本句柄
handleMenu			dd ?					; 菜单句柄
handleIcon			dd ?					; 图标句柄
handleAcce			dd ?					; 热键句柄
handleStage			dd ?					; 矩形外部句柄
handleDialogBrush    dd ?					; 对话框背景笔刷
handleStageBrush     dd ?					; 矩形外部背景笔刷
handleButLEVEL			dd	10	dup(0)		; 关卡按钮句柄

LevelNum	dd		9						; 关卡数量
currentLevel	dd		0					; 记录当前关卡
tempLevel			dd		5 dup(0)		; 作为字符串缓冲区
strZero byte "0", 0h
isWin			db		0					; 判断是否成功
CurrPosition	dd		0					; 记录人的位置
OriginMap	dd		MAX_LEN dup(0)		; 原始地图矩阵
CurrentMapText  dd      MAX_LEN dup(0)		; 当前地图矩阵


.code

; 创建当前关卡地图
CreateLevelMap proc
	; 隐藏按钮
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

; 是否通关
IsWin proc
	xor eax, eax
	mov eax, 0
	; 检查矩阵中是否所有的目标都已到达
	.while eax < MAX_LEN
		.if OriginMap[eax * 4] == 5 
			.if CurrentMapText[eax * 4] == 4
			jmp L1
			.else 
				jmp NotWin
			.endif 
		.endif
L1:		inc eax
	.endw
	mov isWin, 1 
	inc currentLevel ;关卡数+1
	
	ret
NotWin:		
	mov isWin, 0 
	ret
IsWin endp

Respond proc hWnd : dword, uMsg : UINT, wParam : WPARAM, lParam : LPARAM
	; 响应各类事件
	local hdc : HDC
	local ps : PAINTSTRUCT

	.if uMsg == WM_INITDIALOG

		invoke LoadAccelerators, handleMain, IDR_ACCELERATOR2
		mov handleAcce, eax
		; 初始化矩阵和笔刷
		invoke InitHandle, hWnd
		invoke InitBrush

	.elseif uMsg == WM_PAINT
	
		invoke BeginPaint, hWnd, addr ps
		mov hdc, eax
		invoke FillRect, hdc, addr ps.rcPaint, handleDialogBrush; 绘制背景
		
		invoke drawMap, hdc ; 绘制地图
		invoke EndPaint, hWnd, addr ps

	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		movzx eax, ax

		; 加载关卡对应地图
		.if eax == IDC_NEW || eax == ID_NEW
			; 防止出现点击重新开始没反应的情况
			.if currentLevel == 0
				mov currentLevel,1
			.endif
			mov ebx, 0
			.while ebx < LevelNum
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_HIDE
				inc ebx
			.endw
			invoke CreateLevelMap

		;选择关卡界面
		.elseif eax == IDC_REMAKE
			mov currentLevel, 0
			mov isWin, 0
			mov ebx, 0
			.while ebx < LevelNum
		        invoke ShowWindow, handleButLEVEL[ebx * 4], SW_SHOWNORMAL
				inc ebx
			.endw

			invoke chooseLevel

		; 上
		.elseif eax == IDC_UP
			.if !isWin
				invoke MoveUp
				invoke IsWin
			.endif

		; 下
		.elseif eax == IDC_DOWN
			.if !isWin
				invoke MoveDown
				invoke IsWin
			.endif

		; 左
		.elseif eax == IDC_LEFT
			.if !isWin
				invoke MoveLeft
				invoke IsWin
			.endif

		; 右
		.elseif eax == IDC_RIGHT
			.if !isWin
				invoke MoveRight
				invoke IsWin
			.endif

		.elseif eax == IDC_BLEVEL1
			mov currentLevel, 1 ;设置当前关卡

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

		; 获胜
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

InitHandle proc hWnd : dword
	; 初始化需要的句柄
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
	InitHandle endp

InitBrush proc
	; 创建笔刷
	invoke CreateSolidBrush, BackgroundColor
	mov handleDialogBrush, eax
	ret
InitBrush endp

MoveUp proc
	xor esi, esi
	mov esi, CurrPosition; esi-当前位置
	mov edi, esi
	sub edi, 10; edi-上方位置

	invoke setPlayerDirection, DIRECTION_UP

	; 空或target
	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov  CurrPosition, edi
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY
		mov eax, OriginMap[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; 刷新格子
		invoke updateGrid, edi
		invoke updateGrid, esi

	; 箱子：判断箱子上方
	.elseif CurrentMapText[edi * 4] == GRID_BOX
		xor ecx, ecx
		mov ecx, edi
		sub ecx, 10; ecx-上上方位置

		; 如果是围墙或箱子
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
			; 刷新格子
			invoke updateGrid, esi
		.else ; 可移动
			mov CurrPosition, edi
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMap[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; 刷新格子
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi

		.endif

	; 墙
	.else
		
		invoke updateGrid, esi
	.endif
	ret
MoveUp endp

MoveDown proc
	xor esi, esi
	mov esi, CurrPosition
	mov edi, esi
	add edi, 10

	invoke setPlayerDirection, DIRECTION_DOWN

	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY
		mov eax, OriginMap[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; 刷新格子
		invoke updateGrid, edi
		invoke updateGrid, esi

	; 箱子
	.elseif CurrentMapText[edi * 4] == GRID_BOX

		xor ecx, ecx
		mov ecx, edi
		add ecx, 10; ecx下下方位置

		; 围墙或箱子
		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX
			invoke updateGrid, esi
		.else
			; 可以移动
			mov CurrPosition, edi; 改变人的当前位置
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMap[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; 刷新格子
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		; 墙
		invoke updateGrid, esi
	.endif
	ret
MoveDown endp

MoveLeft proc

	xor esi, esi
	mov esi, CurrPosition
	mov edi, esi
	sub edi, 1


	invoke setPlayerDirection, DIRECTION_LEFT


	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY
		mov eax, OriginMap[esi * 4]
		mov CurrentMapText[esi * 4], eax
		; 刷新格子
		invoke updateGrid, edi
		invoke updateGrid, esi
	; 箱子
	.elseif CurrentMapText[edi * 4] == GRID_BOX

		xor ecx, ecx
		mov ecx, edi
		sub ecx, 1

		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX

			invoke updateGrid, esi
		.else
			mov dword ptr CurrPosition, edi; 改变当前位置
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMap[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; 刷新格子
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		;墙
		invoke updateGrid, esi
	.endif
	ret
MoveLeft endp

MoveRight proc

	xor esi, esi
	mov esi, CurrPosition
	mov edi, esi
	add edi, 1

	invoke setPlayerDirection, DIRECTION_RIGHT

	.if CurrentMapText[edi * 4] == GRID_EMPTY || CurrentMapText[edi * 4] == GRID_TARGET
		mov dword ptr CurrPosition, edi
		mov dword ptr CurrentMapText[edi * 4], GRID_BABY
		mov eax, OriginMap[esi * 4]
		mov CurrentMapText[esi * 4], eax

		invoke updateGrid, edi
		invoke updateGrid, esi

	.elseif CurrentMapText[edi * 4] == GRID_BOX

		xor ecx, ecx
		mov ecx, edi
		add ecx, 1

		.if CurrentMapText[ecx * 4] == GRID_WALL || CurrentMapText[ecx * 4] == GRID_BOX

			invoke updateGrid, esi
		.else
			; 移动
			mov dword ptr CurrPosition, edi; 改变当前位置
			mov dword ptr CurrentMapText[ecx * 4], GRID_BOX
			mov dword ptr CurrentMapText[edi * 4], GRID_BABY
			mov eax, OriginMap[esi * 4]
			mov CurrentMapText[esi * 4], eax
			; 刷新格子
			invoke updateGrid, ecx
			invoke updateGrid, edi
			invoke updateGrid, esi
		.endif

	.else
		; 墙
		invoke updateGrid, esi
	.endif
	ret
MoveRight endp

end
