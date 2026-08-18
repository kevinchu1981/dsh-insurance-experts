# DSH Insurance Experts - 完整发布指南

本指南将三个 WorkBuddy 保险专家转化为 DeepSeek Harness (DSH) 插件，发布到 npm 和 GitHub，并加入 DSH 插件生态。

## 项目概览

| 插件 | npm 包名 | 工具名 | 核心能力 |
|------|---------|--------|---------|
| 保险经营分析专家（盈安） | `@kevinsales/dsh-insurance-ops-analyst` | `insurance_ops_analyst` | 偿付能力、盈利能力、EV、投资风险、监管合规 |
| 保险公司经营与财务分析专家 | `@kevinsales/dsh-insurance-company-analyst` | `insurance_company_analyst` | 财务分析、渠道结构、同业对比 |
| 保险产品专家（险析君） | `@kevinsales/dsh-insurance-product-analyst` | `insurance_product_analyst` | 条款拆解、性价比评估、产品对比、投保方案 |

---

## 前置准备

### 1. npm 账号
- 注册：https://www.npmjs.com/signup
- 登录：终端运行 `npm login`，输入用户名、密码和邮箱
- **重要**：检查 `@dsh-insurance` scope 是否可用。如果已被占用，需要改为你的 npm 用户名 scope（如 `@yourname/ops-analyst`），并同步修改各 package.json

### 2. GitHub 账号 + CLI
- 注册：https://github.com/signup
- 安装 GitHub CLI：https://cli.github.com/
- 登录：`gh auth login`

### 3. DeepSeek Harness (DSH)
- 安装：`npm install -g @anthropic/dsh`（或按官方文档安装）
- 确认 `dsh` 命令可用：`dsh --version`

---

## 六步发布流程

### 步骤一：提取专家系统提示词 ✅ 已完成

已从三个 WorkBuddy 专家的 Agent MD 文件中提取完整系统提示词，嵌入到各插件的 `src/index.ts` 中。

### 步骤二：创建 DSH 插件项目 ✅ 已完成

项目结构：
```
dsh-insurance-experts/
├── packages/
│   ├── insurance-ops-analyst/
│   │   ├── package.json          # npm 包配置 + DSH bundle 声明
│   │   ├── cordis.patch.yml      # Cordis 配置树插入点
│   │   ├── tsconfig.json         # TypeScript 编译配置
│   │   └── src/index.ts          # 插件核心逻辑（专家系统提示词 + 工具注册）
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
├── scripts/
│   ├── local-test.sh             # 本地测试脚本 (Linux/macOS)
│   ├── publish.sh                # 发布脚本 (Linux/macOS)
│   └── publish.ps1               # 发布脚本 (Windows PowerShell)
├── package.json                   # monorepo workspace 根配置
├── tsconfig.json                  # TypeScript 基础配置
├── .npmrc                         # npm 发布配置
├── .gitignore
├── LICENSE                        # MIT 许可证
└── README.md
```

### 步骤三：编译 TypeScript ✅ 已完成

所有三个插件已成功编译，产物在各自 `dist/` 目录下：
- `dist/index.js` — 编译后的 JavaScript（DSH 运行时加载）
- `dist/index.d.ts` — TypeScript 类型声明

如需重新编译：
```bash
cd dsh-insurance-experts
npm install          # 安装依赖
npm run build        # 编译所有包
```

### 步骤四：本地测试

#### 方式一：使用测试脚本
```bash
# Linux/macOS
chmod +x scripts/local-test.sh
./scripts/local-test.sh

# Windows (Git Bash)
bash scripts/local-test.sh
```

#### 方式二：手动测试
```bash
# 1. 添加插件到 DSH（link 方式）
dsh plugin --profile web add "link:./packages/insurance-ops-analyst"
dsh plugin --profile web add "link:./packages/insurance-company-analyst"
dsh plugin --profile web add "link:./packages/insurance-product-analyst"

# 2. 启动 DSH web 服务
dsh web

# 3. 浏览器打开 http://127.0.0.1:3080
# 4. 在对话中测试：
#    - "用盈安的身份分析某寿险公司2024年偿付能力下降的原因"
#    - "对比两家保险公司的NBV增速和渠道结构"
#    - "帮我对比某两款重疾险的性价比，预算年缴1万以内"

# 5. 测试完成后移除插件
dsh plugin --profile web remove insurance-ops-analyst
dsh plugin --profile web remove insurance-company-analyst
dsh plugin --profile web remove insurance-product-analyst
```

### 步骤五：发布到 npm 和 GitHub

#### 方式一：使用发布脚本（推荐）

**Windows PowerShell：**
```powershell
.\scripts\publish.ps1
```

**Linux/macOS：**
```bash
chmod +x scripts/publish.sh
./scripts/publish.sh
```

#### 方式二：手动逐步发布

**5.1 发布到 npm：**
```bash
# 确保已登录
npm login

# 编译
npm run build

# 逐个发布
cd packages/insurance-ops-analyst && npm publish --access public && cd ../..
cd packages/insurance-company-analyst && npm publish --access public && cd ../..
cd packages/insurance-product-analyst && npm publish --access public && cd ../..
```

**5.2 推送到 GitHub：**
```bash
# 初始化 Git
git init
git add -A
git commit -m "feat: DSH insurance expert plugins"

# 创建 GitHub 仓库（需安装 gh CLI）
gh repo create dsh-insurance-experts --public --source=. --remote=origin --push

# 或手动创建仓库后推送：
# git remote add origin https://github.com/YOUR_USERNAME/dsh-insurance-experts.git
# git branch -M main
# git push -u origin main
```

### 步骤六：加入 DSH 插件生态

**6.1 添加 GitHub Topic 标签**

发布到 GitHub 后，给仓库添加 `dsh-plugin` topic：

```bash
# 使用 gh CLI 自动添加
gh api -X PUT "/repos/YOUR_USERNAME/dsh-insurance-experts/topics" \
  -f "names[]=dsh-plugin" \
  -f "names[]=deepseek" \
  -f "names[]=deepseek-harness" \
  -f "names[]=insurance" \
  -f "names[]=cordis" \
  -f "names[]=ai-plugin"
```

或手动操作：
1. 打开 GitHub 仓库页面
2. 右侧 About 区域 → 点击齿轮图标
3. 在 Topics 中添加：`dsh-plugin`、`deepseek`、`insurance`、`cordis`、`ai-plugin`

**6.2 生态自动收录**

添加 `dsh-plugin` topic 后，以下渠道会自动扫描并收录你的插件：

| 收录渠道 | 机制 | 说明 |
|---------|------|------|
| GitHub `dsh-plugin` topic | 自动扫描 | 加标签即被 awesome-dsh 列表收录 |
| Oh-My-DSH 精选目录 | 社区维护 | 1117+ 精选插件，社区审核后收录 |
| dsh-market | 第三方市场 | GUI 插件市场，支持热安装 |
| deepseekharnessplugins.com | 前端目录站 | 自动从 GitHub 拉取 |

**6.3 验证发布**

```bash
# 验证 npm 包可搜索
npm search @kevinsales/dsh-insurance-ops-analyst

# 验证可通过 npm 安装
dsh plugin --profile web add @kevinsales/dsh-insurance-ops-analyst
dsh plugin --profile web add @kevinsales/dsh-insurance-company-analyst
dsh plugin --profile web add @kevinsales/dsh-insurance-product-analyst

# 验证可通过 GitHub 安装
dsh plugin --profile web add "github:YOUR_USERNAME/dsh-insurance-experts#main"
```

---

## 发布后的维护

| 操作 | 命令 |
|------|------|
| 更新版本号 | `npm version patch` （在对应包目录下） |
| 重新发布 | `npm publish` |
| 更新 GitHub | `git push origin main` |

---

## 注意事项

1. **npm scope 名称**：本指南使用 `@dsh-insurance` 作为 npm scope。如果该 scope 已被注册，需要改为你的个人 scope（如 `@yourname/`），并同步修改所有 package.json 中的 `name` 字段和 cordis.patch.yml 中的 `name` 字段。

2. **DSH 版本兼容性**：本插件基于 Cordis 框架开发，适用于 DeepSeek Harness 最新版本。如遇 API 变更，请参考 DSH 官方文档调整 `ctx.tools.register` 接口。

3. **专家系统提示词更新**：如需更新专家的分析框架或方法论，修改对应插件的 `src/index.ts` 中的 `EXPERT_SYSTEM_PROMPT` 常量，重新编译并发布。

4. **多语言支持**：当前系统提示词为中文，面向中文用户。如需支持英文，可在工具参数中添加 `language` 字段，根据参数选择不同的提示词模板。
