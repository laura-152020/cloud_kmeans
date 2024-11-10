import 'package:flutter/material.dart';
import 'dart:math';

class WordCloudPage extends StatefulWidget {
  @override
  _WordCloudPageState createState() => _WordCloudPageState();
}

class _WordCloudPageState extends State<WordCloudPage> {
  // Lista de palabras para la nube
  final List<String> words = [
    'Flutter', 'K-means', 'Machine Learning', 'Nube de palabras', 'Algoritmo', 'Cluster', 'Datos', 'Modelo'
  ];
  
  // Almacenar resultados de K-means (simulados)
  Map<String, int> kmeansResults = {};

  @override
  void initState() {
    super.initState();
    performKMeansClustering();
  }

  // Función para simular el algoritmo K-means
  void performKMeansClustering() {
    Random random = Random();
    for (var word in words) {
      // Asigna aleatoriamente una palabra a uno de los 3 clusters
      kmeansResults[word] = random.nextInt(3); // Clusters: 0, 1, 2
    }
  }

  // Genera colores aleatorios para cada palabra de acuerdo a su cluster
  Color getColorForCluster(int cluster) {
    switch (cluster) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-means & Nube de Palabras'),
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: words.map((word) {
            int cluster = kmeansResults[word] ?? 0;
            Color color = getColorForCluster(cluster);

            return Text(
              word,
              style: TextStyle(
                fontSize: 20 + cluster * 5.0, // Tamaño de letra según el cluster
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
