"use strict";

const { app, BrowserWindow, dialog, ipcMain } = require("electron");
const fs = require("node:fs/promises");
const path = require("node:path");

async function readEntry(filePath, rootPath = "") {
  const bytes = await fs.readFile(filePath);
  return {
    name: path.basename(filePath),
    path: filePath,
    rootPath,
    relativePath: rootPath ? path.relative(rootPath, filePath) : path.basename(filePath),
    bytes: Array.from(bytes)
  };
}

async function collectFolderEntries(rootPath) {
  const out = [];
  async function walk(dir) {
    const entries = await fs.readdir(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        await walk(fullPath);
      } else {
        out.push(await readEntry(fullPath, rootPath));
      }
    }
  }
  await walk(rootPath);
  return out;
}

function createWindow() {
  const win = new BrowserWindow({
    width: 1560,
    height: 980,
    minWidth: 1180,
    minHeight: 760,
    backgroundColor: "#141414",
    autoHideMenuBar: true,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      preload: path.join(__dirname, "preload.js")
    }
  });
  win.loadFile(path.join(__dirname, "index.html"));
}

ipcMain.handle("pol2:pick-files", async () => {
  const result = await dialog.showOpenDialog({
    properties: ["openFile", "multiSelections"],
    filters: [
      { name: "Save files", extensions: ["sav", "dat", "bin"] },
      { name: "All files", extensions: ["*"] }
    ]
  });
  if (result.canceled) return [];
  return Promise.all(result.filePaths.map((filePath) => readEntry(filePath)));
});

ipcMain.handle("pol2:pick-folder", async () => {
  const result = await dialog.showOpenDialog({
    properties: ["openDirectory"]
  });
  if (result.canceled || !result.filePaths[0]) return [];
  return collectFolderEntries(result.filePaths[0]);
});

ipcMain.handle("pol2:save-backups", async (_event, payload) => {
  const sourcePath = payload?.sourcePath;
  const sourceName = payload?.sourceName || path.basename(sourcePath || "slot_0.sav");
  const bytes = Buffer.from(payload?.bytes || []);
  const dir = sourcePath ? path.dirname(sourcePath) : app.getPath("downloads");
  const base = path.parse(sourceName).name;
  const files = [];
  let suffix = 1;
  while (files.length < 3) {
    const fileName = `${base}_modified.bak${suffix}`;
    const target = path.join(dir, fileName);
    try {
      await fs.access(target);
      suffix += 1;
      continue;
    } catch {}
    await fs.writeFile(target, bytes);
    files.push({ fileName, path: target });
    suffix += 1;
  }
  return { files };
});

ipcMain.handle("pol2:save-modified", async (_event, payload) => {
  const sourcePath = payload?.sourcePath;
  const sourceName = payload?.sourceName || path.basename(sourcePath || "slot_0.sav");
  const ext = path.extname(sourceName) || ".sav";
  const base = path.basename(sourceName, ext);
  const defaultPath = sourcePath
    ? path.join(path.dirname(sourcePath), `${base}_modified${ext}`)
    : path.join(app.getPath("downloads"), `${base}_modified${ext}`);
  const result = await dialog.showSaveDialog({
    defaultPath,
    filters: [
      { name: "Save files", extensions: [ext.replace(/^\./, "")] },
      { name: "All files", extensions: ["*"] }
    ]
  });
  if (result.canceled || !result.filePath) return { path: "" };
  await fs.writeFile(result.filePath, Buffer.from(payload?.bytes || []));
  return { path: result.filePath };
});

ipcMain.handle("pol2:save-modified-file", async (_event, payload) => {
  const sourcePath = payload?.sourcePath;
  const sourceName = payload?.sourceName || path.basename(sourcePath || "settings");
  const ext = path.extname(sourceName);
  const base = ext ? path.basename(sourceName, ext) : sourceName;
  const outputName = ext ? `${base}_modified${ext}` : `${base}_modified`;
  const defaultPath = sourcePath
    ? path.join(path.dirname(sourcePath), outputName)
    : path.join(app.getPath("downloads"), outputName);
  const result = await dialog.showSaveDialog({
    defaultPath,
    filters: [
      { name: "All files", extensions: ["*"] }
    ]
  });
  if (result.canceled || !result.filePath) return { path: "" };
  await fs.writeFile(result.filePath, Buffer.from(payload?.bytes || []));
  return { path: result.filePath };
});

app.whenReady().then(() => {
  createWindow();
  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") app.quit();
});
