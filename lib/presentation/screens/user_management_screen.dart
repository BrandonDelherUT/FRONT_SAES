import 'package:flutter/material.dart';
import 'employee_register_screen.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child :Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Usuario'),
              onPressed: () {
                //action for add user
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeRegistrationScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded( //inicia la tabla
              child: ListView(
                children: [
                  DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Usuario')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: [
                        DataRow(
                            cells: [
                              const DataCell(Text('1')),
                              const DataCell(Text('John Doe')),
                              const DataCell(Text('johndoe')),
                              const DataCell(Text('johndoe@example.com')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                        onPressed: () {},
                                        ),
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        ),
                      ],

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}