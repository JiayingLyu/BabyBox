.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern handleMain:DWORD, handleAcce:DWORD,ProgramName:DWORD

.code

MainPro proc hInst : dword, hPrevInst : dword, cmdLine : dword, cmdShow : dword
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
MainPro endp

; ������
main proc

	invoke GetModuleHandle, NULL
	mov handleMain, eax
	invoke MainPro, handleMain, 0, 0, SW_SHOWNORMAL
	invoke ExitProcess, eax

main endp
end main