# 保险精算实操专家（算衡）· DSH 插件

> 定价 · 准备金 · 利润测试 · 监管报备 —— 真正跑计算，非科普。

`@kevinsales/dsh-insurance-actuary` 是 DeepSeek Harness（DSH）插件，把"算衡"精算专家封装为可加载的 agent，内置中国第三 / 四套经验生命表与已验证的国内某头部财产险公司商业车险真实案例，真正运行 BEL+RM、利润测试、IRR 等计算。

## 能做什么

- **寿险 / 分红型增额寿定价建模**：逐岁费率与现金价值测算
- **利润测试**：NBV / VNB / IRR
- **准备金评估**：偿二代二期 BEL + RM
- **内含价值**：EV / NBV
- **财产险定价与损失三角准备金**
- **监管报备材料生成**

## 怎么用

1. 安装 DeepSeek Harness runtime（Cordis 生态）
2. `dsh plugin --profile web add @kevinsales/dsh-insurance-actuary`
3. 给出产品参数 / 披露数据，对话提问即可触发真实计算

> 注意：本包是 DSH 插件，需 DSH runtime 才能运行，并非独立 CLI。

## 对应 WorkBuddy 技能

与 WorkBuddy 专家「保险精算师」同源。请在 WorkBuddy 专家中心搜索「保险精算师」。

## 仓库与反馈

- 源码：https://github.com/kevinchu1981/dsh-insurance-experts
- 问题反馈：https://github.com/kevinchu1981/dsh-insurance-experts/issues

## 许可

MIT
