# CLAUDE.md

Kontext für Claude Code bei der Arbeit an diesem Projekt.
## Sprache 
alle kommentare und texte die wichtig für die abgabe sind sollen in englisch geschrieben werden.
## Projekt

**Anatomy of a Redemption** — Spark-basierte Multi-Source Sentiment-Analyse von
Cyberpunk 2077. Batch-Pipeline in Apache Spark, die Reddit-Kommentare und Steam-Reviews
über das 34-Monats-Fenster (Dez 2020 – Dez 2023) verarbeitet, mit VADER ein Sentiment
vergibt und zwei Sentiment-Zeitreihen gegen eine Patch-Timeline ausrichtet.

Universitätsprojekt (Data Processing 2, SS 2026, Lab Group 1). Finale Abgabe: **30.06.2026**.

## Tech-Stack

- **Apache Spark / PySpark** (lokal, `local[*]`) — Kernframework, batch processing
- **Jupyter Notebook** — Muss end-to-end durchlaufen; ist Teil der Abgabe
- **VADER** (`vaderSentiment`) — Sentiment-Scoring als Spark-UDF
- **Git + VS Code** — Entwicklung
- Topic-Analyse: Wortfrequenz, TF-IDF, einfacher LDA-Pass

## Harte Regeln (Datengröße)

Das ist der kritischste Teil. Bitte immer beachten:

- **Daten gehören NIE ins Git-Repo.** Der `data/`-Ordner ist in `.gitignore`.
  Nur Code wird committet, plus ein kleines `data/sample/`.
- **Nie `.collect()` oder `.toPandas()` auf einem vollen DataFrame.** Sprengt den
  Treiber-RAM. Erst aggregieren (z.B. Sentiment je Monat), dann `.toPandas()` auf dem
  kleinen Ergebnis für Plots.
- **Sofort beim Einlesen filtern** (Subreddits + Zeitfenster), bevor irgendwas anderes
  passiert. Aus 15 GB/Monat soll früh ein Bruchteil werden.
- **`.zst`-Dumps direkt lesen**, nicht entpacken — Spark kann das.
- **Zwischenstände als Parquet** speichern, partitioniert nach `source` / `month`.
- Pipeline muss **unverändert von Sample auf vollen Datensatz** skalieren. Schalter dafür:
  `DATA_MODE = "sample" | "full"` oben im Notebook.
- **Finale Ergebnisse nach `results/` schreiben** (CSV + `figures/*.png`), getrennt von
  `data/processed/`. Aus diesen Dateien wird der Report geschrieben — nicht durch erneuten
  Pipeline-Lauf. Jede Report-Zahl muss auf genau eine `results/`-Datei zurückführbar sein.
  Output-Liste und Report-Mapping stehen in der README.
- **Seed für alles Stochastische** setzen (v.a. LDA, `setSeed(...)`), Parameter zentral
  oben im Notebook bündeln, damit Ergebnisse reproduzierbar bleiben.

## Ordnerstruktur

```
notebooks/   # Haupt-Notebook (pipeline.ipynb), läuft end-to-end
src/         # ausgelagerte Hilfsfunktionen
results/     # finale, aggregierte Outputs für den Report (klein, IM Git)
  figures/   # exportierte Plots (.png)
data/        # NICHT in Git (außer data/sample/)
  raw/       # heruntergeladene Dumps + Steam-CSV
  processed/ # gefilterte Parquet-Zwischenstände
  sample/    # kleines Sample fürs Abgabe-ZIP
```

## Workflow

- Entwicklung läuft **am Sample** für schnelle Iteration. Der volle Lauf wird nur einmal
  für die finale Abgabe gemacht (braucht ~16 GB+ RAM und viel freien Plattenplatz).
- Code soll auch in einer Notebook-Zelle lauffähig sein (`findspark.init()` zuerst,
  wie im Lab-4-Setup).
- **Code muss plattformübergreifend laufen (Mac + Windows).** Keine Backslashes/OS-spezifischen
  Calls; Pfade über die aufgelöste Projekt-Wurzel als POSIX-Strings bilden, damit sie unabhängig
  vom Jupyter-Arbeitsverzeichnis und vom OS funktionieren. Windows braucht für Parquet-I/O
  `winutils.exe` + `HADOOP_HOME` (siehe README).

## Konventionen

- Sprache in Code-Kommentaren, Notebook-Markdown und README: **Englisch** (abgabe-relevant). Code-Bezeichner: Englisch.
- Spaltennamen des Steam-Datasets (`review`, `timestamp_created` etc.) ggf. an das
  konkret verwendete Dataset anpassen — vor dem Hardcoden prüfen.
- Vor jedem Notebook-Commit: alle Zellen durchlaufen lassen, Outputs drinlassen, speichern.

## Abgabe (1 ZIP)

- Jupyter Notebook(s) inkl. Daten-Sample + README (muss durchlaufen, Zell-Outputs drin)
- HTML-Export der Notebook(s)
- PDF-Report: max. 8 Seiten (ohne Referenzen), 12pt Times New Roman, einspaltig, einzeilig

## Team

Keine festen Rollen. Die im Proposal genannten Zuständigkeiten stehen nur formal drin —
Arbeit wird in der Praxis nach Arbeitspaketen verteilt, nicht nach Personen.
