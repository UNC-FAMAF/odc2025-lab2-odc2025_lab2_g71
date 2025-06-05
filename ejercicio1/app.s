.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGHT,  480
.equ BITS_PER_PIXEL, 32

.equ GPIO_BASE,    0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main

main:
    mov x20, x0 // Guarda la dirección base del framebuffer en x20
    mov x0, x20 // x0 = Dirección base del arreglo
    mov x18, #0 
    
loop1:
    bl dibujo
    
    mov x17, x18
loop0:
    cbz w27, loop1
    cmp x17, x18
    b.ne loop1

InfLoop:
    b InfLoop

pintarPixel:
    cmp x2, SCREEN_WIDTH
    b.hs fin_pintarPixel
    cmp x3, SCREEN_HEIGHT
    b.hs fin_pintarPixel
    mov x9, SCREEN_WIDTH
    mul x9, x9, x3
    add x9, x9, x2
    str w1, [x20, x9, lsl #2]

fin_pintarPixel:
    br lr

pintarLineaVertical:
    stp x3, lr, [sp, #-16]!
loop_pintarLineaVertical:
    cmp x3, x4
    b.gt fin_loop_pintarLineaVertical
    bl pintarPixel
    add x3, x3, #1
    b loop_pintarLineaVertical

fin_loop_pintarLineaVertical:
    ldp x3, lr, [sp], #16
    br lr

pintarLineaHorizontal:
    stp x2, lr, [sp, #-16]!
loop_pintarLineaHorizontal:
    cmp x2, x4
    b.gt fin_loop_pintarLineaHorizontal
    bl pintarPixel
    add x2, x2, #1
    b loop_pintarLineaHorizontal

fin_loop_pintarLineaHorizontal:
    ldp x2, lr, [sp], #16
    br lr

pintarRectangulo:
    stp x3, lr, [sp, #-16]!
loop_pintarRectangulo:
    cmp x3, x5
    b.gt fin_loop_pintarRectangulo
    bl pintarLineaHorizontal
    add x3, x3, #1
    b loop_pintarRectangulo

fin_loop_pintarRectangulo:
    ldp x3, lr, [sp], #16
    br lr

pintarCirculo:
    sub sp, sp, #8
    stur lr, [sp]
    mov x15, x2
    mov x16, x3
    add x10, x2, x6
    add x11, x3, x6
    mul x12, x6, x6
    sub x2, x2, x6

loop0_pintarCirculo:
    cmp x2, x10
    b.gt fin_loop0_pintarCirculo
    sub x3, x11, x6
    sub x3, x3, x6

loop1_pintarCirculo:
    cmp x3, x11
    b.gt fin_loop1_pintarCirculo
    sub x13, x2, x15
    smull x13, w13, w13
    sub x14, x3, x16
    smaddl x13, w14, w14, x13
    cmp x13, x12
    b.gt fi_pintarCirculo
    bl pintarPixel

fi_pintarCirculo:
    add x3, x3, #1
    b loop1_pintarCirculo

fin_loop1_pintarCirculo:
    add x2, x2, #1
    b loop0_pintarCirculo

fin_loop0_pintarCirculo:
    mov x2, x15
    mov x3, x16
    ldur lr, [sp]
    add sp, sp, #8
    br lr

dibujo:

    // Dibuja un rectángulo (fondo)
    movz w1, 0xFFa0, lsl 16
	movk w1, 0x96b2, lsl 00 // Color fondo violeta
    mov x2, #0 
    mov x3, #0 
    mov x4, #SCREEN_WIDTH 
    mov x5, #SCREEN_HEIGHT 
    bl pintarRectangulo

// Primero dibujamos el "ODC 2025" arriba a la izquierda

    // Dibuja un rectángulo ("O" parte izquierda)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, # 1
    mov x3, # 1
    mov x4, # 3
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("O" parte derecha)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, # 9
    mov x3, # 1
    mov x4, # 11
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("O" parte superior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, # 1
    mov x3, # 0
    mov x4, # 11
    mov x5, #2
    bl pintarRectangulo

    // Dibuja un rectángulo ("O" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, # 1
    mov x3, # 10
    mov x4, # 11
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" parte izquierda)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, #14
    mov x3, #0
    mov x4, #16
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #16
    mov x3, #0
    mov x4, #18
    mov x5, #2
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #19
    mov x3, #1
    mov x4, #20
    mov x5, #3
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #21
    mov x3, #2
    mov x4, #22
    mov x5, #4
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #23
    mov x3, #3
    mov x4, #24
    mov x5, #7
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #21
    mov x3, #7
    mov x4, #22
    mov x5, #9
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #19
    mov x3, #8
    mov x4, #20
    mov x5, #10
    bl pintarRectangulo

    // Dibuja un rectángulo ("D" contorno derecho)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de letra
    mov x2, #16
    mov x3, #10
    mov x4, #18
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("C" parte izquierda)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, #26
    mov x3, #0
    mov x4, #28
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("C" parte superior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, #26
    mov x3, #0
    mov x4, #34
    mov x5, #2
    bl pintarRectangulo

    // Dibuja un rectángulo ("C" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color de letra
    mov x2, #26
    mov x3, #10
    mov x4, #34
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #44
    mov x3, #11
    mov x4, #52
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #44
    mov x3, #0
    mov x4, #45
    mov x5, #4
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #44
    mov x3, #0
    mov x4, #52
    mov x5, #1
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #51
    mov x3, #0
    mov x4, #52
    mov x5, #3
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #50
    mov x3, #3
    mov x4, #51
    mov x5, #4
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #49
    mov x3, #4
    mov x4, #50
    mov x5, #5
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #48
    mov x3, #5
    mov x4, #49
    mov x5, #6
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #47
    mov x3, #6
    mov x4, #48
    mov x5, #7
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #46
    mov x3, #7
    mov x4, #47
    mov x5, #8
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, #45
    mov x3, #8
    mov x4, #46
    mov x5, #9
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #44
    mov x3, #9
    mov x4, #45
    mov x5, #10
    bl pintarRectangulo

    // Dibuja un rectángulo ("0" parte izquierda)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, # 61
    mov x3, # 1
    mov x4, # 62
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("0" parte derecha)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, # 54
    mov x3, # 1
    mov x4, # 55
    mov x5, #12
    bl pintarRectangulo

    // Dibuja un rectángulo ("0" parte superior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, # 54
    mov x3, # 0
    mov x4, # 62
    mov x5, #1
    bl pintarRectangulo

    // Dibuja un rectángulo ("0" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, # 54
    mov x3, # 11
    mov x4, # 62
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #64
    mov x3, #11
    mov x4, #72
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #64
    mov x3, #0
    mov x4, #65
    mov x5, #4
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, #64
    mov x3, #0
    mov x4, #72
    mov x5, #1
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, #71
    mov x3, #0
    mov x4, #72
    mov x5, #3
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #70
    mov x3, #3
    mov x4, #71
    mov x5, #4
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #69
    mov x3, #4
    mov x4, #70
    mov x5, #5
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, #68
    mov x3, #5
    mov x4, #69
    mov x5, #6
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color del Numero
    mov x2, #67
    mov x3, #6
    mov x4, #68
    mov x5, #7
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #66
    mov x3, #7
    mov x4, #67
    mov x5, #8
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #65
    mov x3, #8
    mov x4, #66
    mov x5, #9
    bl pintarRectangulo

// Dibuja un rectángulo ("2" parte del contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #64
    mov x3, #9
    mov x4, #65
    mov x5, #10
    bl pintarRectangulo

// Dibuja un rectángulo ("5" parte inferior)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #74
    mov x3, #11
    mov x4, #82
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("5" contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #81
    mov x3, #6
    mov x4, #82
    mov x5, #12
    bl pintarRectangulo

// Dibuja un rectángulo ("5" contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #74
    mov x3, #5
    mov x4, #82
    mov x5, #6
    bl pintarRectangulo

// Dibuja un rectángulo ("5" contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #74
    mov x3, #0
    mov x4, #75
    mov x5, #6
    bl pintarRectangulo

// Dibuja un rectángulo ("5" contorno)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 //  Color del Numero
    mov x2, #74
    mov x3, #0
    mov x4, #82
    mov x5, #1
    bl pintarRectangulo

// Ahora dibujamos una persona
// Arrancamos con el pelo para que no tape la cara

    // Dibuja un círculo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #330
    mov x3, #88
    mov x6, #66
    bl pintarCirculo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #251 
    mov x3, #53 
    mov x4, #272 
    mov x5, #134 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo) 
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #245 
    mov x3, #97 
    mov x4, #251 
    mov x5, #141 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #383 
    mov x3, #47 
    mov x4, #395 
    mov x5, #146 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #395 
    mov x3, #72
    mov x4, #401 
    mov x5, #122 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #295 
    mov x3, #21
    mov x4, #364 
    mov x5, #28 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #289 
    mov x3, #28
    mov x4, #376 
    mov x5, #34 
    bl pintarRectangulo

    // Dibuja un rectángulo (pelo)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color pelo
    mov x2, #282 
    mov x3, #34
    mov x4, #383 
    mov x5, #47 
    bl pintarRectangulo

 // Dibuja un rectángulo (cara)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #264 
    mov x3, #121 
    mov x4, #357 
    mov x5, #321 
    bl pintarRectangulo

    // Dibuja un rectángulo (cara)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #276 
    mov x3, #103 
    mov x4, #357 
    mov x5, #121 
    bl pintarRectangulo

   // Dibuja un círculo (cara, la frente)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #333 
    mov x3, #123
    mov x6, #47 
    bl pintarCirculo

    // Dibuja un círculo (oreja 1)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #267 
    mov x3, #152
    mov x6, #23 
    bl pintarCirculo

    // Dibuja un rectángulo (cara)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #357 
    mov x3, #102 
    mov x4, #382 
    mov x5, #184 
    bl pintarRectangulo

    // Dibuja un rectángulo (cara)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #357 
    mov x3, #102 
    mov x4, #382
    mov x5, #190 
    bl pintarRectangulo

    // Dibuja un rectángulo (cara)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #357 
    mov x3, #102 
    mov x4, #375
    mov x5, #200
    bl pintarRectangulo

    // Dibuja un rectángulo (oreja 2)
    movz w1, 0xFFa1, lsl 16
	movk w1, 0x657e, lsl 00 // Color piel
    mov x2, #383 
    mov x3, #140
    mov x4, #389 
    mov x5, #177 
    bl pintarRectangulo

    // Dibuja un rectángulo (ceja derecha)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color cejas
    mov x2, #289
    mov x3, #115
    mov x4, #314 
    mov x5, #130
    bl pintarRectangulo

  // Dibuja un rectángulo (esclerótica derecha)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de esclerótica
    mov x2, #289
    mov x3, #121
    mov x4, #314 
    mov x5, #134 
    bl pintarRectangulo

    // Dibuja un rectángulo (pupila y iris derecha)
 movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color de pupila y iris
    mov x2, #297
    mov x3, #124
    mov x4, #305
    mov x5, #131
    bl pintarRectangulo


    // Dibuja un rectángulo (ceja izquierda)
    movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color Ceja
    mov x2, #335
    mov x3, #115
    mov x4, #360
    mov x5, #120
    bl pintarRectangulo

    // Dibuja un rectángulo (esclerótica izquierda)
    movz w1, 0xFFFF, lsl 16
	movk w1, 0xFFFF, lsl 00 // Color de esclerótica
    mov x2, #335
    mov x3, #121
    mov x4, #360
    mov x5, #134
    bl pintarRectangulo

    // Dibuja un rectángulo (pupila y iris izquierda)
 movz w1, 0x0000, lsl 16
	movk w1, 0x0000, lsl 00 // Color de pupila y iris
    mov x2, #343
    mov x3, #124
    mov x4, #351
    mov x5, #131
    bl pintarRectangulo

    // Dibuja un rectángulo (boca arriba)
  movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color de los labios
    mov x2, #301
    mov x3, #191
    mov x4, #339
    mov x5, #196
    bl pintarRectangulo

    // Dibuja un rectángulo (boca abajo)
    movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color de los labios
    mov x2, #305
    mov x3, #197
    mov x4, #335
    mov x5, #205
    bl pintarRectangulo

    // Dibuja un rectángulo (nariz abajo izq)
    movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color claro piel
    mov x2, #314
    mov x3, #153
    mov x4, #332
    mov x5, #165
    bl pintarRectangulo

    // Dibuja un rectángulo (nariz abajo der)
    movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color claro piel
    mov x2, #333
    mov x3, #161
    mov x4, #337
    mov x5, #165
    bl pintarRectangulo

    // Dibuja un rectángulo (nariz arriba der)
    movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color claro piel
    mov x2, #326
    mov x3, #146
    mov x4, #332
    mov x5, #152
    bl pintarRectangulo

    // Dibuja un rectángulo (nariz arriba medio)
    movz w1, 0xFFB8, lsl 16
	movk w1, 0x7CA0, lsl 00 // Color claro piel
    mov x2, #320
    mov x3, #140
    mov x4, #326
    mov x5, #152
    bl pintarRectangulo

    // Dibuja un rectángulo (saco izq)
    movz w1, 0x0000, lsl 16
    movk w1, 0x0020, lsl 00 // Color oscuro del saco
    mov x2, #147
    mov x3, #280 
    mov x4, #279 
    mov x5, #SCREEN_HEIGHT 
    bl pintarRectangulo

    // Dibuja un rectángulo (saco der)
    movz w1, 0x0000, lsl 16
    movk w1, 0x0020, lsl 00 // Color oscuro del saco
    mov x2, #350
    mov x3, #280
    mov x4, #482 
    mov x5, #SCREEN_HEIGHT 
    bl pintarRectangulo


    // Dibuja un rectángulo (camisa)
    movz w1, 0xFF9d, lsl 16
    movk w1, 0x9Faa, lsl 00 // Color camisa
    mov x2, #270 
    mov x3, #280 
    mov x4, #349 
    mov x5, #SCREEN_HEIGHT 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #243 
    mov x3, #140 
    mov x4, #249 
    mov x5, #165 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #250 
    mov x3, #166 
    mov x4, #256 
    mov x5, #172 
    bl pintarRectangulo
    
// Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #257 
    mov x3, #173 
    mov x4, #263 
    mov x5, #179 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #264 
    mov x3, #180 
    mov x4, #270 
    mov x5, #186 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #271 
    mov x3, #192 
    mov x4, #277 
    mov x5, #208 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #278 
    mov x3, #209 
    mov x4, #284 
    mov x5, #215 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #285 
    mov x3, #216 
    mov x4, #291 
    mov x5, #222 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #293 
    mov x3, #223 
    mov x4, #299 
    mov x5, #229 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #300 
    mov x3, #230 
    mov x4, #312 
    mov x5, #236 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #313 
    mov x3, #237 
    mov x4, #330 
    mov x5, #243 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #331 
    mov x3, #230 
    mov x4, #337 
    mov x5, #236 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #338 
    mov x3, #223 
    mov x4, #350 
    mov x5, #229 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #351 
    mov x3, #216 
    mov x4, #357 
    mov x5, #222 
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #358 
    mov x3, #200
    mov x4, #364
    mov x5, #215
    bl pintarRectangulo

    // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #364 
    mov x3, #194
    mov x4, #375
    mov x5, #200
    bl pintarRectangulo

   // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #376 
    mov x3, #180
    mov x4, #382
    mov x5, #193
    bl pintarRectangulo

   // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #383 
    mov x3, #173
    mov x4, #389
    mov x5, #179
    bl pintarRectangulo

   // Dibuja un rectángulo (contorno cara)
    movz w1, 0xFF52, lsl 16
	movk w1, 0x0B09, lsl 00 // Color contorno piel
    mov x2, #390 
    mov x3, #140
    mov x4, #396
    mov x5, #172
    bl pintarRectangulo

// Dejar un renglon para que corra con Shift + Enter



