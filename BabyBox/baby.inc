ifndef BABY_INC
BABY equ <1>

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

endif