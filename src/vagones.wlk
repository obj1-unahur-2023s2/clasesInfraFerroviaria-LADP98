class Pasajero {
	const property ancho
	const property largo
	const property tieneBanios
	var property estaOrdenado=true
	
	method cantidadDePasajeros() {
		const pasajeros = if(ancho<=3){8 * largo} else { 10 * largo }
		return if (not estaOrdenado) {0.max(pasajeros - 15) } else { pasajeros}
	}
	
	method pesoMaximo() = 2000 + 80 * self.cantidadDePasajeros() + self.carga()
	method carga()= if(tieneBanios){300}else{800}
	method esPopular() = self.cantidadDePasajeros() > 50
	method recibirMantenimiento() {
		estaOrdenado=true
	}
	method puedeTransportar(unValor) = self.carga() >= unValor
	method esDePasajeros() = self.cantidadDePasajeros() > 0
}

class Carga {
	const property cargaMaximaIdeal
	var property maderasSueltas
	
	method cantidadDePasajeros() = 0
	method pesoMaximo() = 1500 + self.carga() 
	method carga() = 0.max(cargaMaximaIdeal - 400 * maderasSueltas)
	method tieneBanios() = false
	method esPopular() =  self.cantidadDePasajeros() > 50
	method recibirMantenimiento() {
		maderasSueltas = 0.max(maderasSueltas - 2)
	}
	method puedeTransportar(unValor) = self.carga() >= unValor 
	method esDePasajeros() = self.cantidadDePasajeros() > 0
}

class Dormitorio {
	const property cantidadCompartimientos
	var property camasPorCompartimiento
	method cantidadDePasajeros() = cantidadCompartimientos * camasPorCompartimiento
	method pesoMaximo() = 4000 + 80 * self. cantidadDePasajeros() + self.carga()
	method carga() = 1200
	method tieneBanios() = true
	method esPopular() = self.cantidadDePasajeros() > 50
	method recibirMantenimiento() {}
	method puedeTransportar(unValor) = self.carga() >= unValor
	method esDePasajeros() = self.cantidadDePasajeros() > 0
}