# Anatomy of a Redemption
### Spark-Based Multi-Source Sentiment Analysis of Cyberpunk 2077

Lab Group 1 — Data Processing 2, SS 2026

---

## Overview

Batch pipeline in Apache Spark processing Reddit comments and Steam reviews for Cyberpunk 2077
over a 34-month window (Dec 2020 – Dec 2023), assigning sentiment via VADER and aligning
the two sentiment time series against a patch timeline.

---

## Important: Data is NOT in the Repository

The raw Reddit dumps (tens to hundreds of GB) are **not** in this repository and
**not** in the submission ZIP — they are too large for Git/GitHub. The repository/ZIP contains only:

- all code (`notebooks/`, `src/`)
- a **small sample** under `data/sample/`, with which the pipeline can be demonstrated

To reproduce the full pipeline, the raw data must be downloaded first
(see below) and placed under `data/raw/`.

---

## Folder Structure

```
.
├── .gitignore
├── README.md
├── notebooks/
│   └── pipeline.ipynb        # main notebook (runs end-to-end)
├── src/                      # helper functions (optional)
├── results/                  # final, aggregated outputs for the report (small, IN the repo)
│   ├── figures/              # exported plots (.png)
│   └── RUN_INFO.txt          # mode + data window of the run
└── data/                     # NOT in Git (except sample/)
    ├── raw/                  # downloaded Reddit dumps + Steam CSV
    ├── processed/            # filtered Parquet intermediates
    └── sample/               # small sample for the ZIP (1-2 months), IN Git
        └── patch_timeline.csv  # manually maintained patch table (small, belongs in the repo)
```

---

## Obtaining the Data

### Reddit (Pushshift Monthly Dumps)
1. Download monthly dumps for **Dec 2020 – Dec 2023**
   (e.g. via academic torrents / Pushshift archive, `.zst`-compressed, line-delimited JSON).
2. Place files under `data/raw/reddit/`, **do not unpack** —
   Spark reads `.zst` directly.

### Steam Reviews
1. Download the public Steam Reviews dataset, filter for Cyberpunk 2077 (App-ID 1091500).
2. Place as CSV under `data/raw/steam/`.

### Patch Timeline
- `data/sample/patch_timeline.csv` — small, manually maintained table:
  `patch_name, release_date, platform, notes` (1.0 Launch ... 2.1 / Phantom Liberty).
- Unlike the large dumps, this file is **already in the repository** (small, non-personal)
  and is pre-filled — it does not need to be obtained separately. Applies to both `sample`
  and `full` mode.

---

## Setup

```bash
# create venv (optional, recommended)
python3 -m venv .venv && source .venv/bin/activate

# dependencies
pip install pyspark findspark vaderSentiment pandas matplotlib

# start Jupyter
jupyter notebook notebooks/pipeline.ipynb
```

> For the full run: machine with ~16 GB+ RAM and ample free disk space
> (generously 200 GB+ for intermediates). Development runs on the sample; the full
> run is done once for the final submission.

---

## Running the Pipeline

The notebook runs end-to-end. Use the `DATA_MODE` variable at the top of the notebook
to switch between sample and full dataset:

```python
DATA_MODE = "sample"   # "sample" for fast iteration, "full" for the final run
```

The remaining code is unchanged — Spark scales the same pipeline from sample to the
full window.

---

## Outputs & Report Mapping

The pipeline writes its **final, aggregated** results to `results/`
(separate folder, distinct from `data/processed/` which holds only intermediates).
These files are small and non-personal — they may be included in the repository/ZIP.
The report is written exclusively from these files, **not** by re-running the full pipeline.

| Output File                          | Content / Schema                                                   | Used in Report                                      |
|--------------------------------------|--------------------------------------------------------------------|-----------------------------------------------------|
| `results/sentiment_timeseries.csv`   | `source, month, mean_sentiment, n` (Reddit + Steam, monthly)       | Main figure: two sentiment curves                   |
| `results/patch_overlay.csv`          | `patch_name, release_date` (for overlay on the time series)        | Patch markers on the main figure                    |
| `results/recovery_metric.csv`        | `source, trough_month, recovery_month, recovery_days` per source   | **Core thesis** (Reddit recovers faster than Steam) |
| `results/anomaly_flags.csv`          | `source, month, n, is_anomaly` (volume anomaly / review bombing)   | Review-bombing section + robustness                 |
| `results/sentiment_excl_bombing.csv` | Sentiment time series **excluding** flagged windows                | Metrics "with and without" bombing windows          |
| `results/topics.csv`                 | `topic_id, top_terms, weight` (LDA / TF-IDF)                       | Topic analysis section                              |
| `results/figures/`                   | exported `.png` of final plots                                     | embedded directly in the report                     |

**Rule:** Every number and every figure in the report must be traceable to exactly one file under
`results/`. If a claim appears in the report without a source here, either an output is missing
or the claim does not belong in the report.

### Reproducibility

To keep every report figure traceable:

- **Parameters centrally** at the top of the notebook (one block), not scattered across cells:
  `DATA_MODE`, time window, subreddit list, anomaly threshold, number of LDA topics.
- **Set seed** for everything stochastic — especially the LDA pass
  (`setSeed(...)`), so topics remain stable across runs.
- The **`results/` snapshot comes from the full run** (`DATA_MODE = "full"`), not the sample.
  Record the mode and data window used in `results/RUN_INFO.txt`.

---

## Team

Lab Group 1 — no fixed roles; work distributed by work packages (see Roadmap).
