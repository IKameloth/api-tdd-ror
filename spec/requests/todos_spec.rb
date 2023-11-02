require 'rails_helper'

RSpec.describe "Todos", type: :request do
  # init test data
  let!(:todos) { create_list(:todo, 5) }
  let(:todo_id) { todos.first.id }

  # test suite get /todos
  describe "GET /todos" do
    # make http request
    before { get '/todos' }

    it 'return todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context "when the record exists" do
      it "return todo element" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(todo_id)
      end

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end
    end    
  end

  describe 'POST /todos' do
    let(:valid_attrs) { { title: "turn on arount stupid", created_by: "cmatteo" } }

    context "when the request is valid" do
      before { post '/todos', params: valid_attrs }

      it "create a new todo" do
        expect(json["title"]).to eq("turn on arount stupid")
      end

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/todos", params: { title: "not valid params" } }

      it "return a validation with failure message" do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe "PUT /todos/:id" do
    context "when te record exists" do
      before { put "/todos/#{todo_id}", params: { title: "goal", created_by: "cmatteo" } }
      it "update the record" do
        expect(response.body).to be_empty
      end

      it "return status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }
    
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
