const express = require("express");
const router = express.Router();
const supabase = require("../db/supabase");

// ─── GET /api/notes ───────────────────────────────────────
// Get all notes
router.get("/", async (req, res) => {
  try {
    const { data, error } = await supabase
      .from("notes")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) throw error;
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ─── GET /api/notes/:id ───────────────────────────────────
// Get a single note
router.get("/:id", async (req, res) => {
  try {
    const { data, error } = await supabase
      .from("notes")
      .select("*")
      .eq("id", req.params.id)
      .single();

    if (error) throw error;
    if (!data) return res.status(404).json({ error: "Note not found" });

    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ─── POST /api/notes ──────────────────────────────────────
// Create a new note
router.post("/", async (req, res) => {
  const { title, content } = req.body;

  if (!title) {
    return res.status(400).json({ error: "Title is required" });
  }

  try {
    const { data, error } = await supabase
      .from("notes")
      .insert([{ title, content }])
      .select()
      .single();

    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ─── PUT /api/notes/:id ───────────────────────────────────
// Update a note
router.put("/:id", async (req, res) => {
  const { title, content } = req.body;

  try {
    const { data, error } = await supabase
      .from("notes")
      .update({ title, content })
      .eq("id", req.params.id)
      .select()
      .single();

    if (error) throw error;
    if (!data) return res.status(404).json({ error: "Note not found" });

    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ─── DELETE /api/notes/:id ────────────────────────────────
// Delete a note
router.delete("/:id", async (req, res) => {
  try {
    const { error } = await supabase
      .from("notes")
      .delete()
      .eq("id", req.params.id);

    if (error) throw error;
    res.status(200).json({ message: "Note deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;