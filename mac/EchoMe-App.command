#!/bin/bash
# Desktop-App starten (wie Start.bat unter Windows) — Doppelklick im Finder.
# Beim allerersten Mal: Rechtsklick -> Oeffnen (Gatekeeper-Bestaetigung).
cd "$(dirname "$0")/.."
exec venv/bin/python app/main.py
