.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern handleMain:DWORD, handleAcce:DWORD


.code

MainPro proc hInst : dword, hPrevInst : dword, cmdLine : dword, cmdShow : dword
	local window : WNDCLASSEX	; 窗口类
	local msg : MSG				; 消息
	local hWnd : HWND			; 对话框句柄

	invoke RtlZeroMemory, addr window, sizeof WNDCLASSEX

	; 描述窗口类的各种属性
	mov window.cbSize, sizeof WNDCLASSEX		
	mov window.style, CS_HREDRAW or CS_VREDRAW	
	mov window.lpfnWndProc, offset Respond	; 消息处理函数地址
	mov window.cbClsExtra, 0					
	mov window.cbWndExtra, DLGWINDOWEXTRA		
	mov window.hbrBackground, COLOR_WINDOW
	mov window.hIconSm, 0

	push hInst
	pop window.hInstance

	invoke LoadCursor, NULL, IDC_ARROW
	mov window.hCursor, eax

	invoke RegisterClassEx, addr window
	; 加载对话框窗口
	invoke CreateDialogParam, hInst, IDD_DIALOG1, 0, offset Respond, 0
	mov hWnd, eax
	
	; 设置主窗体id
	invoke setMainWindowsId, eax

	invoke ShowWindow, hWnd, cmdShow; 显示
	invoke UpdateWindow, hWnd; 更新

	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.break .if eax == 0
		invoke TranslateAccelerator, hWnd, handleAcce, addr msg
		.if eax == 0
			invoke TranslateMessage, addr msg
			invoke DispatchMessage, addr msg
		.endif
	.endw

	mov eax, msg.wParam
	ret
MainPro endp

main proc

	invoke GetModuleHandle, NULL
	mov handleMain, eax
	invoke MainPro, handleMain, 0, 0, SW_SHOWNORMAL
	invoke ExitProcess, eax

main endp
end main