/**
 * DSH Plugin: Insurance Product Analyst (InsureGuide / 险析君)
 *
 * Registers a tool that injects the system prompt of a professional insurance
 * product analysis expert, enabling DeepSeek to decipher policy clauses, evaluate
 * cost-effectiveness, compare products, and advise coverage based on family
 * structure, budget, and health conditions.
 */

export const name = '@kevinsales/dsh-insurance-product-analyst';
export const inject = ['tools'] as const;

/** Expert system prompt injected into the conversation when the tool is called. */
const EXPERT_SYSTEM_PROMPT = `你现在是"险析君"，一位专业的保险产品分析专家。你熟悉寿险、重疾险、医疗险、年金险等产品形态。你擅长把复杂的保险条款翻译成通俗语言，横向比较不同产品的性价比，并依据用户的家庭结构、预算与健康状况，给出合适的投保配置建议。

## 核心能力

1. 条款拆解：解析寿险、重疾险、医疗险、年金险等的保障责任、免责条款、等待期、犹豫期、现金价值、续保条件与理赔规则，用大白话讲清楚"保什么、不保什么"。
2. 性价比评估：横向比较同类产品的保障范围、保费、杠杆率、赔付次数/比例、特药清单、绿色通道等，量化"值不值"。
3. 险种与组合对比：比较消费型 vs 返还型、定期 vs 终身、重疾单次 vs 多次赔付、增额终身寿 vs 年金险等，说明各自的适用场景与组合方式。
4. 投保方案规划：依据家庭结构、预算、负债（如房贷）、已有保单与健康状况，测算保额（收入替代、双十原则等），给出保障优先级与投保顺序。
5. 避坑提示：识别销售误导高发点（返还型陷阱、捆绑销售、健康告知遗漏、早期现金价值过低等），并提醒如实告知的重要性。

## 工作流程

1. 明确需求：想买/对比哪类险种、为谁买、预算多少、关注点与健康状况（含既往症、体检异常）。
2. 提取条款与费率：梳理产品关键条款、责任、免责与费率，建立统一的对比维度。
3. 横向对比：用表格对比核心差异（保费/保额/保障/免责/续保/现金价值），标注优劣势。
4. 个性化建议：结合家庭结构、预算与健康状况给出配置方案、优先级与投保顺序，并提示健康告知与免责重点。

## 输出规范

- 用对比表呈现核心差异（保费/保额/保障/免责/续保）。
- 区分"产品事实"与"我的建议"，建议必须结合用户的具体信息，避免空泛结论。
- 涉及健康告知与免责，必须提醒如实告知的重要性。
- 不承诺理赔结果，只做条款与性价比分析。

## 注意事项

- 不替代专业投保咨询与核保结论；重大决策建议用户向持牌顾问或保险公司确认。
- 保持客观中立，不做具体公司的销售引导。
- 重疾/医疗定义以最新行业规范为准；产品信息需注明时点，避免用过时的费率或条款做结论。
- 保险费率以官网费率表为唯一准确来源，不以第三方测算替代。
- 涉及现金价值和 IRR 测算时，须取自保险公司官网披露的现金价值表。`;

export function apply(ctx: any, config: any = {}) {
  ctx.tools.register({
    name: 'insurance_product_analyst',
    description:
      '保险产品分析专家（险析君）— 条款拆解、性价比评估、产品对比、投保方案规划。适用于：重疾险对比、寿险费率测算、医疗险选择、年金险IRR计算等。',
    parameters: {
      type: 'object',
      properties: {
        question: {
          type: 'string',
          description: '用户的保险产品问题，例如"对比某两款重疾险的性价比"',
        },
        product_type: {
          type: 'string',
          enum: ['life', 'critical_illness', 'medical', 'annuity', 'whole_life', 'term', 'universal', 'comparison'],
          description: '（可选）险种类型：寿险 / 重疾险 / 医疗险 / 年金险 / 终身寿险 / 定期寿险 / 增额终身寿 / 产品对比',
        },
        budget: {
          type: 'string',
          description: '（可选）预算范围，如"年缴1万以内"',
        },
        family_info: {
          type: 'string',
          description: '（可选）家庭结构信息，如"30岁男、有房贷、一家三口"',
        },
      },
      required: ['question'],
    },
    execute: async (args: {
      question: string;
      product_type?: string;
      budget?: string;
      family_info?: string;
    }) => {
      const context = [
        args.product_type ? `险种类型：${args.product_type}` : '',
        args.budget ? `预算：${args.budget}` : '',
        args.family_info ? `家庭情况：${args.family_info}` : '',
        `用户问题：${args.question}`,
      ]
        .filter(Boolean)
        .join('\n');

      return {
        systemPrompt: EXPERT_SYSTEM_PROMPT,
        instruction: `请按照上述专家系统提示，以保险产品分析专家"险析君"的专业身份回答以下问题：\n\n${context}`,
      };
    },
  });
}
