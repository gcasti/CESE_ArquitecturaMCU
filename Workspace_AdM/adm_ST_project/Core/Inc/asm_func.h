#pragma once

#include <stdint.h>


void asm_svc (void);
uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand);

/* Función ejercicio 1 */
void asm_zeros (uint32_t * vector, uint32_t longitud);

/* Función ejercicio 2 */
void asm_productoEscalar32 (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);

/* Función ejercicio 3 */
void asm_productoEscalar16 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Función ejercicio 4 */
void asm_productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Función ejercicio 7 */
int32_t asm_max (int32_t * vectorIn, uint32_t longitud);

/* Función ejercicio 9 */
void asm_invertir (uint16_t * vector, uint32_t longitud);
