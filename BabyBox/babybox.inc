ifndef BABYBOX_INC
BABYBOX_INC equ <1>

include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include masm32.inc
include shell32.inc
include gdi32.inc
include msvcrt.inc

includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib masm32.lib
includelib gdi32.lib
includelib msvcrt.lib

; ————函数定义————

MainPro             PROTO :DWORD, :DWORD, :DWORD, :DWORD	; 窗口主程序
Calculate           PROTO :DWORD, :DWORD, :DWORD, :DWORD	; 消息处理程序
InitRec             PROTO :DWORD							; 初始化方格矩阵
InitBack            PROTO       							; 初始化颜色数组
InitBrush           PROTO       							; 初始化笔刷数组
RefreshRec			PROTO									; 刷新矩阵
MoveUp				PROTO									; 人物向上逻辑
MoveDown			PROTO									; 人物向下逻辑
MoveLeft			PROTO									; 人物向左逻辑
MoveRight			PROTO									; 人物向右逻辑
CreateMap1			PROTO									; 创建地图1
CreateMap2			PROTO
CreateMap3			PROTO
CreateMap4			PROTO
CreateMap5			PROTO
CreateMap6			PROTO
CreateMap7			PROTO
CreateMap8			PROTO
CreateMap9			PROTO
CreateMap10			PROTO

setMainWindowsId	PROTO :HWND								; 设置主窗口ID
startGame			PROTO									; 开始游戏
resetGame			PROTO									; 重置游戏
chooseLevel			PROTO									; 进入关卡选择
endGame				PROTO									; 结束游戏
setPlayerDirection	PROTO :DWORD							; 设置角色方向
updateMap			PROTO									; 刷新全图
updateGrid			PROTO :DWORD							; 刷新格子
drawMap				PROTO :HDC								; 绘制全图
loadSceneBitmap		PROTO									; 加载位图
beginDraw			PROTO									; 开始绘制
endDraw				PROTO									; 结束绘制
drawImage			PROTO :HBITMAP, :SWORD, :SWORD,: DWORD, : DWORD

; ————常量————

MAX_LEN		EQU	100											; 最大长度
REC_LEN		EQU	100											; 矩阵最大长度
DialogBack	EQU 00eff8fah
StageBack   EQU 00a0adbbh
TextColor   EQU 00000000h
ButtonColor EQU 00ffffffh

; 地图尺寸相关
MAP_X equ 35			; 地图区域x
MAP_Y equ 90			; 地图区域y
GRID_SIZE equ 48		; 格子尺寸
MAP_SIZE equ 480		; 地图尺寸,10 * 10
; 地图类型相关
GRID_NULL equ 0			; 无
GRID_WALL equ 1			; 墙
GRID_EMPTY equ 2		; 空地
GRID_BABY equ 3			; 玩家
GRID_BOX equ 4			; 箱子不在目标点
GRID_TARGET equ 5		; 目标点
GRID_BOX_TARGET equ 6	; 箱子在目标点
GRID_BABY_UP equ 7		; 朝上的玩家
GRID_BABY_RIGHT equ 8	; 朝右的玩家
GRID_BABY_DOWN equ 9	; 朝下的玩家
GRID_BABY_LEFT equ 10	; 朝左的玩家
DIRECTION_UP equ 0
DIRECTION_RIGHT equ 1
DIRECTION_DOWN equ 2
DIRECTION_LEFT equ 3
; 场景类型相关
SCENE_INITIAL equ 0		; 初始化的场景
SCENE_CHOOSE_LEVEL equ 1; 选择关卡场景
SCENE_LEVEL equ 2		; 关卡场景
SCENE_DESTINATION equ 3	; 通关场景

; 控件绑定
IDD_DIALOG1            EQU         102
IDR_MENU1              EQU         108
IDR_ACCELERATOR2       EQU         109
IDC_NEW                EQU         1007
IDC_DATE               EQU         1008
IDC_UP                 EQU         1118
IDC_DOWN               EQU         1119
IDC_LEFT               EQU         1120
IDC_RIGHT              EQU         1121
IDC_STEP               EQU         1122
IDC_STEPTEXT           EQU         1123
IDC_LEVEL              EQU         1124
IDC_LEVELTEXT          EQU         1125
IDC_REMAKE             EQU         1126
ID_NEW                 EQU         40007
ID_EXIT                EQU         40008
ID_ABOUT               EQU         40009
ID_WRITER              EQU         40012
IDC_BLEVEL1            EQU         1130
IDC_BLEVEL2            EQU         1131
IDC_BLEVEL3            EQU         1132
IDC_BLEVEL4            EQU         1133
IDC_BLEVEL5            EQU         1134
IDC_BLEVEL6            EQU         1135
IDC_BLEVEL7            EQU         1136
IDC_BLEVEL8            EQU         1137
IDC_BLEVEL9            EQU         1138
IDC_BLEVEL10           EQU         1139

endif