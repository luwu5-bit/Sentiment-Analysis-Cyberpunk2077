# Project Roadmap — Anatomy of a Redemption
### Spark-Based Multi-Source Sentiment Analysis of Cyberpunk 2077 · Lab Group 1

---

## Current Status

The proposal has been submitted (deadline 29.05.2026). Lab 4 (Kafka + Sentiment Analysis) is done — we now have all the technical building blocks. The next and final hard deadline is the **final submission on 30.06.2026**.

**To submit (1 ZIP):**
- Jupyter Notebook(s) incl. data + README (must run end-to-end, leave cell outputs in)
- HTML export of the notebook(s)
- PDF report: max. 8 pages (excluding references), 12pt Times New Roman, single-column, single-spaced

> **Note on organization:** The roles mentioned in the proposal are formal only — there are no fixed roles. The roadmap is therefore organized by work packages, not by person.

---

## Phase Overview

| Phase | Period       | Focus                        |
|-------|--------------|------------------------------|
| 1     | until ~14.06.| Data Engineering & Setup     |
| 2     | ~14.–19.06.  | Cleaning & Processing        |
| 3     | ~19.–24.06.  | Analysis & Modelling         |
| 4     | ~24.–28.06.  | Legal/Ethics & Report        |
| 5     | ~28.–30.06.  | Finalization & Submission    |

---

## Phase 1 — Data Engineering & Setup (until ~14.06.)

- [x] Set up Spark environment (local, `local[*]`, as in Lab 4)
- [x] Obtain Reddit monthly dumps — **all 4 subreddits** downloaded (`.zst` under `data/raw/reddit/`)
- [x] Filter to the four subreddits: r/cyberpunkgame, r/LowSodiumCyberpunk, r/Games, r/pcgaming
- [x] Filter to the 34-month window (Dec 2020 – Dec 2023)
- [x] Ingest Steam Reviews dataset for Cyberpunk 2077
- [x] Create patch timeline table (patches up to 2.0 / Phantom Liberty)
- [x] Set up Git repository

> **Biggest risk: data size.** Work with a sample (1–2 months) first so the pipeline runs early, before pulling the full window.

## Phase 2 — Cleaning & Processing (~14.–19.06.)

- [x] Cleaning stage for Reddit JSON and Steam Reviews (preprocessing from Lab 2)
- [x] Filtering & Spark SQL aggregations (monthly × source sentiment)
- [x] Cross-source join against the patch timeline — *4b: monthly sentiment ⋈ patch timeline → `sentiment_patch_join.csv`*
- [x] Verify that the pipeline scales unchanged from sample to full window (`DATA_MODE` + sample carve)

## Phase 3 — Analysis & Modelling (~19.–24.06.)

- [x] Apply VADER as Spark UDF to all comments and reviews
- [x] Topic analysis: word frequency, TF-IDF, simple LDA pass — *5e LDA (seeded) + 5f word frequency & TF-IDF*
- [x] Review-bombing anomaly flag (volume anomaly detection) — *5b: monthly volume z-score > threshold → `anomaly_flags.csv`*
- [x] Align both sentiment time series against the patch timeline — *5a: both curves + patch markers → `sentiment_timeline.png`*
- [ ] Verify core thesis: Reddit recovers faster than Steam — *recovery metric coded (5d); verification pending full run (sample = 1 month)*
- [x] Create visualizations — *5a timeline, 5g VADER-validation, 5h volume + TF-IDF bars + recovery (figures under `results/figures/`)*

## Phase 4 — Legal/Ethics & Report (~24.–28.06.)

- [ ] License section Reddit (User Agreement, Public Content Policy, Data API Terms)
- [ ] License section Steam (Steamworks Web API Terms)
- [ ] GDPR and fairness section
- [ ] Document review-bombing and conflict-of-interest mitigations
- [ ] Write report (8-page limit, observe format)
- [ ] Finalize bibliography

> Phase 4 can run completely **in parallel** with phases 1–3. Start the report draft early.

## Phase 5 — Finalization & Submission (~28.–30.06.)

- [ ] Run notebook end-to-end, leave cell outputs in, save
- [ ] Export HTML
- [ ] Write README
- [ ] Check PDF against format requirements (8 pages, 12pt TNR, single-column, single-spaced)
- [ ] Pack everything as 1 ZIP and upload

---

**Final submission: 30.06.2026**
