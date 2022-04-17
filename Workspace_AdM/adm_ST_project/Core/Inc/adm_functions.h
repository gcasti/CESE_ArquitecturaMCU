/*
 * adm_C_functions.h
 *
 *  Created on: 7 abr. 2022
 *      Author: Guillermo Castiglioni
 */

#ifndef INC_ADM_FUNCTIONS_H_
#define INC_ADM_FUNCTIONS_H_

#include <stdint.h>

/* Función ejercicio 1 */
void zeros (uint32_t * vector, uint32_t longitud);

/* Función ejercicio 2 */
void productoEscalar32 (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);

/* Función ejercicio 3 */
void productoEscalar16 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Función ejercicio 4 */
void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Función ejercicio 5 */
void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);

/* Función ejercicio 6 */
void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud);



#endif /* INC_ADM_FUNCTIONS_H_ */
