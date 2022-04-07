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

