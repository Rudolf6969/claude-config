# Global Claude Code Instructions

## Jazyk
Vždy komunikuj po **slovensky**, bez výnimiek.

## Osobnosť & štýl
- Rýchly, priamy, žiadne zbytočné frázy
- Robiť hneď, nie presviedčať ani vysvetľovať
- Najvyššia kvalita vždy — žiadny generic AI slop
- Unikátny dizajn, vlastné riešenia, nie kopíruj šablóny

---

## Nainštalované nástroje — POUŽÍVAJ VŽDY

### GSD Framework
Príkazy v `~/.claude/commands/gsd/` — pre každý väčší projekt:
- `/gsd:new-project` — init projektu (questioning → research → roadmap)
- `/gsd:plan-phase N` — naplánuj fázu
- `/gsd:execute-phase N` — spusti fázu (paralelné wave agenty)
- `/gsd:quick [--discuss] [--full]` — rýchle ad-hoc tasky
- `/gsd:progress` — stav + routing
- `/gsd:verify-work` — verifikácia
- `/gsd:debug` — systematický debugging

Workflows: `~/.claude/get-shit-done/workflows/`
GSD agents: `~/.claude/get-shit-done/agents/`
Model profile default: **balanced** (opus pre planning, sonnet pre execution)

### Skills
Dostupné v `~/.claude/skills/`:

**web-fetch** — keď WebFetch tool zlyhá alebo stránka je JS-rendered:
```bash
bun ~/.claude/skills/web-fetch/fetch.ts "<url>"
```
Deps nainštalované (linkedom + turndown).

**react-best-practices** — 58 Vercel React/Next.js pravidiel (waterfalls, bundle, rerender, server). Použi pri každom React kóde automaticky. Rules v `~/.claude/skills/react-best-practices/rules/`

**composition-patterns** — React composition patterns (compound components, boolean props, React 19 no-forwardRef). Použi pri návrhu komponentov.

**react-native-skills** — React Native + Expo best practices (FlashList, Reanimated, native navigators). Použi pri mobile projektoch.

**deploy-to-vercel** — Deployment na Vercel (CLI / git push / no-auth fallback). Použi keď treba deploynúť. Pre Claude Code: `bash ~/.claude/skills/deploy-to-vercel/resources/deploy.sh [path]`

**web-design-guidelines** — UI/UX audit podľa Vercel Web Interface Guidelines. Fetchuje live pravidlá z GitHub. Použi pri "review UI" / "audit design".

**artifacts-builder** — React+TS+Vite+shadcn → single bundled HTML:
```bash
bash ~/.claude/skills/artifacts-builder/scripts/init-artifact.sh <nazov>
```

**canvas-design** — PNG/PDF vizuál cez 2-step: philosophy prompt → canvas code

**brand-guidelines** — brand identity (farby, fonty, pravidlá použitia)

**xlsx** — Excel/spreadsheet: tvorba, formuly, data analýza, vizualizácie. Použi pre trading reports, backtest tabuľky, P&L tracking

**csv-data-summarizer** — Auto-detekuje typ dát (financial/sales/operational), okamžite robí full EDA + vizualizácie bez otázok. `analyze.py` pre pandas analýzu. Ideálne pre MT5 CSV exporty a backtest výsledky

**pdf** — PDF: extrakcia textu/tabuliek, tvorba, merge/split, forms

**docx** — Word dokumenty: tvorba, editácia, tracked changes, comments

**pptx** — PowerPoint prezentácie: tvorba, editácia, layouts, speaker notes

**pwa** — Progressive Web App pre Vite+React stack. `vite-plugin-pwa` + Workbox + **PWABuilder** (Microsoft). Deploy PWA → pwabuilder.com → Google Play (TWA) + iOS App Store (WKWebView) + Windows Store. Updates automatické cez web server. Kompletný guide v SKILL.md

**webhook-handler-patterns** — Production webhook best practices (Hookdeck). Verify → Parse → Handle idempotently. Response kódy, retry logic, idempotency checklist, framework guides (Express, Next.js, FastAPI). Použi pri každom webhook handleri.

**stripe-webhooks** — Stripe webhook handler. Signature verification (raw body!), event types (payment_intent.succeeded, subscription, invoice), Express + Next.js + FastAPI príklady.

**resend-webhooks** — Resend email webhooky. Email delivery events (delivered, bounced, complained).

**clerk-webhooks** — Clerk auth webhooky. User created/updated/deleted, session events.

**shopify-webhooks** — Shopify e-commerce webhooky. Orders, products, customers, inventory.

**paddle-webhooks** — Paddle billing webhooky (alternatíva k Stripe, zabudovaný daňový systém).

**github-webhooks** — GitHub repo webhooky. Push, PR, issues, CI/CD triggers.

**vercel-webhooks** — Vercel deployment webhooky. Deploy started/ready/error events.

**openai-webhooks** — OpenAI async webhooky. Batch API, fine-tuning job completion.

**supabase-postgres-best-practices** — Supabase/Postgres best practices (v1.1.0, jan 2026). 35 pravidiel v 8 kategóriách: query performance (indexy, N+1, pagination), connection pooling, RLS security, schema design, locking, monitoring (EXPLAIN ANALYZE, pg_stat_statements). Použi pri každom Supabase/Postgres kóde automaticky.

**capacitor-plugins** — Katalóg 80+ Capgo Capacitor pluginov. Použiť keď PWA nestačí a treba natívne API. Pokrýva: biometria, camera, platby (Apple/Google Pay, IAP), BLE, NFC, HealthKit, live updates (OTA), social login, sensors, SQLite, background geolocation, speech, LLM on-device, Apple Watch, a ďalšie.

### Agents
Dostupné v `~/.claude/agents/` — volaj ich cez Agent tool:
- **code-reviewer** — code review (git diff → prioritný feedback)
- **context-manager** — správa kontextu pri dlhých taskoch
- **debugger** — root cause analýza (nie symptómy)
- **technical-researcher** — hĺbkový research s cross-validáciou
- **test-automator** — tvorba test suites (unit/integration/e2e)

### Trading Skills (Gold + Crypto)
Nainštalované v `GoldTrading/gold-web-terminal/.claude/skills/` — 19 skills.
Pri akomkoľvek trading/finance tasku použi relevantný skill automaticky.

**Market Data (free APIs):**
- **alpha-vantage** — Gold spot (GOLD_SILVER_SPOT), BTC/USD, FX_INTRADAY 5min, 50+ tech indikátory. API key z alphavantage.co (free tier dostupný)
- **fred-economic-data** — 800K+ macro sérií: Fed rates, CPI, DXY, GDP. Free, no key needed
- **hedgefundmonitor** — OFR hedge fund leverage/positioning. Free, no key
- **usfiscaldata** — US Treasury, národný dlh, úrokové sadzby. Free, no key

**Market Analysis:**
- **technical-analyst** — Chart image → S/R levels, trendy, 3 scenáre s pravdepodobnosťami
- **market-environment-analysis** — VIX, DXY, risk-on/off, commodities sentiment
- **economic-calendar-fetcher** — FOMC, CPI, NFP events (FMP API key potrebný)
- **market-news-analyst** — Geopolitical/FOMC news → konkrétny Gold/Crypto dopad

**Time Series & Forecasting:**
- **aeon** — Time series ML na M5 dátach: anomaly detection, forecasting, segmentation
- **timesfm-forecasting** — Zero-shot XAUUSD/BTC forecasting (Google model, bez tréningu)
- **statsmodels** — ARIMA, GARCH, econometrics pre price modeling

**Optimization & ML:**
- **pymoo** — Multi-objective optimalizácia (NSGA-II/III) — nahradza grid search pri bot parametroch. Pareto fronts pre trade-off medzi PF/WR/MaxDD
- **scikit-learn** — ML pipelines, feature engineering, hyperparameter tuning
- **shap** — Explainability — prečo bot vstúpil/nevstúpil, feature importance
- **polars** — Fast DataFrame pre 99K M5 barov (rýchlejší ako pandas)

**Probabilistic & RL:**
- **pymc** — Bayesian/Monte Carlo: risk modeling, position sizing, uncertainty quantification
- **stable-baselines3** — RL trading agenty: PPO, SAC, DQN, TD3 cez Gymnasium
- **pufferlib** — High-perf RL (2-10x rýchlejší ako SB3, custom trading environments)

**Scenario & Risk:**
- **what-if-oracle** — Structured scenario analysis, stress-testing, contingency planning

**Crypto Trading Skills (s Python skriptami):**
- **crypto-signal-generator** — RSI, MACD, BB, Stochastic, ADX → composite BUY/SELL signal + confidence score. `scanner.py --symbols BTC-USD --detail`
- **crypto-derivatives-tracker** — Funding rates, open interest, liquidations, options (Binance, Bybit, OKX, Deribit). Interpretácia: pozit. funding = bullish, extrémny funding = contrarian signal
- **crypto-sentiment-analyzer** — Fear & Greed Index, news sentiment, market mood analýza
- **crypto-on-chain** — Whale tracking, token flows, network activity
- **crypto-options-flow** — Institutional options positioning, put/call ratio
- **crypto-market-movers** — Volume spikes, gainers/losers, significance score
- **crypto-price-tracker** — Real-time crypto price tracking + trend analysis

**Data Analysis Agents (GoldTrading):**
- **data-explorer** — EDA, štatistiky, pattern discovery na trading dátach (M5 bars, tick data)
- **visualization-specialist** — Charts, equity curves, correlation matrices, distribúcie
- **hypothesis-generator** — Generuje testovateľné hypotézy z dátových vzorov
- **code-generator** — Generuje analýzový kód (Python, pandas, plotly)
- **report-writer** — Komplexné report zo analýzy (markdown/html/pdf)
- **quality-assurance** — Data quality checks, validácia

**Data Analysis Commands (GoldTrading):**
- `/analyze [dataset] [type]` — EDA na datasete (exploratory/statistical/predictive/complete)
- `/do-all [dataset] [domain]` — Full workflow: quality → EDA → hypotheses → vizualizácia → report
- `/visualize [dataset] [chart_type]` — Vizualizácie (trends/distribution/correlation/comparison)
- `/report [dataset] [type] [format]` — Report (summary/complete/executive/technical)
- `/hypothesis [dataset] [domain]` — Research hypotézy z dátových vzorov
- `/quality [dataset]` — Data quality audit

**Commands (GoldTrading):**
- `/trading-ideas [TICKER]` — Institutional equity research: BUY/SELL/HOLD, price targets, fundamentals, insider signals, options flow. Užitočné pre gold miners (NEM, GOLD, AEM) a crypto companies (COIN, MSTR)
- `/openbb-macro` — GDP, inflation, rates, employment cez OpenBB Platform
- `/openbb-crypto [SYMBOL]` — Crypto price, on-chain metrics, DeFi analytics cez OpenBB
- `/openbb-equity [TICKER]` — Equity fundamentals, technicals, analyst targets
- `/openbb-options [TICKER]` — Options chain, IV, Greeks, unusual activity
- `/openbb-portfolio` — Portfolio analytics, risk metrics, performance attribution
- `/openbb-research [QUERY]` — Broad financial research cez OpenBB

---

## Pracovné pravidlá

### Paralelizácia
- Vždy spúšťaj nezávislé Agent calls v jednej správe naraz
- Sub-agenty nesmú spúšťať ďalšie sub-agenty
- Použi najvhodnejší agent pre úlohu

### Web fetching
1. Najprv skús `WebFetch` tool
2. Ak zlyhá (JS-rendered, 404) → `bun ~/.claude/skills/web-fetch/fetch.ts "<url>"`
3. Pre known sites použi CSS selektory (`--include-selector`)

### Frontend / Design
- **NIKDY** nepoužívaj Inter font — Barlow Condensed / Syne / Space Grotesk / Geist
- **NIKDY** generic farby — vždy brand-specific paleta
- Vždy: grain textures, micro-interactions, CSS animations, stagger delays
- Warm blacks miesto čistej #000000
- Brutalné, premium, unikátne — nie corporate template

### Kód
- Minimum complexity pre aktuálnu úlohu
- Žiadne over-engineering, žiadne hypothetické future features
- Fix root cause, nie symptómy
- Preferuj Edit nad Write, čítaj súbory pred editom

### Commits
- Atomic commits po každom dokončenom tasku
- Nikdy `--no-verify`, nikdy force push na main

---

## Projekty (ak je relevantné)

### Veiny Galaxy E-Shop
- `C:\Users\Počítač\Documents\vg-shadcn\` — React 19 + shadcn/ui + Tailwind + vaul
- `C:\Users\Počítač\Documents\vg-preview\` — starší plain React
- Brand: brutal dark, #0A0805 black, #E8000F red, #C8C0B8 chrome
- CDN: bunny-wp-pullzone-dzl1a511ov.b-cdn.net

### Gold Trading
- `C:\Users\Počítač\Documents\GitHub\GoldTrading`
- MT5 bridge: port 8765 | Web terminal: port 3007
- Tick sim: `gold-tick-sim/` — python run_sim.py / tick_optimizer.py
- Detaily: `~/.claude/projects/C--Users-Po--ta-/memory/gold-trading.md`
