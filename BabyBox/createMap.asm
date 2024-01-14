.386
.model flat, stdcall
option casemap: none

include babybox.inc

extern CurrentMapText: dword, OriginMapText: dword, CurrPosition: dword

.code

; 地图初始化

CreateMap1 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if((ebx > 29 && ebx < 41) || (ebx > 48 && ebx < 60))
	mov dword ptr CurrentMapText[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 41
	mov dword ptr CurrentMapText[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 43)
	mov dword ptr CurrentMapText[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 48)
	mov dword ptr CurrentMapText[ebx * 4], GRID_TARGET
	inc ebx
	.elseif(ebx > 40 && ebx < 49)
	mov dword ptr CurrentMapText[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMapText[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
	mov eax, dword ptr CurrentMapText[ebx * 4]
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
	mov dword ptr CurrentMapText[ebx * 4], GRID_WALL
	inc ebx
	.elseif (ebx == 50 || ebx == 54 || ebx == 56 || ebx == 59 || ebx == 60 || ebx == 66 || (ebx > 68 && ebx < 77) || ebx == 79 || ebx == 80 || ebx > 88)
	mov dword ptr CurrentMapText[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 11
	mov dword ptr CurrentMapText[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 51 || ebx == 17 || ebx == 47 || ebx == 87)
	mov dword ptr CurrentMapText[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 61 || ebx == 16 || ebx == 57 || ebx == 81)
	mov dword ptr CurrentMapText[ebx * 4], GRID_TARGET
	inc ebx
	.else
	mov dword ptr CurrentMapText[ebx * 4], GRID_EMPTY
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
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
	mov dword ptr CurrentMapText[ebx * 4], GRID_WALL
	inc ebx
	.elseif ebx == 33
	mov dword ptr CurrentMapText[ebx * 4], GRID_BABY
	inc ebx
	.elseif(ebx == 45 || ebx == 55 || ebx == 54)
	mov dword ptr CurrentMapText[ebx * 4], GRID_BOX
	inc ebx
	.elseif(ebx == 34 || ebx == 43 || ebx == 44)
	mov dword ptr CurrentMapText[ebx * 4], GRID_TARGET
	inc ebx
	.elseif((ebx > 22 && ebx < 25) || (ebx > 32 && ebx < 36) || (ebx > 42 && ebx < 46) || (ebx > 52 && ebx < 57) || (ebx > 62 && ebx < 67))
	mov dword ptr CurrentMapText[ebx * 4], GRID_EMPTY
	inc ebx
	.else; 其余为空
	mov dword ptr CurrentMapText[ebx * 4], GRID_NULL
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov CurrPosition, 33
	ret
CreateMap3 endp


CreateMap4 proc

	xor ebx, ebx
	.while ebx < MAX_LEN	
	.if ((ebx > 12 && ebx < 17) || ebx == 22 || ebx == 23 || ebx == 26 || ebx == 32 || ebx == 36 || ebx == 42 || ebx == 43 || ebx == 46 || ebx == 47 || ebx == 52 || ebx == 53 || ebx == 57 || ebx == 62 || ebx == 67 || ebx == 72 || ebx == 77 || (ebx > 81 && ebx < 88))
	mov dword ptr CurrentMapText[ebx * 4], 1
	inc ebx
	.elseif(ebx == 24 || ebx == 25 || ebx == 35 || ebx == 45 || ebx == 54 || ebx == 56 || ebx == 65 || ebx == 66)
	mov dword ptr CurrentMapText[ebx * 4], 2
	inc ebx
	.elseif ebx == 33
	mov dword ptr CurrentMapText[ebx * 4], 3
	inc ebx
	.elseif(ebx == 34 || ebx == 44 || ebx == 55 || ebx == 64 || ebx == 75)
	mov dword ptr CurrentMapText[ebx * 4], 4
	inc ebx
	.elseif(ebx == 63 || ebx == 73 || ebx == 74 || ebx == 76)
	mov dword ptr CurrentMapText[ebx * 4], 5
	inc ebx
	.else
	mov dword ptr CurrentMapText[ebx * 4], 0
	inc ebx
	.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
	mov eax, dword ptr CurrentMapText[ebx * 4]
	.if eax == 3 || eax == 4
	mov dword ptr OriginMapText[ebx * 4], 2
	.if ebx == 75
	mov dword ptr OriginMapText[ebx * 4], 5
	.endif
	inc ebx
	.else
	mov dword ptr OriginMapText[ebx * 4], eax
	inc ebx
	.endif
	.endw
	mov	CurrPosition,33
	ret
CreateMap4 endp


CreateMap5 proc
	
	xor ebx, ebx
	.while ebx < MAX_LEN	
		.if ( ebx < 12 || ( ebx > 16 && ebx < 22 ) || ( ebx > 27 && ebx < 32 ) || ( ebx > 37 && ebx < 41 ) || ebx == 49 || ebx == 50 || ebx == 59 || ebx == 60 || ebx == 69 || ebx == 70 || ebx == 79 || ebx == 80 || ebx > 88 )
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 24 || ebx == 33 || ebx == 35 || ebx == 36 || ebx == 44 || ebx == 46 || ebx == 54 || ebx == 56 || ebx == 57 || ebx == 64 || ebx == 65 || ebx == 67 || ebx == 73 || ebx == 74 || ebx == 75 || ebx == 77 )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 23
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 34 || ebx == 63 || ebx == 76 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 52 || ebx == 62 || ebx == 72 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,23
	ret

CreateMap5 endp


CreateMap6 proc
	xor ebx, ebx
	.while ebx <MAX_LEN	
		.if ( ebx < 13 || (ebx > 19 && ebx < 22) || (ebx > 29 && ebx < 32) || (ebx > 39 && ebx < 42) || (ebx > 49 && ebx < 52) || ebx == 79 || ebx > 88)
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 24 || ebx == 25 || ebx == 28 || ebx == 33 || ebx == 34 || ebx == 35 || ebx == 37 || ebx == 38 || ebx == 44 || ebx == 46 || ebx == 48 || ebx == 53 || ebx == 57 || ebx == 58 || ebx == 63 || ebx == 65 || ebx == 67 || ebx == 76 || ebx == 77 )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 27
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 43 || ebx == 45 || ebx == 47 || ebx == 54 || ebx == 64)
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx > 70 && ebx < 76 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx <MAX_LEN	
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,27
	ret
CreateMap6 endp


CreateMap7 proc
	xor ebx, ebx
	.while ebx < MAX_LEN	
		.if ( (ebx > 12 && ebx < 19) || ebx == 23 || ebx == 28 || (ebx > 30 && ebx < 34) || ebx == 38 || ebx == 41 || ebx == 48 || ebx == 51 || ebx == 57 || ebx == 58 || (ebx > 60 && ebx < 65) || ebx == 67 || (ebx > 73 && ebx < 78))
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx 
		.elseif ( (ebx > 23 && ebx < 28 ) || ebx == 37 || ebx == 43 || ebx == 47 || ebx == 52 || ebx == 65 || ebx == 66)
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 42
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 34 || ebx == 35 || ebx == 36 || ebx == 44 || ebx == 53 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 45 || ebx == 46 || ebx == 54 || ebx == 55 || ebx == 56 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 42
	ret
CreateMap7 endp


CreateMap8 proc
	xor ebx, ebx
	.while ebx < MAX_LEN	
		.if ( (ebx > 12 && ebx < 17) || ebx == 23 || ebx == 26 || ebx == 32 || ebx == 33 || ebx == 36 || ebx == 37 || ebx == 42 || ebx == 47 || ebx == 51 || ebx == 52 || ebx == 57 || ebx == 58 || ebx == 61 || ebx == 64 || ebx == 68 || ebx == 71 || ebx == 78 || (ebx > 80 && ebx < 89) )
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx 
		.elseif ( ebx == 34 || ebx == 43 || ebx == 44 || ebx == 53 || ebx == 55 || ebx == 56 || ebx == 62 || ebx == 63 || ebx == 67 || ebx == 72 || (ebx > 73 && ebx < 78) )
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 73
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 45 || ebx == 54 || ebx == 65 || ebx == 66)
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 24 || ebx == 25 || ebx == 35 || ebx == 46 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition,73
	ret
CreateMap8 endp

CreateMap9 proc
	xor ebx, ebx
	.while ebx < MAX_LEN	
		.if ( ebx < 11 || (ebx > 18 && ebx < 21) || (ebx > 28 && ebx < 31) || (ebx > 38 && ebx < 41) || (ebx > 48 && ebx < 51) || (ebx > 58 && ebx < 61) || (ebx > 68 && ebx < 71) || ebx > 78)
			mov dword ptr CurrentMapText[ebx * 4], 0
			inc ebx 
		.elseif ( ebx == 22 || ebx == 23 || (ebx > 24 && ebx < 28) || ebx == 37 || ebx ==42 || ebx == 46 || ebx == 52 || ebx == 57 || ebx == 62 || ebx == 63 || (ebx > 64 && ebx < 68 ))
			mov dword ptr CurrentMapText[ebx * 4], 2
			inc ebx
		.elseif ebx == 32
			mov dword ptr CurrentMapText[ebx * 4], 3
			inc ebx
		.elseif ( ebx == 33 || ebx == 36 || ebx == 43 || ebx == 45 || ebx == 53 || ebx == 56 )
			mov dword ptr CurrentMapText[ebx * 4], 4
			inc ebx
		.elseif ( ebx == 34 || ebx == 35 || ebx == 44 || ebx == 54 || ebx == 55 )
			mov dword ptr CurrentMapText[ebx * 4], 5
			inc ebx
		.else
			mov dword ptr CurrentMapText[ebx * 4], 1
			inc ebx
		.endif
	.endw

	xor ebx, ebx
	.while ebx < MAX_LEN	
		mov eax, dword ptr CurrentMapText[ebx * 4]
		.if eax == 3 || eax == 4
			mov dword ptr OriginMapText[ebx * 4], 2
			.if ebx == 45
				mov dword ptr OriginMapText[ebx * 4], 5
			.endif
			inc ebx
		.else
			mov dword ptr OriginMapText[ebx * 4], eax
			inc ebx
		.endif
	.endw
	mov	CurrPosition, 32
	ret
CreateMap9 endp


end