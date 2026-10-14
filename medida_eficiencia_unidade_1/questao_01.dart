// Questão 01
// Dado o seguinte mapa de preços de bolos: const boloPrecos = {'ovos' : 5,5, 'chocolate' : 7,5, 'cenoura' : 6,5, }; Escreva um programa em Dart para calcular o total para um determinado pedido. Por exemplo, dada a ordem const ordem = ['ovos', 'chocolate']; o programa deve imprimir -> Total = 13.0. OBS.: Se um bolo não estiver no cardápio, o programa deve imprimir algo assim -> limão não está no cardápio.

const Map<String, double> boloPrecos = {
  'ovos': 5.5,
  'chocolate': 7.5,
  'cenoura': 6.5,
};

double calcularPedido(List<String> pedido) {
  return pedido.fold(0.0, (soma, sabor) {
    final preco = boloPrecos[sabor];
    if (preco == null) {
      print('$sabor não está no cardápio');
      return soma;
    }
    return soma + preco;
  });
}

void main() {
  const ordem = ['ovos', 'chocolate'];
  final total = calcularPedido(ordem);
  print('Total = $total');
}
