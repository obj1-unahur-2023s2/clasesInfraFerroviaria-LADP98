import vagones.*
class Formacion {
	const vagones = new List()
	
	method agregarVagon(unVagon){
		vagones.add(unVagon)
	}
	
	method desarmarFormacion(){
		vagones.clear()
	}
	
	method cuantosPasajerosPuedeLLevar() {
		return vagones.sum {vagon => vagon.cantidadDePasajeros()}
	}
	
	method cantidadVagonesPopulares() {
		return vagones.count { vagon => vagon.esPopular()}
	}
	
	method realizarMantenimientoVagones() {
		vagones.forEach { vagon => vagon.recibirMantenimiento()}
	}
	
	method esFormacionCarguera() {
		return vagones.all  { vagon => vagon.puedeTransportar(1000)}
	}
	
	method dispersionDePesos() {
		const maximo = vagones.max { vagon => vagon.pesoMaximo() }
		const minimo = vagones.min { vagon => vagon.pesoMaximo() }
		return maximo.pesoMaximo() - minimo.pesoMaximo()
	}
	
	method cantidDeBanios() {
		return vagones.count { vagon => vagon.tieneBanios()}
	}
	
	method estaEquilibrada() {
		const pasajeros =self.vagonesSoloDePasajeros() 
		const maximo = pasajeros.max {vagon => vagon.cantidadDePasajeros() }
		const minimo = pasajeros.min {vagon => vagon.cantidadDePasajeros() }
		return maximo.cantidadDePasajeros() - minimo.cantidadDePasajeros() <= 20
	}
	
	method vagonesSoloDePasajeros() {
		return vagones.filter { vagon => vagon.esDePasajeros()}
	}
	
	method estaOrganizada() {
		return not (1..vagones.size()-1).any {
			idx => not vagones.get(idx-1).esDePasajeros() and vagones.get(idx).esDePasajeros()
		}
	}
}