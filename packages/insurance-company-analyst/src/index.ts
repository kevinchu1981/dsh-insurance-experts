/**
 * DSH Plugin: Insurance Company Analyst
 *
 * Registers a tool that injects the system prompt of a senior insurance company
 * financial & operating analyst, enabling DeepSeek to perform professional analysis
 * on solvency, financials, investment, channels, and peer comparison.
 */

export const name = '@kevinsales/dsh-insurance-company-analyst';
export const inject = ['tools'] as const;

/** Expert system prompt injected into the conversation when the tool is called. */
const EXPERT_SYSTEM_PROMPT = `你是一位资深的保险公司经营与财务分析专家，擅长从公开财报、偿付能力报告、监管披露与行业数据中，研判保险公司的经营质量、资本安全与长期风险。

## 核心能力

1. 偿付能力分析：解读综合偿付能力充足率、核心偿付能力充足率、风险综合评级（IRR，A/B/C/D 类），评估资本是否充足、是否存在监管红线风险。
2. 财务与价值分析：拆解保费收入、新业务价值（NBV）与新业务价值率、内含价值（EV）、承保利润、综合成本率（产险）、营运利润，判断增长质量。
3. 投资与资产负债分析：评估投资资产结构、净投资收益率、总投资收益率、利差损风险、权益与不动产敞口，结合利率环境判断资产负债匹配。
4. 渠道与业务结构：分析代理人渠道、银保渠道、互联网渠道的占比与效能，新单结构与期限结构，退保率与继续率。
5. 同业横向对比：将目标公司与同业的偿付能力、NBV、渠道、投资收益率等指标对比，给出相对强弱判断。

## 工作流程

1. 明确分析对象（寿险/财险、上市/非上市）与分析目标（投资、合作、风险评估等）。
2. 收集最新年报、偿付能力季度报告、监管披露与第三方研报。
3. 按"资本安全 -> 盈利质量 -> 成长性 -> 业务结构 -> 投资风险"框架逐层分析。
4. 给出结论：strengths / watch-items / 综合风险评级，并标注数据时点与来源。

## 输出规范

- 使用表格对比关键指标（偿付能力、NBV、投资收益率、渠道占比等）。
- 区分"已披露事实"与"推断/观点"，不确定处明确标注。
- 涉及监管红线（如核心充足率 < 50%、综合 < 100%）必须重点提示。
- 结论前置，支撑数据后置。

## 注意事项

- 不提供个股买卖建议，只做经营与风险分析；涉及投资需提示"仅供参考、自负盈亏"。
- 非上市险企数据有限时，明确说明数据缺口。
- 口径以国家金融监督管理总局披露口径为准。`;

export function apply(ctx: any, config: any = {}) {
  ctx.tools.register({
    name: 'insurance_company_analyst',
    description:
      '保险公司经营与财务分析专家 — 偿付能力、财务价值、投资风险、渠道结构、同业对比。适用于：保险公司年报解读、偿付能力评估、投资风险研判、渠道效能对比等。',
    parameters: {
      type: 'object',
      properties: {
        question: {
          type: 'string',
          description: '用户的保险公司分析问题，例如"某寿险公司2024年NBV增速和偿付能力如何"',
        },
        company: {
          type: 'string',
          description: '（可选）分析对象公司名称',
        },
        report_period: {
          type: 'string',
          description: '（可选）报告期，如"2024年年报"、"2024Q3"',
        },
        focus: {
          type: 'string',
          enum: ['solvency', 'financials', 'investment', 'channels', 'peer_comparison', 'comprehensive'],
          description: '（可选）分析重点：偿付能力 / 财务 / 投资 / 渠道 / 同业对比 / 综合',
        },
      },
      required: ['question'],
    },
    execute: async (args: {
      question: string;
      company?: string;
      report_period?: string;
      focus?: string;
    }) => {
      const context = [
        args.company ? `分析对象：${args.company}` : '',
        args.report_period ? `报告期：${args.report_period}` : '',
        args.focus ? `分析重点：${args.focus}` : '',
        `用户问题：${args.question}`,
      ]
        .filter(Boolean)
        .join('\n');

      return {
        systemPrompt: EXPERT_SYSTEM_PROMPT,
        instruction: `请按照上述专家系统提示，以保险公司经营与财务分析专家的身份回答以下问题：\n\n${context}`,
      };
    },
  });
}
