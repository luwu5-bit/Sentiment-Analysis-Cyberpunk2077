# Key Findings — Anatomy of a Redemption

Data-grounded summary written from the `results/` snapshot of the **full run**
(`DATA_MODE = full`, 34-month window Dec 2020 – Dec 2023, 7,837,729 documents;
see `RUN_INFO.txt`). Every number below traces to a file in `results/`.

The headline thesis from the proposal — *"Reddit sentiment recovers faster than Steam"* —
is **not supported** by the full data: monthly mean VADER sentiment never turns negative for
either source, so there is no "crash" to recover from in the average. The launch crisis is
instead a **volume** phenomenon, and the redemption is **asymmetric** across platforms. Four findings:

## 1. The redemption is real but lives in the Steam reviews
Steam's monthly mean sentiment dips to its trough of **0.4243 (May 2021)**, then climbs steadily —
visibly after the 1.5 next-gen overhaul (Feb 2022) — to a peak of **0.5444 (May 2022)** and a high,
stable **2023 plateau of ~0.507**. Reddit, by contrast, is essentially **flat** (launch-quarter mean
0.138 vs. 2023 plateau 0.136, `climb = -0.002`): no comparable redemption arc.
→ `redemption_metrics.csv`, `figures/sentiment_timeline.png`, `figures/redemption_climb.png`

## 2. A large, persistent level gap (Steam ≫ Reddit)
Across the whole window, Steam sentiment (overall mean **0.498**) sits **0.348** above Reddit
(overall mean **0.150**). This is a medium effect, not a contradiction: a Steam review is a
decisive recommend/don't-recommend verdict (positive-skewed), whereas Reddit is critical,
debate-heavy discussion that scores systematically lower in VADER.
→ `redemption_metrics.csv`, `figures/sentiment_timeline.png`

## 3. The launch crisis is a volume shock, not a sentiment collapse
December 2020 is the only anomaly-flagged month for **both** sources — a massive volume spike of
**1,689,865** Reddit documents and **114,126** Steam reviews (z ≈ 5.7 / 5.9) — yet the monthly
mean sentiment stays clearly positive throughout. The outrage is in *how much* people posted, not
in an average that flips negative.
→ `anomaly_flags.csv`, `figures/volume_timeline.png`

## 4. Cross-platform divergence at the 2.0 / Phantom Liberty relaunch
Exactly when the game is widely declared "fixed" (2.0 + Phantom Liberty, Sep–Oct 2023), the two
platforms move **apart**: Steam rises toward its plateau (0.484 → **0.525**) while Reddit drops to
its **global low (0.109, Oct 2023)**. The celebrated relaunch draws a wave of renewed, scrutinizing
discussion on Reddit even as Steam reviewers are at their most positive.
→ `sentiment_timeseries.csv`, `redemption_metrics.csv`

## Method validation (supporting)
VADER is justified on the labelled Steam side: mean compound **0.573** for *Recommended* vs.
**0.112** for *Not Recommended* (n = 241,688), point-biserial correlation **0.33**, and **77%**
accuracy for the naive rule *compound > 0 ⇒ Recommended*. Topics (LDA) are coherent and
Cyberpunk-specific (story/Johnny/Arasaka, performance/bugs, quests, romance/Judy, Night City builds).
→ `vader_validation.csv`, `figures/vader_validation.png`, `topics.csv`

## Method limitations (VADER)
VADER detects negativity in individual texts, but the **monthly mean** never turns negative — even at
launch. This is a property of the method, not (only) of the sentiment:

- **It is an aggregate.** The mean over ~1.7 M launch-month documents is dominated by the large mass of
  neutral and positive-worded posts (questions, lore, hype, jokes), not by the angry minority.
- **Positive/neutral lexicon bias.** VADER sums word valence; mixed posts ("great game **but** unplayable")
  net slightly positive, and many texts score exactly 0 (neutral).
- **Sarcasm-blind.** Launch backlash was often ironic ("10/10 best slideshow simulator"); VADER reads it
  literally and scores the positive words positively.
- **Domain gap.** VADER's lexicon is general social-media vocabulary. Gaming-specific complaints
  ("bugs", "crashes", "downgrade", "cut content", "unplayable") are largely **not** in its lexicon → scored
  ~0, so real negativity is under-counted while generic positive words ("game", "story", "love") still count.
- **Mis-calibrated zero point.** Our own validation proves it: even human-labelled *Not Recommended* Steam
  reviews average **+0.112** (vs. +0.573 for *Recommended*), and the "compound > 0 ⇒ Recommended" rule is
  only **77 %** accurate. VADER captures the *direction* well, but the neutral boundary for this domain sits
  well above 0 — so "negative" sentiment shows up as *lower positive* values, not as a sign flip.

**Consequence for this study:** the launch crisis appears as a **dip within positive territory** (and a huge
**volume** spike), not as a negative-mean collapse. Report this as a limitation in the Method/Conclusion.

## Supervised baseline (Spark MLlib) vs. VADER
To quantify how much VADER leaves on the table, we trained a **TF-IDF + Logistic Regression** classifier
(Spark MLlib) on the Steam human labels (80/20 split, `seed=42`) and compared it to VADER on the same
held-out test set (n = 48,232; majority-class baseline ≈ 0.83). VADER is shown at threshold 0 and at a
threshold tuned on the train split by **balanced accuracy** (0.37).

| Model | Accuracy | F1 | **AUC** |
|---|---|---|---|
| VADER (thr = 0) | 0.775 | 0.785 | 0.686 |
| VADER (thr = 0.37, tuned) | 0.730 | 0.755 | 0.686 |
| **MLlib LogReg (TF-IDF)** | **0.892** | **0.886** | **0.887** |

**Takeaway.** On the threshold-free, imbalance-robust **AUC**, the trained model (**0.887**) far exceeds
VADER (**0.686**); VADER at threshold 0 even trails the majority-class baseline (0.83). VADER captures the
*direction* of sentiment, but a lightweight domain-trained classifier is much better calibrated for the
recommend/not-recommend decision. We keep VADER for the time-series analysis (it needs no labels and runs
over both unlabelled Reddit and Steam), and report this comparison as a method validation / limitation.
→ `model_comparison.csv`, `figures/model_comparison.png`
