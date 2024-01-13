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

; ��������

; ����������id
; win: HWND ����id.
; HWND �� Windows ����ϵͳ�е�һ�������handle�����ͣ����ڱ�ʾ���ڵľ������Windows����У����ھ�� HWND ��һ����Ҫ���������ͣ�
; ������Ψһ��ʶ�����ô��ڶ��󡣴��ھ����һ��32λ��64λ��ֵ������ȡ���ڲ���ϵͳ��λ����
setMainWindowsId proto win: HWND

; ��ʼ��Ϸ
startGame proto
; ������Ϸ
resetGame proto
; ����ؿ�ѡ��
chooseLevel proto
; ������Ϸ
endGame proto

; ���ý�ɫ����
setPlayerDirection proto u32Face: dword
; ˢ��ȫͼ
updateMap proto
; ˢ�¸���
; gridIndex: dword ���Ӻ�
updateGrid proto u32GridInd: dword
; ����ȫͼ
; deviceContext: HDC �豸������id
drawMap proto devc: HDC

; ��������

DIRECTION_UP equ 0
DIRECTION_RIGHT equ 1
DIRECTION_DOWN equ 2
DIRECTION_LEFT equ 3

endif