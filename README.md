# DSH Insurance Experts

DeepSeek Harness (DSH) plugins for insurance analysis — three specialized AI expert tools powered by system prompts originally built for WorkBuddy Expert Center.

## Plugins

| Plugin | npm Package | Tool Name | Description |
|--------|------------|-----------|-------------|
| Ops Analyst (Ying'an / 盈安) | `@kevinsales/dsh-insurance-ops-analyst` | `insurance_ops_analyst` | Insurance company operations: solvency, profitability, EV, investment risk, regulatory compliance |
| Company Analyst | `@kevinsales/dsh-insurance-company-analyst` | `insurance_company_analyst` | Insurance company financial & operating analysis: financials, channels, peer comparison |
| Product Analyst (InsureGuide / 险析君) | `@kevinsales/dsh-insurance-product-analyst` | `insurance_product_analyst` | Insurance product analysis: clause decoding, cost-effectiveness, product comparison, coverage planning |

## Installation

### Via npm

```bash
dsh plugin --profile web add @kevinsales/dsh-insurance-ops-analyst
dsh plugin --profile web add @kevinsales/dsh-insurance-company-analyst
dsh plugin --profile web add @kevinsales/dsh-insurance-product-analyst
```

### Via GitHub

```bash
dsh plugin --profile web add "github:kevinsales/dsh-insurance-experts#main"
```

### Local link (for development)

```bash
dsh plugin --profile web add "link:./packages/insurance-ops-analyst"
dsh plugin --profile web add "link:./packages/insurance-company-analyst"
dsh plugin --profile web add "link:./packages/insurance-product-analyst"
```

## Usage

After installation, the tools are automatically available in DeepSeek conversations. Example prompts:

- "用盈安的身份分析某寿险公司2024年偿付能力下降的原因"
- "对比两家保险公司的NBV增速和渠道结构"
- "帮我对比某两款重疾险的性价比，预算年缴1万以内"

## Build

```bash
npm install
npm run build
```

## Project Structure

```
dsh-insurance-experts/
├── packages/
│   ├── insurance-ops-analyst/
│   │   ├── package.json
│   │   ├── cordis.patch.yml
│   │   ├── tsconfig.json
│   │   └── src/index.ts
│   ├── insurance-company-analyst/
│   │   ├── package.json
│   │   ├── cordis.patch.yml
│   │   ├── tsconfig.json
│   │   └── src/index.ts
│   └── insurance-product-analyst/
│       ├── package.json
│       ├── cordis.patch.yml
│       ├── tsconfig.json
│       └── src/index.ts
├── package.json
├── tsconfig.json
└── README.md
```

## License

MIT
