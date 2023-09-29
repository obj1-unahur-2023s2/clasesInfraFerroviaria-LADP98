class Locomotora {
	const property peso
	const property arrastre
	const property velocidadMax
	
	method esEficiente() = 5 * peso <= arrastre
	method pesoMaximo() = peso
}