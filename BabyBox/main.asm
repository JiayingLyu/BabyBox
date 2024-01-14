.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern handleMain:DWORD, handleAcce:DWORD,ProgramName:DWORD

.code

MainPro proc hInst : dword, hPrevInst : dword, cmdLine : dword, cmdShow : dword
	; 局部变量声明
	local window : WNDCLASSEX	; 窗口类
	local msg : MSG				; 消息
	local hWnd : HWND			; 对话框句柄

	invoke RtlZeroMemory, addr window, sizeof WNDCLASSEX

	mov window.cbSize, sizeof WNDCLASSEX		; 窗口类的大小
	mov window.style, CS_HREDRAW or CS_VREDRAW	; 窗口风格
	mov window.lpfnWndProc, offset Calculate	; 窗口消息处理函数地址
	mov window.cbClsExtra, 0					; 在窗口类结构体后的附加字节数，共享内存
	mov window.cbWndExtra, DLGWINDOWEXTRA		; 在窗口实例后的附加字节数

	push hInst
	pop window.hInstance; 窗口所属程序句柄

	mov window.hbrBackground, COLOR_WINDOW; 背景画刷句柄
	mov window.lpszClassName, offset ProgramName; 窗口类类名称

	; 加载光标句柄
	invoke LoadCursor, NULL, IDC_ARROW
	mov window.hCursor, eax

	mov window.hIconSm, 0; 窗口小图标句柄

	invoke RegisterClassEx, addr window; 注册窗口类
	; 加载对话框窗口
	invoke CreateDialogParam, hInst, IDD_DIALOG1, 0, offset Calculate, 0
	mov hWnd, eax
	
	; 设置主窗体id
	invoke setMainWindowsId, eax

	invoke ShowWindow, hWnd, cmdShow; 显示窗口
	invoke UpdateWindow, hWnd; 更新窗口

	; 消息循环
	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0; 获取消息
		.break .if eax == 0
		invoke TranslateAccelerator, hWnd, handleAcce, addr msg; 转换快捷键消息
		.if eax == 0
			invoke TranslateMessage, addr msg; 转换键盘消息
			invoke DispatchMessage, addr msg; 分发消息
		.endif
	.endw

	mov eax, msg.wParam
	ret
MainPro endp

; 主程序
main proc

	invoke GetModuleHandle, NULL
	mov handleMain, eax
	invoke MainPro, handleMain, 0, 0, SW_SHOWNORMAL
	invoke ExitProcess, eax

main endp
end main