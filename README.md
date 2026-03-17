# IP-Audio-Stream-Monitor

Monitor audio in tempo reale per stream HTTP (MP3/AAC). Visualizza fino a 16 flussi audio contemporaneamente con waveform in real-time e misurazione LUFS e TruePeak secondo lo standard algoritmico ITU-R BS 1770-5 e
lo standard audio EBU R 128-2023.

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)
![License](https://img.shields.io/badge/License-GnuGPLv3-green.svg)

## Funzionalità

- Monitoraggio simultaneo fino a 16 stream audio stereo
- Visualizzazione waveform in tempo reale
- Misurazione LUFS Short-term e TruePeak Left/Right conforme con EBU R128
- Gestione preset per configurazioni multiple
- Interfaccia moderna con PyQt6

---

## Struttura del progetto

```text
IpStreamMonitor/
├── src/
│   ├── stream_monitor.py     # Versione cross-platform
│   ├── requirements.txt      # Dipendenze Python
│   ├── metering_standards/standards.json   # File per richiamare gli standard di misurazione
│   └── presets/Default.csv   # File per richiamare set di IP + Nome corrisponente con un singolo click
├── Windows/
│   ├── stream_monitor_windows.py   # Versione Windows
│   ├── metering_standards/standards.json   # File per richiamare gli standard di misurazione
│   ├── presets/Default.csv   # File per richiamare set di IP + Nome corrisponente con un singolo click
│   ├── stream_monitor_windows.spec # Config PyInstaller
│   ├── installer.iss               # Script Inno Setup
│   └── ffmpeg_bin/                 # Binari FFmpeg
└── README.md
```

---

## Installazione

### Opzione 1: CLassico Installer Windows 10/11

Il modo più semplice per installare IP Stream Monitor su Windows.

1. Scarica l'installer da... :
   IPStreamMonitor_installer.exe

2. Esegui l'installer e segui la procedura guidata

3. L'applicazione verrà installata con:
   - FFmpeg integrato (ffmpeg.exe e ffplay.exe) e Python con librerie Qt6 per la GUI, numpy/pyqtgraph per la rappresentazione della forma d'onda e librerie di sistema per l'avvio dell'app e la gestione processi.
   - Collegamento sul Desktop (opzionale)
   - Collegamento nel Menu Start (opzionale)
   - Disinstallazione automatica tramite "uninstall.exe" nella cartella:
                              C:\Program Files (x86)\IpStreamMonitor

> **Nota**: L'installer richiede privilegi di amministratore e Windows 10 o superiore (64-bit).

---

### Opzione 2: Build manuale da sorgenti

Per chi preferisce compilare autonomamente l'eseguibile.

#### Prerequisiti

- Python 3.10 o superiore
- FFmpeg (scaricabile da [ffmpeg.org](https://ffmpeg.org/download.html) oppure con sudo apt install ffmpeg)
- Git (opzionale, per clonare il repository)

#### Procedura

##### 1. Clona o scarica il repository

```powershell
git clone https://github.com/Jasssbo/IpAudioStreamMonitor.git
cd Ip Audio Stream Monitor
```

##### 2. Crea un virtual environment

```powershell/bash
# Crea il venv
cd Ip Audio Stream Monitor && python -m venv .venv

# Attiva il venv
.\venv\Scripts\Activate.ps1 #se su Windows

.\.\venv\Scripts\Activate.sh #se su Linux
```

> Per Command Prompt usa invece: `venv\Scripts\activate.bat`

##### 3. Installa le dipendenze

```powershell/bash
pip install -r src/requirements.txt
```

Le dipendenze sono:

- `PyQt6` - Framework GUI
- `pyqtgraph` - Grafici real-time
- `numpy` - Elaborazione numerica
- `pyloudnorm` - Misurazione LUFS

##### 4. (Opzionale) Testa l'applicazione

Prima di creare l'eseguibile, verifica che tutto funzioni:

```powershell/bash
python src/stream_monitor.py
```

##### 5. Installa PyInstaller

```powershell/bash
pip install pyinstaller
```

##### 6. Aggiungi FFmpeg

Copia `ffmpeg.exe` e `ffplay.exe` nella stessa cartella dell'eseguibile:

```text
Windows/dist/StreamMonitor/
├── HTTP-StreamMonitor.exe
├── ffmpeg.exe
├── ffplay.exe
└── _internal/
```

> Puoi scaricare FFmpeg da [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) o [BtbN](https://github.com/BtbN/FFmpeg-Builds/releases)

---

##### 7. Crea l'eseguibile

```powershell/bash
cd Windows
pyinstaller stream_monitor_windows.spec
```

L'eseguibile verrà creato in:

```text
Windows/dist/StreamMonitor/StreamMonitor.exe
```

## Configurazione avanzata

### Creazione dell'installer (opzionale)

Se vuoi creare il tuo installer personalizzato:

1. Installa [Inno Setup](https://jrsoftware.org/isinfo.php)

2. Assicurati che la struttura sia:

   ```text
   Windows/
   ├── dist/StreamMonitor/    ← output di PyInstaller
   ├── ffmpeg_bin/            ← ffmpeg.exe e ffplay.exe
   └── installer.iss
   ```

3. Compila l'installer su InnoSetup:

   ```powershell
   iscc Windows/installer.iss
   ```

4. L'installer verrà creato in `Windows/Output/` e potrai così condividere facilmente la tua versione.

---

## Requisiti di sistema

| Requisito    | Minimo                          |
| ------------ | ------------------------------- |
| OS           | Windows 10 64-bit               |
| Python       | 3.10+ (solo per build manuale)  |
| RAM          | 4 GB                            |
| Spazio disco | ~200 MB                         |

---

## Licenza

Questo progetto è distribuito con licenza GNU GPLv3. Vedi il file [LICENSE](LICENSE) per i dettagli.

---

## Autore

**Andrea Mazzurana** - [GitHub](https://github.com/Jasssbo)
