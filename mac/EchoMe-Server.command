#!/bin/bash
# Web-Server starten (wie Start-Server.bat unter Windows) — nur noetig,
# wenn ANDERE Geraete (z.B. iPhone) diesen Mac als Uebersetzer nutzen sollen.
cd "$(dirname "$0")/../app"
exec ../venv/bin/python web_server.py
