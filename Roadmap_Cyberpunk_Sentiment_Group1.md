# Projekt-Roadmap — Anatomy of a Redemption
### Spark-basierte Multi-Source Sentiment-Analyse von Cyberpunk 2077 · Lab Group 1

---

## Wo wir stehen

Das Proposal ist abgegeben (Frist 29.05.2026). Lab 4 (Kafka + Sentiment Analysis) ist durch — wir haben jetzt alle technischen Bausteine. Der nächste und letzte harte Termin ist die **finale Abgabe am 30.06.2026**.

**Abzugeben (1 ZIP):**
- Jupyter Notebook(s) inkl. Daten + README (muss durchlaufen, Zell-Outputs drinlassen)
- HTML-Export der Notebook(s)
- PDF-Report: max. 8 Seiten (ohne Referenzen), 12pt Times New Roman, einspaltig, einzeilig

> **Hinweis zur Organisation:** Die im Proposal genannten Rollen sind nur formal drin — bei uns gibt es keine festen Rollen. Die Roadmap ist deshalb nach Arbeitspaketen gegliedert, nicht nach Personen.

---

## Phasen-Übersicht

| Phase | Zeitraum | Fokus |
|-------|----------|-------|
| 1 | bis ~14.06. | Data Engineering & Setup |
| 2 | ~14.–19.06. | Cleaning & Processing |
| 3 | ~19.–24.06. | Analyse & Modelling |
| 4 | ~24.–28.06. | Legal/Ethics & Report |
| 5 | ~28.–30.06. | Finalisierung & Abgabe |

---

## Phase 1 — Data Engineering & Setup (bis ~14.06.)

- [ ] Spark-Umgebung aufsetzen (lokal, `local[*]`, wie in Lab 4)
- [ ] Reddit-Monthsdumps besorgen und entpacken
- [ ] Auf die vier Subreddits filtern: r/cyberpunkgame, r/LowSodiumCyberpunk, r/Games, r/pcgaming
- [ ] Auf das 34-Monats-Fenster filtern (Dez 2020 – Dez 2023)
- [ ] Steam-Reviews-Dataset für Cyberpunk 2077 ingestieren
- [ ] Patch-Timeline-Tabelle anlegen (Patches bis 2.0 / Phantom Liberty)
- [ ] Git-Repo aufsetzen

> **Größtes Risiko: Datengröße.** Zuerst mit einem Sample (1–2 Monate) arbeiten, damit die Pipeline früh läuft, bevor das volle Fenster gezogen wird.

## Phase 2 — Cleaning & Processing (~14.–19.06.)

- [ ] Cleaning-Stage für Reddit-JSON und Steam-Reviews (Preprocessing aus Lab 2)
- [ ] Filtering & Spark-SQL-Aggregationen
- [ ] Cross-Source-Join gegen die Patch-Timeline
- [ ] Prüfen, dass die Pipeline unverändert von Sample auf volles Fenster skaliert

## Phase 3 — Analyse & Modelling (~19.–24.06.)

- [ ] VADER als Spark-UDF auf alle Comments und Reviews anwenden
- [ ] Topic-Analyse: Wortfrequenz, TF-IDF, einfacher LDA-Pass
- [ ] Review-Bombing-Anomalie-Flag (Volume-Anomaly-Detection)
- [ ] Beide Sentiment-Zeitreihen gegen die Patch-Timeline ausrichten
- [ ] Kernthese prüfen: Reddit erholt sich schneller als Steam
- [ ] Visualisierungen erstellen

## Phase 4 — Legal/Ethics & Report (~24.–28.06.)

- [ ] Lizenz-Sektion Reddit (User Agreement, Public Content Policy, Data API Terms)
- [ ] Lizenz-Sektion Steam (Steamworks Web API Terms)
- [ ] GDPR- und Fairness-Sektion
- [ ] Review-Bombing- und Conflict-of-Interest-Mitigationen dokumentieren
- [ ] Report schreiben (8-Seiten-Limit, Format beachten)
- [ ] Bibliographie finalisieren

> Phase 4 kann komplett **parallel** zu Phase 1–3 laufen. Report-Rohbau früh anfangen.

## Phase 5 — Finalisierung & Abgabe (~28.–30.06.)

- [ ] Notebook komplett durchlaufen lassen, Zell-Outputs drinlassen, speichern
- [ ] HTML-Export ziehen
- [ ] README schreiben
- [ ] PDF gegen Formatvorgaben prüfen (8 Seiten, 12pt TNR, einspaltig, einzeilig)
- [ ] Alles als 1 ZIP packen und hochladen

---

**Finale Abgabe: 30.06.2026**
