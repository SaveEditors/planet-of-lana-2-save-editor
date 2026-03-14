"use strict";

const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("saveEditorDesktop", {
  pickFiles: () => ipcRenderer.invoke("pol2:pick-files"),
  pickFolder: () => ipcRenderer.invoke("pol2:pick-folder"),
  saveBackupCopies: (payload) => ipcRenderer.invoke("pol2:save-backups", payload),
  saveModifiedSave: (payload) => ipcRenderer.invoke("pol2:save-modified", payload),
  saveModifiedFile: (payload) => ipcRenderer.invoke("pol2:save-modified-file", payload)
});
