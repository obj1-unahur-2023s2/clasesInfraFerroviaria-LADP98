# Infraestructura ferroviaria
 
Una administradora ferroviaria necesita una aplicación que le ayude a manejar las formaciones que tiene disponibles en distintos depósitos.

Una **formación** es lo que habitualmente llamamos "un tren", tiene una o varias **locomotoras**, y uno o varios **vagones**.   
En cada **depósito** hay: formaciones ya armadas, y locomotoras sueltas que pueden ser agregadas a una formación.

Vamos a resolverlo de a poco.


## Etapa 1 - vagones

En esta etapa vamos a considerar los **vagones** de cada formación.   
En el modelo debemos incluir: vagones de pasajeros, vagones de carga, y vagones dormitorio.


### Vagones de pasajeros
Para definir un vagón de pasajeros, debemos indicar el largo y el ancho medidos en metros, si tiene o no _baños_, y si está o no _ordenado_. 

A partir de estos valores, la _cantidad de pasajeros_ que puede transportar un vagón se calcula de esta forma:
- si el ancho es hasta 3 metros, entran 8 pasajeros por cada metro de largo.
- si el ancho es de más de 3 metros, entran 10 pasajeros por cada metro de largo.

Si el vagón no está ordenado, restar 15 pasajeros.

P.ej.:
- un vagón de pasajeros de 10 metros de largo y 2 de ancho puede llevar hasta 80 pasajeros si está ordenado, 65 pasajeros si no.
- otro vagón, también de 10 metros de largo, pero de 4 metros de ancho, puede llevar hasta 100 pasajeros si está ordenado, 85 pasajeros si no. 

La cantidad máxima de _carga_ que puede llevar un vagón de pasajeros depende de si tiene o no baños:
- si tiene baños, entonces puede llevar hasta 300 kilos.
- si no, hasta 800 kilos.

El _peso máximo_ de un vagón de pasajeros se calcula así: 2000 kilos, más 80 kilos por cada pasajero, más el máximo de carga que puede llevar.
 

### Vagones de carga
Para cada vagón de carga se indica su carga máxima ideal, y cuántas maderas tiene sueltas.  
Un vagón de carga puede llevar hasta su carga máxima ideal, menos 400 kilos por cada madera suelta.

P.ej. un vagón de carga con carga máxima ideal 8000 kilos con 5 maderas sueltas puede llevar hasta 6000 kilos; si cambiamos la cantidad de maderas sueltas a 2, entonces puede llevar hasta 7200 kilos.

No puede llevar pasajeros, y no tiene baños.

Su _peso máximo_ es de 1500 kilos más el máximo de carga que puede llevar.


### Vagones dormitorio
Para cada vagón dormitorio se indica: cuántos compartimientos tiene, y cuántas camas se ponen en cada compartimiento.

La _cantidad máxima de pasajeros_ es el resultado de multiplicar cantidad de compartimientos por cantidad de camas por compartimiento.
P.ej. un vagón dormitorio con 12 compartimientos de 4 camas cada uno, puede llevar hasta 48 pasajeros.

Todos los vagones dormitorio _tienen baños_, y pueden llevar hasta 1200 kilos de carga cada uno.

Su _peso máximo_ se calcula así: 4000 kilos, más 80 kilos por cada pasajero, más el máximo de carga que puede llevar.


### Requerimientos - información sobre una formación
A partir del modelo que se construya se tiene que poder saber fácilmente, para una formación:
- hasta cuántos pasajeros puede llevar.
- cuántos _vagones populares_ tiene. Un vagón es popular si puede llevar más de 50 pasajeros.
- si es una _formación carguera_, o sea, si todos los vagones pueden transportar al menos 1000 kilos de carga.
- cuál es la _dispersión de pesos_, que es el resultado de esta cuenta: peso máximo del vagón más pesado - peso máximo del vagón más liviano. 
  P.ej. si una formación tiene 4 vagones, cuyos pesos máximos son 9000, 12000, 3500 y 8000, entonces su dispersión de pesos es 12000 - 3500 = 8500.
- cuántos baños tiene una formación, que se obtiene como la cantidad de vagones que tienen baños (se supone que cada vagón que tiene baños, tiene uno solo).

Además, se tiene que poder hacer _mantenimiento_ de una formación, que implica hacer mantenimiento de cada vagón, de acuerdo a estas definiciones
- hacer mantenimiento de un vagón de pasajeros quiere decir ordenarlo; si no estaba ordenado pasa a estar ordenado, si ya estaba ordenado no cambia nada.
- hacer mantenimiento de un vagón de carga es arreglar dos de las maderas que tiene sueltas: si tenía 5 pasa a 3, si tenía 1 pasa a 0, si tenía 0 queda en 0.
- hacer mantenimiento de un vagón dormitorio no tiene ningún efecto que interese para este modelo. 

#### Un poco más salados
Poder pedirle a una formación lo siguiente:
- si está _equilbrada en pasajeros_, o sea: si considerando sólo los vagones que llevan pasajeros, la diferencia entre el que más lleva y el que menos no supera los 20 pasajeros.
- si está _organizada_, o sea: adelante los vagones que llevan pasajeros, y atrás los que no. Para esto, los vagones se tienen que almacenar en una lista. Si agregamos dos vagones que llevan pasajeros, uno que no, y después uno que sí, entonces la formación no está organizada.  
¡Ojo! si todos los vagones de la formación llevan pasajeros, o si ninguno lleva, entonces la formación **sí** se considera organizada.

## Tests etapa 1

Vamos a verificar el comportamiento de dos formaciones, y de sus vagones.

### Primera formación

Está compuesta por cuatro vagones, en este orden:
1. un vagón de pasajeros de 10 metros de largo por 4 de ancho, ordenado, con baño.
1. un vagón de pasajeros de 7 metros de largo por 2 de ancho, no ordenado, sin baño.
1. un vagón de carga de 6800 kg de carga máxima ideal, y con 5 maderas sueltas.
1. un vagón dormitorio de 8 compartimientos y 3 camas por compartimiento.

Esta tabla indica la respuesta de cada vagón a distintos pedidos  

| Vagón | cant. pasajeros | peso máximo | carga máxima | tiene baño |  
| --- | --- |  --- |  --- |  --- | 
| 1 | 100 | 10300 | 300 | sí |
| 2 | 41 | 6080 | 800 | no |
| 3 | 0 | 6300 | 4800 | no |
| 4 | 24 | 7120 | 1200 | sí |

Indicamos los resultados esperados para el tren, antes y después de hacer mantenimiento.

| | antes  | después |
| --- | --- |  --- |
| **pasajeros** | 165 | 180 |
| **vagones populares** | 1 | 2 |
| **es carguero** | no | no |
| **dispersión de pesos** | 4220 | 3200 |
| **baños** | 2 | 2 |

Por qué las diferencias de valores después de hacer mantenimiento:  
- _pasajeros_: el vagón 2 pasa a estar ordenado, lo que aumenta en 15 su cantidad de pasajeros.
- _vagones populares_: por lo recién dicho, el vagón 2 pasa de 41 a 56 pasajeros, por lo que es considerado popular.
- _dispersión de pesos_: el vagón 2 pasa de 6080 a 7280 kilos. Por su parte, el vagón 3 pasa de 6300 a 7100 kilos. Ahora el vagón más liviano es el 3.

### Segunda formación

Esta incluye: 
1. un vagón de carga, con 8000 kg de carga máxima ideal, y una madera suelta.
1. un vagón dormitorio, de 15 compartimientos con 4 camas cada uno.

Indicamos los resultados esperados para el tren, antes y después de hacer mantenimiento.

| | antes  | después |
| --- | --- |  --- |
| **pasajeros** | 60 | 60 |
| **vagones populares** | 1 | 1 |
| **es carguero** | sí | sí |
| **dispersión de pesos** | 900 | 500 |
| **baños** | 1 | 1 |

Por qué cambia la dispersión de pesos: el vagón de carga aumenta su peso máximo de 9100 a 9500 kilos, al pasar de una madera suelta a ninguna. El peso máximo del vagón dormitorio es 10000, antes y después del mantenimiento.

<br>

## Etapa 2 - locomotoras

Agregar al modelo las **locomotoras**. De cada locomotora debe indicarse: su peso, hasta cuánto peso puede arrastar, y su velocidad máxima. Decimos que una locomotora es _eficiente_ si puede arrastrar, al menos, cinco veces su peso. P.ej. una locomotora que pesa 1000 kilos y puede arrastar hasta 7000 es eficiente; si puede arrastrar hasta 3000 entonces no es eficiente.

Ahora una formación incluye locomotoras (pueden ser varias), además de vagones. 

Con el modelo ampliado, tiene que poder obtenerse fácilmente, para una formación:
- su _velocidad máxima_ , que es el mínimo entre las velocidades máximas de las locomotoras.
- Si es _eficiente_; o sea, si todas sus locomotoras lo son.
- Si _puede moverse_. 
  Una formación puede moverse si la suma del arrastre de cada una de sus locomotoras, es mayor o igual al _peso máximo_ de la formación, que es: peso de las locomotoras + peso máximo de los vagones.
- Cuántos _kilos de empuje le faltan_ para poder moverse, que es: 0 si ya se puede mover, y si no, el resultado de: peso máximo - suma de arrastre de cada locomotora.

P.ej. si una formación tiene una locomotora que pesa 1000 kilos y arrastra hasta 30000, y cuatro vagones, de 6000 kilos de peso máximo cada uno, entonces sí puede moverse, porque su peso máximo es 25000.  
Si agregamos dos vagones más de 6000 kilos, llevamos el peso máximo a 37000. Ahora la formación no puede moverse y le faltan 7000 kilos de empuje.


## Tests etapa 2

Consideremos la primera formación de los tests de la etapa 1, sin hacerle mantenimiento. Contando sólo los vagones, el peso máximo es 29800.

Definamos dos locomotoras:
1. Una locomotora de peso 3000 kg y arrastre 20000 kg.
2. Una locomotora de peso 5000 kg y arrastre 22000 kg.

Si a la formación le agregamos la locomotora 1, entonces, es eficiente, no puede moverse, y le faltan 12800 kg de empuje.  

Si a la misma formación le agregamos _también_ la locomotora 2, entonces no es eficiente, sí puede moverse, y le faltan 0 kilos de empuje.


## Etapa 3 - depósitos
Agregar al modelo los **depósitos ferroviarios**. En cada depósito hay: formaciones ya armadas, y locomotoras sueltas.

Se pide resolver lo siguiente:
- Dado un depósito, obtener el conjunto formado por el vagón más pesado de cada formación; se espera un conjunto de vagones. 
- Saber si un depósito _necesita un conductor experimentado_.  
  Un depósito necesita un conductor experimentado si alguna de sus formaciones es compleja.
  Una formación es compleja si: tiene más de 8 unidades (sumando locomotoras y vagones), o el peso máximo es de más de 80000 kg.
- Que un depósito pueda agregar una locomotora a una formación determinada, de forma tal que la formación pueda moverse.   
  - Si la formación ya puede moverse, entonces no se hace nada.  
  - Si no, se le agrega una locomotora suelta del depósito cuyo arrastre sea mayor o igual a los kilos de empuje que le faltan a la formación. Si no hay ninguna locomotora suelta que cumpla esta condición, no se hace nada.

