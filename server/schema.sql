CREATE DATABASE tasks_app_db;

USE tasks_app_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255)
);

CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  completed BOOLEAN DEFAULT false,
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE shared_tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT,
  user_id INT,
  shared_with_id INT,
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (shared_with_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insertar dos usuarios en la tabla de usuarios
INSERT INTO users (name, email, password) VALUES ('Johan Cano', 'johan@email.com', 'contraseña1');
INSERT INTO users (name, email, password) VALUES ('Eduardo Ruiz', 'eduardo@email.com', 'contraseña2');

-- Insertar las tareas en la tabla de tareas, asociado con el primer usuario
INSERT INTO tasks (title, user_id)
VALUES
("🏃Salir a correr por la mañana🌄", 1),
("💻Trabajar en la presentación del proyecto💼", 1),
("🛒Ir de compras🛍️", 1),
("📚Leer 30 páginas del libro📖", 1),
("🚲Ir en bici al parque🌳", 1),
("🍝Preparar la cena🍴", 1),
("🧘Practicar yoga💆", 1),
("🎧Escuchar un podcast🎤", 1),
("🧹Limpiar la casa🧼", 1),
("🛌Dormir 8 horas💤", 1);

-- Compartir la tarea 1 del primer usuario al segundo
INSERT INTO shared_tasks (task_id, user_id, shared_with_id)
VALUES (1, 1, 2);

-- Obtener las tareas incluidas en shared_tasks por id
SELECT tasks.*, shared_tasks.shared_with_id
FROM tasks
LEFT JOIN shared_tasks ON tasks.id = shared_tasks.task_id
WHERE tasks.user_id = [user_id] OR shared_tasks.shared_with_id = [user_id];