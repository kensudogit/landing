<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;

class OpenAIController extends Controller
{
    public function generate(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'prompt' => 'required|string',
                'userInfo' => 'nullable|array' // userInfoをオプショナルに変更
            ]);

            $prompt = $request->input('prompt');
            $userInfo = $request->input('userInfo', []); // デフォルト値を空配列に設定
            
            // 環境変数からAPIキーを取得（複数の方法を試す）
            // Railwayでは環境変数が直接設定されるため、複数の方法で取得を試みる
            $apiKey = getenv('OPENAI_API_KEY') 
                ?: $_ENV['OPENAI_API_KEY'] 
                ?? $_SERVER['OPENAI_API_KEY'] 
                ?? env('OPENAI_API_KEY');
            
            // APIキーが設定されていない場合のエラーハンドリング
            if (empty($apiKey) || $apiKey === 'your-openai-api-key-here') {
                // デバッグ情報（ログファイルに書き込めない場合でもエラーを返す）
                $debugInfo = [
                    'getenv' => getenv('OPENAI_API_KEY') ? 'set' : 'not set',
                    '_ENV' => isset($_ENV['OPENAI_API_KEY']) ? 'set' : 'not set',
                    '_SERVER' => isset($_SERVER['OPENAI_API_KEY']) ? 'set' : 'not set',
                    'env()' => env('OPENAI_API_KEY') ? 'set' : 'not set',
                ];
                
                // ログファイルに書き込めない場合でもエラーを返す
                try {
                    \Log::warning('OpenAI API key not found', $debugInfo);
                } catch (\Exception $logError) {
                    // ログファイルへの書き込みに失敗した場合は無視
                }
                
                return response()->json([
                    'success' => false,
                    'error' => 'OpenAI API key is not configured. Please set OPENAI_API_KEY environment variable in Railway dashboard and redeploy.',
                    'debug' => $debugInfo
                ], 500);
            }

            // OpenAI APIを呼び出し
            $client = new Client();
            $response = $client->post('https://api.openai.com/v1/chat/completions', [
                'headers' => [
                    'Authorization' => 'Bearer ' . $apiKey,
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'model' => 'gpt-3.5-turbo',
                    'messages' => [
                        [
                            'role' => 'system',
                            'content' => 'あなたは須藤技術士事務所のITコンサルタントです。ユーザーの情報を基に、パーソナライズされたITサービス提案資料を作成してください。'
                        ],
                        [
                            'role' => 'user',
                            'content' => $prompt
                        ]
                    ],
                    'max_tokens' => 2000,
                    'temperature' => 0.7
                ]
            ]);

            $data = json_decode($response->getBody()->getContents(), true);
            
            return response()->json([
                'success' => true,
                'content' => $data['choices'][0]['message']['content']
            ]);

        } catch (ValidationException $e) {
            // バリデーションエラーの場合
            $errors = $e->errors();
            $firstError = collect($errors)->flatten()->first();
            return response()->json([
                'success' => false,
                'error' => 'Validation error: ' . ($firstError ?? 'Invalid input data')
            ], 422);
        } catch (RequestException $e) {
            return response()->json([
                'success' => false,
                'error' => 'OpenAI API error: ' . $e->getMessage()
            ], 500);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Server error: ' . $e->getMessage()
            ], 500);
        }
    }
}
