// OpenAI API クライアント（バックエンドAPI経由）
class OpenAIClient {
  constructor(apiKey) {
    this.apiKey = apiKey; // フロントエンドでは使用しないが、互換性のため保持
    // バックエンドAPIのベースURL（相対パスを使用して同じドメインで動作）
    const API_BASE_URL = import.meta.env.VITE_API_URL || '';
    this.apiBaseURL = API_BASE_URL;
  }

  async generateContent(prompt, userInfo = {}) {
    try {
      console.log('バックエンドAPI経由でOpenAI APIを呼び出し中...');
      
      // 相対パスを使用（同じドメインで配信されているため）
      const apiUrl = this.apiBaseURL ? `${this.apiBaseURL}/api/openai/generate` : '/api/openai/generate';
      
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          prompt: prompt,
          userInfo: userInfo
        }),
        // Microsoft Edgeのサードパーティクッキー無効化に対応
        credentials: 'omit' // クッキーを送信しない
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `API error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      
      // レスポンスの検証
      if (!data || !data.success) {
        throw new Error(data.error || 'Invalid response format from API');
      }
      
      if (!data.content) {
        throw new Error('Content not found in API response');
      }
      
      console.log('バックエンドAPI経由でOpenAI API呼び出し成功');
      return data.content;
    } catch (error) {
      console.error('OpenAI API呼び出しエラー:', error);
      throw new Error(`OpenAI API呼び出しに失敗しました: ${error.message}`);
    }
  }

  generatePrompt(userInfo) {
    return `
あなたは須藤技術士事務所のシニアITコンサルタントです。以下のユーザー情報を基に、商用レベルの詳細なITサービス提案資料を作成してください。

【ユーザー情報】
- お名前: ${userInfo.name}
- 会社名: ${userInfo.company}
- 業界: ${userInfo.industry || '未指定'}
- 役職: ${userInfo.position || '未指定'}
- 興味のある分野: ${userInfo.interest || '未指定'}
- メッセージ: ${userInfo.message || 'なし'}
- 追加要件・ご要望: ${userInfo.additionalRequirements || 'なし'}

【商用レベルの提案内容を作成してください】

1. **サービス概要**
   - 業界の現状と課題分析
   - デジタル変革の必要性
   - 須藤技術士事務所の強みと実績
   - 競合他社との差別化ポイント

2. **推奨サービス**
   - ユーザーの業界・役職に特化したサービス提案
   - 技術スタックとアーキテクチャ設計
   - 段階的な導入ロードマップ
   - 予算とスケジュールの概算

3. **期待される効果**
   - 定量的なROI計算（コスト削減、売上向上、効率化）
   - KPI設定と測定方法
   - 競合優位性の獲得
   - リスク軽減効果

4. **導入ステップ**
   - フェーズ別の詳細計画
   - 必要なリソースと体制
   - マイルストーンとチェックポイント
   - 変更管理とユーザートレーニング

5. **サポート体制**
   - 24/7サポート体制
   - SLA（サービスレベル合意）
   - 定期メンテナンスとアップデート
   - 継続的な改善と最適化

6. **リスク管理**
   - セキュリティ対策
   - データ保護とコンプライアンス
   - 災害復旧計画
   - 事業継続性の確保

7. **投資対効果**
   - 初期投資と運用コスト
   - 3年間のROI予測
   - 競合他社との比較
   - 長期的な価値創出

【要求事項】
- 商用レベルの専門性と具体性を重視
- 業界の最新動向とベストプラクティスを反映
- 具体的な数値と事例を含める
- 実現可能性とリスクを考慮した現実的な提案
- 日本語で作成し、専門用語は適切に説明
- 追加要件・ご要望を特に重視し、それに応じた具体的な提案を含める

必ず以下のJSON形式で回答してください。他のテキストは一切含めず、JSONのみを返してください：

{
  "serviceOverview": "詳細なサービス概要（業界分析、課題、強み、差別化）",
  "recommendedServices": "推奨サービス（技術スタック、アーキテクチャ、ロードマップ、予算）",
  "expectedEffects": "期待される効果（ROI計算、KPI、競合優位性、リスク軽減）",
  "implementationSteps": "導入ステップ（フェーズ別計画、リソース、マイルストーン、変更管理）",
  "supportSystem": "サポート体制（24/7サポート、SLA、メンテナンス、継続改善）",
  "riskManagement": "リスク管理（セキュリティ、データ保護、災害復旧、事業継続性）",
  "investmentReturn": "投資対効果（初期投資、3年ROI、競合比較、長期価値）",
  "additionalRequirementsResponse": "追加要件・ご要望への具体的な回答と提案"
}

重要：回答は上記のJSON形式のみとし、説明文やその他のテキストは一切含めないでください。
    `;
  }
}

export default OpenAIClient;
