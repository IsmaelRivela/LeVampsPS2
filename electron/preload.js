const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('levampsDesktop', { active: true });
