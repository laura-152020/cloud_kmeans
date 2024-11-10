import 'package:flutter/material.dart';
import 'dart:math';

class WordCloudPage extends StatefulWidget {
  @override
  _WordCloudPageState createState() => _WordCloudPageState();
}

class _WordCloudPageState extends State<WordCloudPage> {
  // Lista de palabras con frecuencias simuladas para la nube de palabras
  final List<Map<String, dynamic>> words = [
    {'word': 'Flutter', 'frequency': 10},
    {'word': 'K-means', 'frequency': 7},
    {'word': 'Machine Learning', 'frequency': 15},
    {'word': 'Nube de palabras', 'frequency': 5},
    {'word': 'Algoritmo', 'frequency': 8},
    {'word': 'Cluster', 'frequency': 12},
    {'word': 'Datos', 'frequency': 9},
    {'word': 'Modelo', 'frequency': 6},
  ];

  // Almacena resultados de K-means
  Map<String, int> kmeansResults = {};

  @override
  void initState() {
    super.initState();
    performKMeansClustering();
  }

  // Simula el algoritmo K-means para asignar palabras a clusters
  void performKMeansClustering() {
    Random random = Random();
    for (var wordData in words) {
      // Asigna aleatoriamente cada palabra a uno de los 3 clusters
      kmeansResults[wordData['word']] = random.nextInt(3); // Clusters: 0, 1, 2
    }
  }

  // Genera colores distintos para cada cluster
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

  // Genera el tamaño de fuente basado en la frecuencia de la palabra
  double getFontSizeForFrequency(int frequency) {
    return 14 + frequency.toDouble(); // Ajusta el tamaño con base en la frecuencia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-means & Word Cloud'),
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: words.map((wordData) {
            String word = wordData['word'];
            int frequency = wordData['frequency'];
            int cluster = kmeansResults[word] ?? 0;
            Color color = getColorForCluster(cluster);

            return Text(
              word,
              style: TextStyle(
                fontSize: getFontSizeForFrequency(frequency),
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
