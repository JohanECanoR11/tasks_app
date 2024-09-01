import express from "express";
import {
  getTask, shareTask, deleteTask, getTasksByID, createTask, toggleCompleted, getUserByEmail, getUserByID, getSharedTaskByID
} from "./database.js";

import cors from 'cors';

const corsOption = {
  origin: "http://127.0.0.1:5173", // especificar el origen permitido
  methods: ["POST", "GET"], // especificar los métodos permitidos
  credentials: true, // permitir el envío de credenciales (cookies, autenticación)  
};

const app = express();
app.use(express.json());
app.use(cors());

app.get("/tasks/:id", async (req, res) => {
  const tasks = await getTasksByID(req.params.id);
  res.status(200).send(tasks);
});

app.get("/tasks/shared_tasks/:id", async (req, res) => {
  const task = await getSharedTaskByID(req.params.id);
  const author = await getUserByID(task.user_id);
  const shared_with = await getUserByID(task.shared_with_id);
  res.status(200).send({ author, shared_with });
});

app.get("/users/:id", async (req, res) => {
  const user = await getUserByID(req.params.id);
  res.status(200).send(user);
});

app.put("/tasks/:id", async (req, res) => {
  const { value } = req.body;
  const task = await toggleCompleted(req.params.id, value);
  res.status(200).send(task);
});

app.delete("/tasks/:id", async (req, res) => {
  await deleteTask(req.params.id);
  res.send({ message: "Tarea eliminada correctamente" });
});

app.post("/tasks/shared_tasks", async (req, res) => {
  const { task_id, user_id, email } = req.body;
  const userToShare = await getUserByEmail(email);
  const sharedTask = await shareTask(task_id, user_id, userToShare.id);
  res.status(201).send(sharedTask);
});

app.post("/tasks", async (req, res) => {
  const { user_id, title } = req.body;
  const task = await createTask(user_id, title);
  res.status(201).send(task);
});

app.listen(8080, () => {
  console.log("Servidor ejecutándose en el puerto 8080");
});