.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern CurrentMap: dword, OriginMap: dword, CurrPosition: dword

.code

; 地图初始化
; 太难了？答案在这：https://www.bilibili.com/video/BV1W4411E7sc/?buvid=Y648ED65BF54DDFA412FBA31E98A6E001A03&is_story_h5=false&mid=ml5OG19tXjufdivMH7%2Fj%2FA%3D%3D&p=2&plat_id=168&share_from=ugc&share_medium=iphone&share_plat=ios&share_session_id=30FCE877-087A-403D-95EA-94189032CD7A&share_source=WEIXIN&share_tag=s_i&spmid=main.my-history-search-result.option-more.0&timestamp=1705221590&unique_k=H17RgyZ&up_id=277706476&share_source=weixin
CreateMap1 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 29 && ebx < 41) || (ebx > 48 && ebx < 60))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 41
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 43)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 48)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif(ebx > 40 && ebx < 49)
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
	mov eax, dword ptr CurrentMap[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMap[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMap[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 41
	ret

CreateMap1 endp


CreateMap2 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if (ebx < 11 || ebx == 12 || ebx == 19 || ebx == 20 || ebx == 22 || (ebx > 23 && ebx < 28) || ebx == 29 || ebx == 30 || ebx == 32 || ebx == 34 || ebx == 39 || ebx == 40 || ebx == 42 || ebx == 44 || ebx == 46 || ebx == 48 || ebx == 49)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif (ebx == 50 || ebx == 54 || ebx == 56 || ebx == 59 || ebx == 60 || ebx == 66 || (ebx > 68 && ebx < 77) || ebx == 79 || ebx == 80 || ebx > 88)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 11
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 51 || ebx == 17 || ebx == 47 || ebx == 87)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 61 || ebx == 16 || ebx == 57 || ebx == 81)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.else
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
	mov eax, dword ptr CurrentMap[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMap[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMap[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 11
	ret

CreateMap2 endp


CreateMap3 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 11 && ebx < 16) || (ebx > 24 && ebx < 27) || (ebx > 45 && ebx < 48) || (ebx > 71 && ebx < 78) || ebx == 22 || ebx == 32 || ebx == 36 || ebx == 42 || ebx == 52 || ebx == 57 || ebx == 62 || ebx == 67)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 33
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 45 || ebx == 55 || ebx == 54)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 34 || ebx == 43 || ebx == 44)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 22 && ebx < 25) || (ebx > 32 && ebx < 36) || (ebx > 42 && ebx < 46) || (ebx > 52 && ebx < 57) || (ebx > 62 && ebx < 67))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
	mov eax, dword ptr CurrentMap[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMap[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMap[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 33
	ret
CreateMap3 endp


CreateMap4 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 12 && ebx < 17) || (ebx > 25 && ebx < 29) || (ebx > 30 && ebx < 34) || (ebx > 60 && ebx < 64) || (ebx > 66 && ebx < 69) || (ebx > 72 && ebx < 78))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 23 || ebx == 38 || ebx == 41 || ebx == 48 || ebx == 51 || ebx == 58 || ebx == 55)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 42)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 43 || ebx == 44 || ebx == 45)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 35 || ebx == 56 || ebx == 64)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 23 && ebx < 26) || (ebx > 33 && ebx < 38) || (ebx > 41 && ebx < 48) || (ebx > 51 && ebx < 58) || (ebx > 63 && ebx < 67))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
	mov eax, dword ptr CurrentMap[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMap[ebx * 4], 2
	.if ebx == 75
	mov dword ptr OriginMap[ebx * 4], 5
	.endif
	inc ebx
	.else
	mov dword ptr OriginMap[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov	CurrPosition, 42
	ret
CreateMap4 endp


CreateMap5 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 11 && ebx < 17) || (ebx > 30 && ebx < 33) || (ebx > 35 && ebx < 39) || (ebx > 60 && ebx < 63) || (ebx > 65 && ebx < 69) || (ebx > 71 && ebx < 77))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 22 || ebx == 26 || ebx == 41 || ebx == 48 || ebx == 51 || ebx == 58)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 64)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx > 42 && ebx < 47)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx > 52 && ebx < 57)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 22 && ebx < 26) || (ebx > 32 && ebx < 36) || (ebx > 41 && ebx < 48) || (ebx > 51 && ebx < 58) || (ebx > 62 && ebx < 66))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMap[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMap[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMap[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 64
	ret

CreateMap5 endp


CreateMap6 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 9 && ebx < 18) || (ebx > 39 && ebx < 44) || (ebx > 44 && ebx < 49) || (ebx > 72 && ebx < 79) || (ebx > 79 && ebx < 84))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 20 || ebx == 27 || ebx == 30 || ebx == 37 || ebx == 50 || ebx == 58 || ebx == 60 || ebx == 68 || ebx == 70)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 24)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif((ebx > 32 && ebx < 36) || ebx == 66)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 21 || ebx == 22 || ebx == 25 || ebx == 26)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 20 && ebx < 27) || (ebx > 30 && ebx < 37) || ebx == 44 || (ebx > 50 && ebx < 58) || (ebx > 60 && ebx < 68) || (ebx > 70 && ebx < 73))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
		mov eax, dword ptr CurrentMap[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMap[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMap[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 24
	ret
CreateMap6 endp


CreateMap7 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 0 && ebx < 9) || (ebx > 44 && ebx < 47) || (ebx > 80 && ebx < 86) || (ebx > 94 && ebx < 99) || ebx == 33 || ebx == 53 || ebx == 65)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 11 || ebx == 15 || ebx == 18 || ebx == 21 || ebx == 25 || ebx == 28 || ebx == 31 || ebx == 35 || ebx == 38 || ebx == 41 || ebx == 48 || ebx == 51 || ebx == 58 || ebx == 61 || ebx == 68 || ebx == 71 || ebx == 78 || ebx == 88)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 64)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 23 || ebx == 43 || ebx == 44 || ebx == 63 || ebx == 75)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 57 || ebx == 67 || ebx == 77 || ebx == 86 || ebx == 87)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 11 && ebx < 18) || (ebx > 21 && ebx < 28) || (ebx > 31 && ebx < 38) || (ebx > 41 && ebx < 48) || (ebx > 51 && ebx < 58) || (ebx > 61 && ebx < 68) || (ebx > 71 && ebx < 78) || (ebx > 85 && ebx < 88))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMap[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMap[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMap[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 64
	ret
CreateMap7 endp


CreateMap8 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 1 && ebx < 7) || (ebx > 10 && ebx < 13) || (ebx > 15 && ebx <18) || (ebx > 80 && ebx < 83) || (ebx > 85 && ebx < 88) || (ebx > 91 && ebx < 97))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 21 || ebx == 27 || ebx == 31 || ebx == 37 || ebx == 42 || ebx == 46 || ebx == 51 || ebx == 57 || ebx == 61 || ebx == 67 || ebx == 71 || ebx == 77)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 14)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 24 || ebx == 33 || ebx == 35 || ebx == 43 || ebx == 45 || ebx == 63 || ebx == 65 || ebx == 74)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 23 || ebx == 25 || ebx == 34 || ebx == 44 || ebx == 54 || ebx == 64 || ebx == 73 || ebx == 75)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 12 && ebx < 16) || (ebx > 21 && ebx < 27) || (ebx > 31 && ebx < 37) || (ebx > 42 && ebx < 46) || (ebx > 51 && ebx < 57) || (ebx > 61 && ebx < 67) || (ebx > 71 && ebx < 77) || (ebx > 82 && ebx < 86))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMap[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMap[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMap[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 14
	ret
CreateMap8 endp

CreateMap9 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 13 && ebx < 18) || (ebx > 31 && ebx < 35) || (ebx > 71 && ebx < 78))
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx	
	.elseif(ebx == 24 || ebx == 27 || ebx == 37 || ebx == 42 || ebx == 47 || ebx == 52 || ebx == 57 || ebx == 62 || ebx == 67)
	mov dword ptr CurrentMap[ebx * 4], GRID_WALL
	inc ebx
	.elseif(ebx == 36)
	mov dword ptr CurrentMap[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 45 || ebx == 55 || ebx == 65)
	mov dword ptr CurrentMap[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 46 || ebx == 56 || ebx == 66)
	mov dword ptr CurrentMap[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 24 && ebx < 27) || (ebx > 34 && ebx < 37) || (ebx > 42 && ebx < 47) || (ebx > 52 && ebx < 57) || (ebx > 62 && ebx < 67))
	mov dword ptr CurrentMap[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMap[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMap[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMap[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMap[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 36
	ret
CreateMap9 endp


end