/*
 * adm_C_functions.c
 *
 *  Created on: 7 abr. 2022
 *      Author: Guillermo
 */

#include "adm_functions.h"

void zeros (uint32_t * vector, uint32_t longitud)
{	int i = 0;

	for(i=0 ; i<longitud ; i++){
		vector[i] = 0;
	}
}

void productoEscalar32 (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
{
	int i = 0;

	for(i=0 ; i<longitud ; i++){
		vectorOut[i] = escalar*vectorIn[i];
	}
}

void productoEscalar16 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
{
	int i = 0;

	for(i=0 ; i<longitud ; i++){
		vectorOut[i] = escalar*vectorIn[i];
	}
}

void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
{
	int i = 0;

	escalar &= 0x0FFF;
	for(i=0 ; i<longitud ; i++){
		vectorIn[i] &= 0x0FFF;
		vectorOut[i] = escalar*vectorIn[i];
		vectorOut[i] &= 0x0FFF;
	}
}
/* Función ejercicio 5 */
#define M 3 // Longitud de la ventana

void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn)
{
	int n=0 , k=0, pos=0,suma=0;

    for(n=0 ; n < longitudVectorIn; n++ )
    {
        suma = 0;
        for(k=n ; k < n+M ; k++)
        {
            pos=k;
        	if(pos > longitudVectorIn-1)
        	{
            	pos -= longitudVectorIn;
            }
            suma += vectorIn[pos];
        }
        vectorOut[n]= suma/M;
    }
}

/* Función ejercicio 6 */
void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud)
{
	uint32_t i=0;
	for(i=0 ; i<longitud ; i++ ){
		vectorOut[i]= vectorIn[i]>>16;
	}
}

/* Función ejercicio 7 */
int32_t max (int32_t * vectorIn, uint32_t longitud)
{
	int32_t i=0,aux=vectorIn[0];

	for(i=0 ; i<longitud ; i++ ){
		if(vectorIn[i]>aux){
			aux=vectorIn[i];
		}
	}
	return aux;
}

/* Función ejercicio 8 */
void downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N)
{
	uint32_t n = 0;

	while(longitud--)
	{
		if(n%N != 0){
			*vectorOut++ = *vectorIn++;
		}else {
			vectorIn++;
		}
		n++;
	}
}

/* Función ejercicio 9 */
void invertir (uint16_t * vector, uint32_t longitud)
{
	uint16_t aux;

	for(int i=0 ; i<longitud/2 ; i++){
		aux = vector[i];
		vector[i] = vector[longitud-1-i];
		vector[longitud-1-i]=aux;
	}
}
