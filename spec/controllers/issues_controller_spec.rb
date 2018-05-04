require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  describe "GET #index" do
    subject { get :index }

    context 'when regular user', user: :regular do
      it 'returns a success' do
        is_expected.to be_success
      end

      it 'returns user''s issues' do
        create(:issue, author: user)
        is_expected.to be_success
        expect(json_body).to have(1).item
      end

      it 'doesn''t return issues that do not belongs to a user' do
        create(:issue)
        is_expected.to be_success
        expect(json_body).to have(0).items
      end
    end
  end

  # describe "GET #show" do
  #   it "returns a success response" do
  #     issue = Issue.create! valid_attributes
  #     get :show, params: {id: issue.to_param}, session: valid_session
  #     expect(response).to be_success
  #   end
  # end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Issue" do
        expect {
          post :create, params: {issue: valid_attributes}, session: valid_session
        }.to change(Issue, :count).by(1)
      end

      it "renders a JSON response with the new issue" do

        post :create, params: {issue: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(issue_url(Issue.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new issue" do

        post :create, params: {issue: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested issue" do
  #       issue = Issue.create! valid_attributes
  #       put :update, params: {id: issue.to_param, issue: new_attributes}, session: valid_session
  #       issue.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "renders a JSON response with the issue" do
  #       issue = Issue.create! valid_attributes
  #
  #       put :update, params: {id: issue.to_param, issue: valid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "renders a JSON response with errors for the issue" do
  #       issue = Issue.create! valid_attributes
  #
  #       put :update, params: {id: issue.to_param, issue: invalid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested issue" do
  #     issue = Issue.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: issue.to_param}, session: valid_session
  #     }.to change(Issue, :count).by(-1)
  #   end
  # end
end
