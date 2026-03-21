# AudioStreamMETER.spec
block_cipher = None

a = Analysis(
    ['AudioStreamMETER_windows.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('presets', 'presets'),
        ('metering_standards', 'metering_standards'),
    ],
    hiddenimports=[
        'PyQt6.QtCore', 'PyQt6.QtGui', 'PyQt6.QtWidgets',
        'pyqtgraph', 'numpy', 'pyloudnorm'
    ],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz, a.scripts, [],
    exclude_binaries=True,
    name='AudioStreamMETER',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,         # ← niente finestra console
    icon="./temporary.ico"       # ← opzionale, metti il tuo .ico
)

coll = COLLECT(
    exe, a.binaries, a.zipfiles, a.datas,
    strip=False,
    upx=False,
    name='AudioStreamMETER'
)