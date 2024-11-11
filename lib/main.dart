import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Cloud & K-means Example',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: KMeansExample(),
    );
  }
}

class Practicante {
  final String nombre;
  final double trabajoEnEquipo;
  final double iniciativa;
  final double habilidadesTecnicas;

  Practicante({
    required this.nombre,
    required this.trabajoEnEquipo,
    required this.iniciativa,
    required this.habilidadesTecnicas,
  });

  // Función para convertir un Practicante en un listado de sus calificaciones
  List<double> toList() {
    return [trabajoEnEquipo, iniciativa, habilidadesTecnicas];
  }
}

class KMeansExample extends StatefulWidget {
  @override
  _KMeansExampleState createState() => _KMeansExampleState();
}

class _KMeansExampleState extends State<KMeansExample> {
  List<Practicante> practicantes = [
    Practicante(nombre: 'Juan', trabajoEnEquipo: 7.0, iniciativa: 6.5, habilidadesTecnicas: 8.0),
    Practicante(nombre: 'Ana', trabajoEnEquipo: 8.5, iniciativa: 9.0, habilidadesTecnicas: 7.5),
    Practicante(nombre: 'Carlos', trabajoEnEquipo: 6.0, iniciativa: 6.5, habilidadesTecnicas: 6.0),
    Practicante(nombre: 'Maria', trabajoEnEquipo: 9.0, iniciativa: 8.5, habilidadesTecnicas: 7.0),
    Practicante(nombre: 'Sofia', trabajoEnEquipo: 6.5, iniciativa: 6.0, habilidadesTecnicas: 7.0),
    Practicante(nombre: 'Luis', trabajoEnEquipo: 5.0, iniciativa: 5.5, habilidadesTecnicas: 5.5),
  ];

  // Simulación del K-means (clasificación de los practicantes)
  Map<String, int> kmeansResults = {};

  // Función para realizar la simulación del algoritmo K-means
  void performKMeansClustering(int k) {
    List<List<double>> centroids = _initializeCentroids(k);

    bool hasConverged = false;
    int maxIterations = 100;
    int iteration = 0;

    // Se repite hasta que los centroides no cambien (convergencia)
    while (!hasConverged && iteration < maxIterations) {
      // Asignamos cada practicante al clúster más cercano
      kmeansResults.clear();
      for (var practicante in practicantes) {
        int cluster = _assignCluster(practicante, centroids);
        kmeansResults[practicante.nombre] = cluster;
      }

      // Calculamos los nuevos centroides
      List<List<double>> newCentroids = _calculateNewCentroids(k);
      hasConverged = _checkConvergence(centroids, newCentroids);
      centroids = newCentroids;

      iteration++;
    }
  }

  // Inicializa los centroides aleatoriamente
  List<List<double>> _initializeCentroids(int k) {
    Random random = Random();
    List<List<double>> centroids = [];
    for (int i = 0; i < k; i++) {
      centroids.add([
        random.nextDouble() * 10,  // trabajoEnEquipo
        random.nextDouble() * 10,  // iniciativa
        random.nextDouble() * 10,  // habilidadesTecnicas
      ]);
    }
    return centroids;
  }

  // Asigna un practicante al clúster más cercano
  int _assignCluster(Practicante practicante, List<List<double>> centroids) {
    List<double> practicanteData = practicante.toList();
    double minDistance = double.infinity;
    int closestCluster = 0;

    for (int i = 0; i < centroids.length; i++) {
      double distance = _calculateDistance(practicanteData, centroids[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestCluster = i;
      }
    }
    return closestCluster;
  }

  // Calcula la distancia euclidiana entre dos puntos
  double _calculateDistance(List<double> point1, List<double> point2) {
    double sum = 0;
    for (int i = 0; i < point1.length; i++) {
      sum += pow(point1[i] - point2[i], 2).toDouble();
    }
    return sqrt(sum);
  }

  // Calcula los nuevos centroides basados en la asignación de clúster
  List<List<double>> _calculateNewCentroids(int k) {
    List<List<double>> newCentroids = List.generate(k, (_) => [0.0, 0.0, 0.0]);
    List<int> counts = List.generate(k, (_) => 0);

    for (var practicante in practicantes) {
      int cluster = kmeansResults[practicante.nombre]!;

      List<double> data = practicante.toList();
      for (int i = 0; i < data.length; i++) {
        newCentroids[cluster][i] += data[i];
      }
      counts[cluster]++;
    }

    for (int i = 0; i < k; i++) {
      for (int j = 0; j < newCentroids[i].length; j++) {
        if (counts[i] > 0) {
          newCentroids[i][j] /= counts[i];
        }
      }
    }

    return newCentroids;
  }

  // Verifica si los centroides han cambiado significativamente
  bool _checkConvergence(List<List<double>> oldCentroids, List<List<double>> newCentroids) {
    double threshold = 0.001;
    for (int i = 0; i < oldCentroids.length; i++) {
      double distance = _calculateDistance(oldCentroids[i], newCentroids[i]);
      if (distance > threshold) {
        return false;
      }
    }
    return true;
  }

  // Función para visualizar el resultado de la clasificación
  void displayResults() {
    String results = "Resultados de K-means:\n";
    for (var entry in kmeansResults.entries) {
      results += "${entry.key} -> Clúster ${entry.value}\n";
    }
    setState(() {
      // Actualizar el estado con los resultados para que se muestren en la interfaz
      _displayedResults = results;
    });
  }

  String _displayedResults = ""; // Variable para almacenar los resultados a mostrar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-means Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                performKMeansClustering(2);  // Número de clústeres
                displayResults();
              },
              child: Text('Ejecutar K-means'),
            ),
            SizedBox(height: 20),
            Text(
              _displayedResults,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
