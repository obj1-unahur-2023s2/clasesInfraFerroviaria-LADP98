class Deposito {
	const formaciones = []
	const locomotoras = []
	
	method agregarFormacion(unaFormacion) {formaciones.add(unaFormacion)}
	method agregarFormaciones(listaFormaciones) {formaciones.addAll(listaFormaciones)}
	method retirarFormacion(unaFormacion) {formaciones.remove(unaFormacion)}
	method agregarLocomotora(unaLocomotora) {locomotoras.add(unaLocomotora)}
	method retirarLocomotora(unaLocomotora) {locomotoras.remove(unaLocomotora)}
	
	method vagonesMasPesados() {return
		formaciones.map({f=>f.vagonMasPesado()}).asSet()
	}
	
	method necesitaConductorExperimentado() {
		return formaciones.any({f=>f.esCompleja()})
	}
	
	method hayLocomotoraConArrastre(kilos) = locomotoras.any({l=>l.arrastre()>=kilos})
	method locomotoraQueArrastraMasDe(kilos) = locomotoras.find({l=>l.arrastre()>=kilos})
	
	method agregarLocomotoraA(unaFormacion) {
		const kilosFaltantes = unaFormacion.kilosDeEmpujeFaltante()
		if(!unaFormacion.puedeMoverse() && 
			self.hayLocomotoraConArrastre(kilosFaltantes)
		){
			const locomElegida = self.locomotoraQueArrastraMasDe(kilosFaltantes)
			unaFormacion.agregarLocomotora(locomElegida)
			self.retirarLocomotora(locomElegida)
		 }
	}
}