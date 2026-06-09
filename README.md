# Anatomy of a Redemption
### Spark-basierte Multi-Source Sentiment-Analyse von Cyberpunk 2077

Lab Group 1 — Data Processing 2, SS 2026

---

## Überblick

Batch-Pipeline in Apache Spark, die Reddit-Kommentare und Steam-Reviews zu Cyberpunk 2077
über das 34-Monats-Fenster (Dez 2020 – Dez 2023) verarbeitet, mit VADER ein Sentiment vergibt
und die zwei Sentiment-Zeitreihen gegen eine Patch-Timeline ausrichtet.

---

## ⚠️ Wichtig: Daten sind NICHT im Repo

Die rohen Reddit-Dumps (mehrere zehn bis hundert GB) liegen **nicht** in diesem Repo und
**nicht** im Abgabe-ZIP — sie sind zu groß für Git/GitHub. Im Repo/ZIP liegt nur:

- der gesamte Code (`notebooks/`, `src/`)
- ein **kleines Sample** unter `data/sample/`, mit dem die Pipeline demonstrierbar ist

Wer die volle Pipeline reproduzieren will, muss die Rohdaten zuerst selbst herunterladen
(siehe unten) und unter `data/raw/` ablegen.

---

## Ordnerstruktur

```
.
├── .gitignore
├── README.md
├── notebooks/
│   └── pipeline.ipynb        # Haupt-Notebook (läuft end-to-end durch)
├── src/                      # ausgelagerte Hilfsfunktionen (optional)
├── results/                  # finale, aggregierte Outputs für den Report (klein, IM Repo)
│   ├── figures/              # exportierte Plots (.png)
│   └── RUN_INFO.txt          # Modus + Datenfenster des Laufs
└── data/                     # NICHT in Git (außer sample/)
    ├── raw/                  # heruntergeladene Reddit-Dumps + Steam-CSV
    ├── processed/            # gefilterte Parquet-Zwischenstände
    └── sample/               # kleines Sample fürs ZIP (1-2 Monate)
```

---

## Daten beschaffen

### Reddit (Pushshift Monthsdumps)
1. Monatliche Dumps für **Dez 2020 – Dez 2023** herunterladen
   (z.B. via die academic Torrents / Pushshift-Archive, `.zst`-komprimiert, zeilenweise JSON).
2. Dateien unter `data/raw/reddit/` ablegen, **nicht entpacken** —
   Spark liest `.zst` direkt.

### Steam Reviews
1. Öffentliches Steam-Reviews-Dataset herunterladen, auf Cyberpunk 2077 (App-ID 1091500) filtern.
2. Als CSV unter `data/raw/steam/` ablegen.

### Patch-Timeline
- `data/raw/patch_timeline.csv` — kleine, von Hand gepflegte Tabelle:
  `patch_name, release_date, platform, notes` (Patches bis 2.0 / Phantom Liberty).

---

## Setup

```bash
# venv anlegen (optional, empfohlen)
python3 -m venv .venv && source .venv/bin/activate

# Abhängigkeiten
pip install pyspark findspark vaderSentiment pandas matplotlib

# Jupyter starten
jupyter notebook notebooks/pipeline.ipynb
```

> Für den vollen Lauf: Maschine mit ~16 GB+ RAM und reichlich freiem Festplattenplatz
> (großzügig 200 GB+ wegen Zwischenergebnissen). Entwicklung läuft am Sample, der volle
> Lauf wird nur einmal für die finale Abgabe gemacht.

---

## Pipeline ausführen

Das Notebook läuft end-to-end durch. Über die Variable `DATA_MODE` oben im Notebook lässt
sich zwischen Sample und vollem Datensatz umschalten:

```python
DATA_MODE = "sample"   # "sample" für schnelle Iteration, "full" für den finalen Lauf
```

Der restliche Code bleibt unverändert — Spark skaliert dieselbe Pipeline von Sample auf das
volle Fenster.

---

## Outputs & Report-Mapping

Die Pipeline schreibt ihre **finalen, aggregierten** Ergebnisse nach `results/`
(eigener Ordner, getrennt von `data/processed/`, das nur Zwischenstände hält).
Diese Dateien sind klein und nicht-personenbezogen — sie dürfen im Repo/ZIP liegen.
Der Report wird ausschließlich aus diesen Dateien geschrieben, **nicht** durch
erneutes Laufenlassen der vollen Pipeline.

| Output-Datei                        | Inhalt / Schema                                                  | Belegt im Report                           |
|-------------------------------------|------------------------------------------------------------------|--------------------------------------------|
| `results/sentiment_timeseries.csv`  | `source, month, mean_sentiment, n` (Reddit + Steam, monatlich)   | Hauptabbildung: zwei Sentiment-Kurven      |
| `results/patch_overlay.csv`         | `patch_name, release_date` (zum Einzeichnen in die Zeitreihe)    | Patch-Marker auf der Hauptabbildung        |
| `results/recovery_metric.csv`       | `source, trough_month, recovery_month, recovery_days` je Quelle  | **Kernthese** (Reddit schneller als Steam) |
| `results/anomaly_flags.csv`         | `source, month, n, is_anomaly` (Volume-Anomaly / Review-Bombing) | Review-Bombing-Abschnitt + Robustheit      |
| `results/sentiment_excl_bombing.csv`| Sentiment-Zeitreihe **ohne** geflaggte Fenster                   | Metriken „mit und ohne" Bombing-Fenster    |
| `results/topics.csv`                | `topic_id, top_terms, weight` (LDA / TF-IDF)                     | Topic-Analyse-Abschnitt                    |
| `results/figures/`                  | exportierte `.png` der finalen Plots                             | direkt in den Report eingebettet           |

**Regel:** Jede Zahl und jede Abbildung im Report muss auf genau eine Datei unter
`results/` zurückführbar sein. Kommt eine Aussage in den Report, die hier keine
Quelle hat, fehlt entweder ein Output oder die Aussage gehört nicht rein.

### Reproduzierbarkeit

Damit jede Report-Zahl nachvollziehbar bleibt:

- **Parameter zentral** oben im Notebook (ein Block), nicht über die Zellen verstreut:
  `DATA_MODE`, Zeitfenster, Subreddit-Liste, Anomaly-Schwellwert, Anzahl LDA-Topics.
- **Seed setzen** für alles Stochastische — insbesondere den LDA-Pass
  (`setSeed(...)`), damit Topics zwischen Läufen stabil sind.
- Der **`results/`-Stand stammt vom vollen Lauf** (`DATA_MODE = "full"`), nicht vom
  Sample. In `results/RUN_INFO.txt` festhalten, welcher Modus und welches Datenfenster
  zugrunde liegt.

---

## Team

Lab Group 1 — keine festen Rollen; Arbeit nach Arbeitspaketen verteilt (siehe Roadmap).
