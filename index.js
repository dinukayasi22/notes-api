const express = require("express");
const cors = require("cors");
require("dotenv").config();

const notesRouter = require("./routes/notes");

const app = express();
const PORT = process.env.PORT || 5000;

// ─── Middleware ───────────────────────────────────────────
app.use(cors({ origin: process.env.CORS_ORIGIN || "*" }));
app.use(express.json());

// ─── Routes ──────────────────────────────────────────────
app.use("/api/notes", notesRouter);

// ─── Health Check ─────────────────────────────────────────
app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok", timestamp: new Date().toISOString() });
});

// ─── 404 Handler ──────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: "Route not found" });
});

// ─── Start Server ─────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Notes API running on http://localhost:${PORT}`);
});