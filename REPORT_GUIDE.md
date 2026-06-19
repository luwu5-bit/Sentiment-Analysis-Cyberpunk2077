# Report-Leitfaden — Anatomy of a Redemption

Für das Schreib-Team. Erklärt **wie ihr beim Report vorgeht** und **wo welche Datei liegt**.
Diese Datei ist interne Koordination und **nicht Teil der Abgabe**.

> ⚠️ **Wichtig:** Der **Report selbst muss auf Englisch** sein (Abgabe-Konvention, siehe `CLAUDE.md`).
> Dieser Leitfaden ist auf Deutsch, der Report nicht.

---

## 0 · TL;DR — in 5 Schritten zum Report

1. Lies **`results/FINDINGS.md`** — das ist die inhaltliche Essenz (4 Kernbefunde + Zahlen).
2. Schau dir die **5 Figuren** in `results/figures/` an (PNG, fertig zum Einbinden).
3. Nimm die **Report-Struktur** unten (Abschnitt 4) als Gliederung.
4. Jede Zahl im Report muss auf **genau eine Datei** in `results/` zurückführbar sein (Abschnitt 2).
5. Vergiss die **Pflicht-Abschnitte Legal/Ethik** nicht (Abschnitt 5) — die sind separat von der Analyse.

---

## 1 · Format-Vorgaben der Abgabe

- **PDF-Report:** max. **8 Seiten** (ohne Referenzen), **12pt Times New Roman**, einspaltig, einzeilig.
- Abgabe ist **1 ZIP** mit: Notebook(s) inkl. Daten-Sample + README, **HTML-Export** des Notebooks, **PDF-Report**.
- **Deadline:** 30.06.2026.
- Der Report wird **aus den `results/`-Dateien** geschrieben — **nicht** durch erneutes Laufenlassen der Pipeline.

---

## 2 · Wo liegt was? (die wichtigen Dateien)

### Zuerst lesen
| Datei | Inhalt |
|---|---|
| **`results/FINDINGS.md`** | Die 4 Kernbefunde als Fließtext, mit Zahlen und Quellverweis. **Start hier.** |
| `results/RUN_INFO.txt` | Provenance des Laufs (Modus, Zeitfenster, Seed, Datum). Für den Methoden-/Repro-Teil. |
| `README.md` | Projekt-Setup + Tabelle „welche Datei → welche Report-Aussage". |

### Zahlen-Quellen (`results/*.csv`)
| Datei | Spalten | Wofür im Report |
|---|---|---|
| `sentiment_timeseries.csv` | `source, month, n, mean_sentiment, std_sentiment` | Haupt-Zeitreihe (beide Kurven), alle Monatswerte |
| `redemption_metrics.csv` | `source, overall_mean, launch_mean, plateau_mean, climb, trough/peak` | **Kernbefund**: Niveau-Gap, Steam-Anstieg, Reddit flach |
| `anomaly_flags.csv` | `source, month, n, z, is_anomaly` | Review-Bombing / Launch-Volumenschock |
| `sentiment_excl_bombing.csv` | Zeitreihe ohne geflaggte Monate | Robustheits-Check „mit/ohne Bombing" |
| `vader_validation.csv` | `metric, value` | Methoden-Validierung (VADER vs. Steam-Rating) |
| `topics.csv` | `topic_id, top_terms, weight` | Topic-Analyse (LDA) |
| `word_frequency.csv` | `source, rank, term, count` | Häufigste Wörter je Quelle |
| `tfidf_top_terms.csv` | `term, tf, df, idf, tfidf` | Unterscheidungskräftigste Begriffe |
| `sentiment_patch_join.csv` | `source, month, n, mean_sentiment, patches, has_patch` | Sentiment ↔ Patch-Events (Cross-Source-Join) |
| `patch_overlay.csv` | `patch_name, release_date` | Patch-Marker für die Hauptfigur |

### Figuren (`results/figures/*.png`) — fertig zum Einbinden
| Figur | Zeigt | Gehört zu |
|---|---|---|
| `sentiment_timeline.png` | Beide Sentiment-Kurven + Patch-Marker | **Hauptfigur** (Ergebnisse) |
| `redemption_climb.png` | Launch-Quartal vs. 2023-Plateau je Quelle | Kernbefund (Gap + Anstieg) |
| `volume_timeline.png` | Monatliches Dokumentvolumen je Quelle | Launch-Schock / Review-Bombing |
| `vader_validation.png` | Sentiment-Verteilung nach Steam-Rating | Methoden-Validierung |
| `tfidf_top_terms.png` | Top-Begriffe nach TF-IDF | Topic-Analyse |

### Code / Pipeline
| Ort | Inhalt |
|---|---|
| `notebooks/pipeline.ipynb` | Komplette Pipeline (Stage 0–5). Oben steht die **AI Usage Declaration**. |
| `data/processed/` | Spark-Zwischenstände (Parquet) — **nicht** für den Report, nur intern. |

---

## 3 · Die Kernbotschaft (was der Report sagen soll)

**Titel-These:** „Anatomy of a Redemption" — die Erlösung von Cyberpunk 2077 ist **real, aber asymmetrisch**
zwischen den Plattformen. Die ursprüngliche Proposal-These („Reddit erholt sich schneller als Steam") wird
von den Vollausdaten **nicht** gestützt und wurde bewusst neu gefasst (Details: `FINDINGS.md`).

Vier Befunde (alle Zahlen aus `results/`):

1. **Redemption steckt in den Steam-Reviews.** Steam: Tiefpunkt 0,42 (Mai 2021) → Plateau ~0,51 (2023).
   Reddit dagegen flach (`climb` −0,002): kein vergleichbarer Erholungsbogen.
2. **Großer, dauerhafter Niveau-Abstand.** Steam (Ø 0,498) liegt **+0,348** über Reddit (Ø 0,150) — durchgehend.
   Medien-Effekt: Steam = klares Daumen-hoch/runter, Reddit = kritische Diskussion.
3. **Launch-Krise = Volumen-Schock, kein Sentiment-Einbruch.** Dez 2020: 1,69 Mio Reddit-Dokumente +
   114k Steam-Reviews (einzige Anomalie), aber der Mittelwert kippt **nie** ins Negative.
4. **Divergenz beim 2.0/Phantom-Liberty-Relaunch (Okt 2023).** Steam nahe Hoch (0,525), Reddit am **globalen
   Tiefpunkt (0,109)** — der gefeierte Relaunch löst auf Reddit eine kritische Diskussionswelle aus.

**Stütze (Methoden-Validierung):** VADER funktioniert auf der gelabelten Steam-Seite — Recommended 0,573 vs.
Not Recommended 0,112 (n = 241.688), Korrelation 0,33, Accuracy 0,77.

---

## 4 · Vorgeschlagene Report-Struktur (8 Seiten) + Datei-Mapping

Grobes Seitenbudget — passt es an euren Stil an.

| # | Abschnitt | ~Seiten | Stützt sich auf |
|---|---|---|---|
| 1 | **Introduction / Motivation** — Spiel, Launch-Desaster, Fragestellung | 1 | — |
| 2 | **Data** — Reddit-Dumps (4 Subreddits), Steam-Reviews, Patch-Timeline; Größenordnung (7,84 Mio Docs) | 1 | `RUN_INFO.txt`, README |
| 3 | **Method** — Pipeline (Spark, Filter, Cleaning, VADER, Topics); Keyword-Filter der Allgemein-Subreddits | 1–1,5 | `pipeline.ipynb`, `vader_validation.csv` (Validierung) |
| 4 | **Results** — Hauptfigur + die 4 Befunde | 2–2,5 | `sentiment_timeline.png`, `redemption_climb.png`, `volume_timeline.png`, `redemption_metrics.csv`, `anomaly_flags.csv` |
| 5 | **Topic Analysis** — LDA-Themen + TF-IDF | 0,5–1 | `topics.csv`, `tfidf_top_terms.png` |
| 6 | **Legal / Ethics** — Lizenzen, GDPR, Review-Bombing-Umgang | 1 | siehe Abschnitt 5 unten |
| 7 | **Conclusion** — Antwort auf die Fragestellung, Limitationen | 0,5 | `FINDINGS.md` |
| — | **References** (zählen nicht zu den 8 Seiten) | — | — |

**Regel:** Jede genannte Zahl/Figur → genau eine `results/`-Datei. Steht eine Behauptung ohne Quelle da,
fehlt entweder ein Output oder die Aussage gehört nicht rein.

---

## 5 · Pflicht-Abschnitte Legal / Ethik (nicht vergessen!)

Diese sind in der Pipeline **nicht** abgedeckt — rein Schreibarbeit:

- **Reddit-Lizenz:** User Agreement, Public Content Policy, Data API Terms.
- **Steam-Lizenz:** Steamworks Web API Terms.
- **GDPR & Fairness:** personenbezogene Daten (Usernamen wurden nicht verwendet/gespeichert — nur `body`/`text`),
  öffentliche vs. private Daten, Aggregation statt Einzelpersonen.
- **Review-Bombing & Interessenkonflikt:** wie wir damit umgehen (Volumen-Anomalie-Flag `anomaly_flags.csv`,
  Robustheits-Check `sentiment_excl_bombing.csv`).
- **Bibliographie** finalisieren.

---

## 6 · Schreib-Tipps & Checkliste

**Vorgehen**
- Aus **Daten & Figuren** schreiben, nicht aus dem Bauch. Erst Figur/CSV anschauen, dann formulieren.
- Das **„Warum"** erklären, nicht nur das „Was" (z. B. warum sofort filtern → RAM; warum Case erhalten → VADER).
- **Ehrlich bleiben:** Die These wurde nach Sichtung der Daten geändert — das ist eine **Stärke** (gute Wissenschaft),
  nicht verstecken. Im Conclusion-Teil kurz begründen.
- **Konsistente Zahlen:** immer aus den CSVs kopieren, nicht aus dem Kopf.

**Vor der Abgabe abhaken**
- [ ] Report auf **Englisch**, ≤ 8 Seiten, 12pt Times New Roman, einspaltig, einzeilig.
- [ ] Jede Figur referenziert + beschriftet; jede Zahl hat eine `results/`-Quelle.
- [ ] Legal/Ethik-Abschnitt vorhanden.
- [ ] Notebook läuft durch, Zell-Outputs drin (finaler Lauf), HTML-Export erzeugt.
- [ ] **AI Usage Declaration** im Notebook ist ausgefüllt/personalisiert (oben in `pipeline.ipynb`).
- [ ] Alles als 1 ZIP gepackt.

---

## 7 · Reproduzierbarkeit / Provenance

- Die `results/`-Dateien stammen aus dem **Full-Run** (`DATA_MODE = "full"`, gesamtes 34-Monats-Fenster,
  Seed 42). Exakte Provenance in `results/RUN_INFO.txt`.
- Für die **Abgabe** wird das Notebook auf `DATA_MODE = "sample"` zurückgestellt (das ZIP enthält nur das
  kleine Sample, nicht die ~70 GB Rohdaten) — der Code-Pfad ist identisch. Das ist ein Finalisierungs-Schritt;
  die Zahlen im Report bleiben die des Full-Runs.
