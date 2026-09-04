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
│       │   ├── tsconfig.json
│       └── src/index.ts
├── package.json
├── tsconfig.json
└── README.md
```

## 🤖 WorkBuddy Skill 版本（零代码 · 对话即用）

除了上面的 DSH 插件，我们还把保险能力打包成了 **WorkBuddy Skill**，无需写代码，在 WorkBuddy 里对话即可调用。

| Skill | 一句话 | 适合谁 | 安装 |
|---|---|---|---|
| **保险产品建议书** | 专家级产品分析 + 可递送对比建议书，官网口径核验、多模板 PDF 一键出稿 | 保险顾问/经纪人/投保人 | SkillHub 搜"保险产品建议书" |
| **保险精算师** | 定价·准备金·利润测试·监管报备一套脚本，内置第三/四套生命表与国内某头部财产险公司真实案例 | 精算师/产品/保险学生 | SkillHub 搜"保险精算师" |

### 为什么用 Skill 版而不是插件版？
- **零环境**：不用装 Python/依赖，WorkBuddy 内直接对话触发。
- **可核验**：建议书 skill 强制附官网产品说明书/条款/费率表链接，客户自核。
- **开箱即跑**：精算师 skill 内置中国经验生命表与已验证的国内某头部财产险公司商业车险案例。

### 样例
- 保险产品建议书样例输出 → [showcase/保险产品建议书_样例输出.md](showcase/保险产品建议书_样例输出.md)
- 保险精算师样例输出（含国内某头部财产险公司对标）→ [showcase/保险精算师_样例输出.md](showcase/保险精算师_样例输出.md)

### 反馈
用过觉得好/不好，都欢迎到 SkillHub 点赞或留评，或在仓库提 Issue 🙏

## License

MIT
