# MiNERVA Radio 

A terminal-based video game music radio station with a live spectrum visualiser,
track request system, and basic catalogue management tools.

Built for Arch Linux, should be portable soon. Plays VGM, SPC, MP3, FLAC, and WAV files from your local
music library.

## Features

-  Plays VGM, VGZ, SPC, MP3, FLAC, and WAV files
-  Live spectrum visualiser with randomised colour schemes per track
-  Track request terminal — search, browse, and queue from a second terminal
-  Multiple catalogue indexers for different library structures
-  First-run setup wizard — one command to configure everything
-  Optional CPU performance mode for smooth VGM playback
-  SPC file renaming via ID666 tags
-  RSN archive extraction and folder renaming via snesmusic.org

## Installation

### Manual

```bash
git clone https://github.com/TheWhyteWolf/MiNERVA-Radio.git
cd MiNERVA-Radio
makepkg -si
```

---

## Dependencies

All resolved automatically via AUR install. -- TO BE ADDED --

| Package | Purpose |
|---|---|
| `tmux` | Terminal multiplexer — runs radio engine and visualiser side by side |
| `mpv` | Playback of SPC, MP3, FLAC, WAV files |
| `vgmplay` | Playback of VGM and VGZ files |
| `cli-visualizer` | Spectrum visualiser (`vis`) |
| `pulseaudio` | Null sink audio routing |
| `ffmpeg` | Embedded tag extraction for MP3/FLAC/WAV indexing |
| `python` | CSV parsing, metadata handling, SPC tag reading |
| `python-openpyxl` | Excel catalogue output (Universal Indexer) |
| `unrar` | RSN archive extraction |
| `curl` | RSN folder renaming web lookup fallback |
| `sudo` | CPU governor switching (optional — can be disabled in setup) |

---

## Quick Start

```bash
# First run — detects no config, runs setup, indexes your library, then starts the radio
minerva

# In a second terminal, open the request interface
minerva-request
```

That's it. `minerva` handles everything automatically on first run.

---

## Usage

### Main Launcher

```bash
minerva              # Auto-detect and launch — setup → index → play
minerva --setup      # Re-run the configuration wizard
minerva --index      # Re-index your music library
minerva --request    # Launch the request terminal
minerva --help       # Show all options
```

### Individual Scripts

```bash
minerva-radio        # Start the radio directly
minerva-request      # Open the request terminal (run in a second terminal)
minerva-setup        # First-run configuration wizard
```

### Indexers

```bash
# Universal — VGM + MP3/FLAC/WAV with embedded tag extraction (recommended)
minerva-index "/path/to/music"

# SPC — VGM + SPC files
minerva-index-spc "/path/to/music"

# Basic — VGM/VGZ only
minerva-index-basic "/path/to/music"
```

### Utility Tools

```bash
# Extract .rsn SNES music archives
minerva-xtract-rsn "/path/to/rsn/folder"

# Extract .zip archives with Unicode filename sanitisation
minerva-xtract "/path/to/zip/folder"

# Rename RSN folders using info.txt or snesmusic.org lookup
minerva-rename-rsn "/path/to/folder"
minerva-rename-rsn "/path/to/folder" --dry-run   # Preview without changes

# Rename SPC files using ID666 title tags
minerva-rename-spc "/path/to/folder"
minerva-rename-spc "/path/to/folder" --dry-run   # Preview without changes
```

---

## Configuration

Config is stored at `~/.config/minerva-radio/minerva.conf` and is generated
automatically by `minerva-setup`.

```bash
# Example config
VGM_DIR="/home/user/Music/VGM"
CATALOGUE_NAME="vgmcatalogue"
DEFAULT_INDEXER="minerva-index"
COLOUR_SCHEMES="gameboy gameboy_pocket bbc_micro pico8 cga nes minerva c64 zx_spectrum"
USE_PERFORMANCE_GOV="true"
```

To reconfigure at any time:

```bash
minerva --setup
```

---

## Library Structure

MiNERVA Radio expects your music library to follow a consistent folder hierarchy.
The indexers automatically detect whether a subdirectory is a platform/developer
folder or a game folder.
VGM_DIR/
├── Composer_or_Label/ ← TLD (Top Level Directory)
│ ├── Game_Title/ ← Game folder (direct)
│ │ ├── track01.vgm
│ │ └── track02.vgm
│ └── Platform/ ← Platform folder (detected automatically)
│ └── Game_Title/
│ └── track01.vgm
├── SNES/
│ └── Game_Title/
│ ├── track01.spc
│ └── track02.spc
└── Soundtracks/
└── Game_Title/
├── 01 - Opening.mp3
└── 02 - Stage 1.flac
---
## Catalogue IDs

Every track is assigned a unique Catalogue ID in the format `TLD-SUB-FILE`:
100-1002-3
│ │ └── File number within the game
│ └────── Sub-ID (unique per game)
└─────────── TLD ID (unique per top-level folder)

Use these IDs in `minerva-request` to queue specific tracks instantly.

---

## Request Terminal

Run `minerva-request` (or `minerva --request`) in a second terminal while the
radio is playing.
╔══════════════════════════════════════════╗
║ MiNERVA RADIO REQUEST TERMINAL ║
╚══════════════════════════════════════════╝

Queue: 3 track(s) waiting

1. Request by Catalogue ID
2. View queue
3. Search catalogue
4. Browse by TLD + SUB ID
q. Quit

text

- **Request by ID** — enter a Catalogue ID directly to queue a specific track
- **Search** — search by game name or filename, then browse and queue tracks
- **Browse** — navigate by TLD and Sub-ID, queue individual tracks or entire games
- **Queue viewer** — see what's coming up next

---

## Visualiser

MiNERVA Radio uses [cli-visualizer](https://github.com/dpayne/cli-visualizer) (`vis`)
to display a live spectrum analyser in the lower pane of the tmux session.

A new colour scheme and spectrum character are chosen randomly with every track.

**Available colour schemes:**

| Scheme | Inspired by |
|---|---|
| `gameboy` | Original Game Boy green palette |
| `gameboy_pocket` | Game Boy Pocket grey palette |
| `bbc_micro` | BBC Micro Mode 2 colours |
| `pico8` | PICO-8 fantasy console |
| `cga` | IBM CGA 4-colour palette |
| `nes` | NES colour palette |
| `minerva` | MiNERVA custom scheme |
| `c64` | Commodore 64 palette |
| `zx_spectrum` | ZX Spectrum palette |

Custom schemes can be added via your `cli-visualizer` config and included in
`COLOUR_SCHEMES` in `~/.config/minerva-radio/minerva.conf`.

---

## PulseAudio Routing

MiNERVA Radio creates a null sink called `minerva_radio` at startup and routes
all playback through it. This allows you to:

- Monitor the stream via `minerva_radio.monitor` in PulseAudio volume control
- Route it to a recording application (e.g. OBS, `parec`)
- Forward it to a network stream (e.g. Icecast via `darkice`)

The sink is automatically removed on exit.

---

## Pipewire Users

If you use Pipewire with `pipewire-pulse`, all `pactl` commands are handled
transparently — no changes needed. The null sink will appear in `pavucontrol`
and `helvum` as normal.

---

## Troubleshooting

**Radio starts but no audio:**
- Check `pavucontrol` — ensure `minerva_radio` sink is not muted
- Check that `vis` is latching onto `minerva_radio.monitor` — it reloads
  automatically after 3 seconds but you can press `r` inside the visualiser pane

**`vgmplayer` not found:**
- Install from AUR: `yay -S vgmplay-git`

**`vis` not found:**
- Install from AUR: `yay -S cli-visualizer`

**Catalogue not found on launch:**
- Run `minerva --index` to rebuild it
- Check `VGM_DIR` in your config matches where your files actually are


**RSN folder renaming fails for some folders:**
- Folders without an `info.txt` fall back to a `snesmusic.org` web lookup
- Ensure `curl` is installed and you have an internet connection
- Affected folders will be logged to `rename_log.txt`
