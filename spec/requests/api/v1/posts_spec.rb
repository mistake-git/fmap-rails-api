require 'rails_helper'

describe 'PostAPI' do

  before do
    create(:user)  
  end

  it '全てのpostを取得する' do 
    create_list(:post, 4)
    get '/api/v1/posts'
    json = JSON.parse(response.body)
    #リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)
    #正しい数のデータが返されたか確認する。
    expect(json.length).to eq(4)
  end

  it '特定のpostを取得する' do
    post = create(:post, name: 'タイ')
    get "/api/v1/posts/#{post.id}"
    json = JSON.parse(response.body)
    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)
    # 要求した特定のポストのみ取得した事を確認する
    expect(json['name']).to eq(post.name)
  end

  # it '新しいpostを作成する' do
  #   valid_params = { name: 'タイ', number: 1, latitude: 135, longitude: 35, user_id: 1 }.to_json

  #   #データが作成されている事を確認
  #   expect { post '/api/v1/posts',headers: { CONTENT_TYPE: "application/json" }, params: { post: valid_params } }.to change(Post, :count).by(+1)

  #   # リクエスト成功を表す200が返ってきたか確認する。
  #   expect(response.status).to eq(200)
  # end

end