require 'rails_helper'

RSpec.describe "Items", type: :request do
  # init test data
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe "GET /todos/:todo_id/items/:id" do
    before { get "/todos/#{todo_id}/items/#{id}" }

    context "when todo item exists" do
      it "return the item" do
        expect(json["id"]).to eq(id)
      end

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when item dont exists" do
      let(:id) { "0" }

      it "return a not foun message" do
        expect(response.body).to match(/Couldn't find Item/)
      end

      it "return status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe "POST /todos/:todo_id/items/:id" do
    let(:valid_params) { { name: "tu hermana", done: true } }
    
    context "when request attrs are valid" do
      before { post "/todos/#{todo_id}/items", params: valid_params }

      it "create a new item" do
        expect(json["name"]).to eq("tu hermana")
      end

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/todos/#{todo_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed/)
      end
    end
  end
  
  describe "PUT /todos/:todo_id/items/:id" do
    let(:valid_params) {{ name: "El cabeza de muela" }}
    before { put "/todos/#{todo_id}/items/#{id}", params: valid_params }

    context "when item exists" do
      it "return item updated" do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/El cabeza de muela/)
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end

    context "when the item doesn't exists" do
      let(:id) { 0 }

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "DELETE /todos/:todo_id/items/:id" do
    before { delete "/todos/#{todo_id}/items/#{id}" }

    context "when the item exists" do
      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end
end
