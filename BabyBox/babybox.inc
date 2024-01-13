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

MAX_LEN		EQU	100
REC_LEN		EQU	100
BRUSH_LEN	EQU 6
Number0		EQU 00b4c1cdh
Number1		EQU 008cfeffh
Number2		EQU 0097d0e8h
Number3		EQU 0091d2ffh
Number4		EQU 007999e8h
Number5		EQU 00918fffh

DialogBack	EQU 00eff8fah
StageBack   EQU 00a0adbbh
TextColor   EQU 00000000h
ButtonColor EQU 00ffffffh

WinMain             PROTO :DWORD, :DWORD, :DWORD, :DWORD	; 窗口主程序
Calculate           PROTO :DWORD, :DWORD, :DWORD, :DWORD	; 消息处理程序
InitRec             PROTO :DWORD							; 初始化方格矩阵
InitBack            PROTO       							; 初始化颜色数组
InitBrush           PROTO       							; 初始化笔刷数组
RefreshRec			PROTO
MoveUp				PROTO
MoveDown			PROTO
MoveLeft			PROTO
MoveRight			PROTO
CreateMap1			PROTO
CreateMap2			PROTO
CreateMap3			PROTO
CreateMap4			PROTO
CreateMap5			PROTO
CreateMap6			PROTO
CreateMap7			PROTO
CreateMap8			PROTO
CreateMap9			PROTO
CreateMap10			PROTO
ShowNumber			PROTO

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

; 地图区域x
MAP_X equ 35
; 地图区域y
MAP_Y equ 90
; 格子尺寸
GRID_SIZE equ 48
; 地图尺寸,结合size，这边是10 * 10 格子
MAP_SIZE equ 480

; 地图类型
; 无
GRID_NULL equ 0
; 墙
GRID_WALL equ 1
; 空地
GRID_EMPTY equ 2
; 玩家
GRID_BABY equ 3
; 箱子不在目标点
GRID_BOX equ 4
; 目标点
GRID_TARGET equ 5
; 箱子在目标点
GRID_BOX_TARGET equ 6
; 朝上的玩家
GRID_BABY_UP equ 7
; 朝右的玩家
GRID_BABY_RIGHT equ 8
; 朝下的玩家
GRID_BABY_DOWN equ 9
; 朝左的玩家
GRID_BABY_LEFT equ 10

; 初始化的场景
SCENE_INITIAL equ 0
; 选择关卡场景
SCENE_CHOOSE_LEVEL equ 1
; 关卡场景
SCENE_LEVEL equ 2
; 通关场景
SCENE_DESTINATION equ 3

; 函数声明

; 设置主窗体id
; win: HWND 窗体id.
; HWND 是 Windows 操作系统中的一个句柄（handle）类型，用于表示窗口的句柄。在Windows编程中，窗口句柄 HWND 是一个重要的数据类型，
; 它用于唯一标识和引用窗口对象。窗口句柄是一个32位或64位的值，具体取决于操作系统的位数。
setMainWindowsId proto win: HWND

; 开始游戏
startGame proto
; 重置游戏
resetGame proto
; 进入关卡选择
chooseLevel proto
; 结束游戏
endGame proto

; 设置角色方向
setPlayerDirection proto u32Face: dword
; 刷新全图
updateMap proto
; 刷新格子
; gridIndex: dword 格子号
updateGrid proto u32GridInd: dword
; 绘制全图
; deviceContext: HDC 设备上下文id
drawMap proto devc: HDC

; 变量声明

DIRECTION_UP equ 0
DIRECTION_RIGHT equ 1
DIRECTION_DOWN equ 2
DIRECTION_LEFT equ 3

externdef CurrentMapText: dword
externdef OriginMapText: dword

endif
