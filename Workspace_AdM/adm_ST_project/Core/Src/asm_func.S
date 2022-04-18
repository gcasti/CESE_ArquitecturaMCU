.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global	asm_productoEscalar16
.global asm_productoEscalar12
.global asm_max
.global asm_invertir
.global asm_downsampleM
.global asm_filtroVentana10

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero al vector
@   r1: longitud del vector
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.thumb_func
	asm_zeros:
		mov r2, 0
	.asm_zeros_for:
		str r2, [r0],4	// [] referencia al contenido del puntero
		subs r1, 1
		bne .asm_zeros_for
		bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@	void asm_productoEscalar32 (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@   r1:	puntero al vector que se utiliza como salida
@	r2: longitud del vector
@	r3: escalar
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_productoEscalar32:
		push {r4}
	.asm_producto32_for:
		ldr r4,[r0],4
		mul r4,r3
		str r4,[r1],4
		subs r2,1
		bne .asm_producto32_for
		pop {r4}
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@	 void productoEscalar16 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@   r1:	puntero al vector que se utiliza como salida
@	r2: longitud del vector
@	r3: escalar
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_productoEscalar16:
		push {r4}
	.asm_producto16_for:
		ldrh r4,[r0],2
		mul r4,r3
		strh r4,[r1],2
		subs r2,1
		bne .asm_producto16_for
		pop {r4}
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@	 void asm_productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@   r1:	puntero al vector que se utiliza como salida
@	r2: longitud del vector
@	r3: escalar
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_productoEscalar12:
		push {r4,r5}
	.asm_producto12_for:
		ldrh r4,[r0],2		@ carga el valor de un dato del vector
		mov r5, 0x0FFF		@ carga la máscara en un registro
		and r4,r5			@ toma los 12 bits del dato
		mul r4,r3			@ realiza la multiplicación
		and r4,r5			@ descarla los bits superiores si hubo overflow
		strh r4,[r1],2
		subs r2,1
		bne .asm_producto12_for
		pop {r4,r5}
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@		int32_t asm_max (int32_t * vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@	r1: longitud del vector
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_max:
	ldr r3, [r0]		@Se utiliza r3 como auxiliar para almacenar el máximo
	.asm_max_for:
		ldr r2,[r0],4
		cmp r2,r3		@Se compara el valor cargado con el auxiliar
		IT GE
		movge r3,r2		@Se ejecuta según la actualización de los flags
		subs r1,1
		bne .asm_max_for
		mov r0,r3
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@		void asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@	r1: longitud del vector
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_invertir:
	mov r4,r1
	lsl r4,1
	.asm_invertir_for:
		ldrh r2,[r0]	 	@ carga el primer valor del vector de entrada
		ldrh r3,[r0,r4]		@ carga el último valor del vector de entrada
		strh r2,[r0,r4]		@ guarda el contenido de r2 en último posición del vector
		strh r3,[r0]		@ guarda el contenido de r3 en la primer posición del vector
		ldr r0,[r0,2]
		subs r1,1
		bne .asm_invertir_for
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@	void asm_downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t M);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@   r1:	puntero al vector que se utiliza como salida
@	r2: longitud del vector
@	r3: Posición a decimar
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_downsampleM:
	push {r4-r7}
	mov r5,1		@ contador de la posición del vector leída
	mov r6,1		@ cantidad de múltiplos de N
	mov r7,r3		@ muestra a eliminar
	.asm_downsampleM_for:
		ldr r4,[r0],4		@ carga el valor del vector de entrada y aumenta el puntero
		cmp r5,r7
		ITEE NE
		strne r4,[r1],4		@ copia en el vector de salida el valor
		addeq r6,1			@ se encontró un múltiplo de M
		muleq r7,r3,r6		@ se encontró un múltiplo de M
		add r5,1
		subs r2,1
		bne .asm_downsampleM_for
		pop {r4-r7}
		bx lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@	void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: puntero al vector de entrada
@   r1:	puntero al vector que se utiliza como salida
@	r2: longitud del vector de entrada
@
@ Valor de retorno:
@   r0: NULL
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.thumb_func
	asm_filtroVentana10:
	push {r4-r9}
	mov r6,r0
	mov r8,r0
	mov r4,0	@registro que tendrá la suma de los valores en la ventana
	mov r9,3	@longitud de la ventana

@bucle que carga r4 acumulando los valores iniciales de la ventana
	mov r5,r9 	@contador de los valores en la ventana
	.asm_ventana_for:
		ldrh r3,[r6],2
		adds r4, r3
		subs r5,1
		bne .asm_ventana_for

		@r0 contiene la dirección del primer valor de la ventana
		@r6 contiene la dirección del último valor de la ventana
		sdiv r3,r4,r9
		strh r3,[r1],2

	.asm_filtro_for:
		cmp r2,r9		@comprueba si se alcanza el final del vector
		IT EQ
		moveq r6,r8		@implenta el "rool-over"

		ldrh r7,[r0],2	@carga el valor a retirar
		subs r4,r7		@resta del acumulador
		ldrh r7,[r6],2	@carga el valor a sumar
		adds r4,r7		@suma el valor en el acumulador

		sdiv r3,r4,r9
		strh r3,[r1],2

		subs r2,1
		bne .asm_filtro_for
		pop {r4-r9}
		bx lr
