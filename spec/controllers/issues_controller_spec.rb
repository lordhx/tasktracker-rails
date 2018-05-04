require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    context 'when regular user', user: :regular do
      it 'returns a success' do
        is_expected.to be_success
      end

      it 'returns user' 's issues' do
        create(:issue, author: user)

        is_expected.to be_success
        expect(json_body).to have(1).item
      end

      it 'doesn' 't return issues that do not belongs to a user' do
        create(:issue)

        is_expected.to be_success
        expect(json_body).to have(0).items
      end
    end

    context 'when user is a manager', user: :manager do
      it 'returns a success' do
        is_expected.to be_success
      end

      it 'returns all issues' do
        create(:issue)

        subject
        expect(json_body).to have(1).item
      end

      it 'returns most recent first' do
        create(:issue)
        second = create(:issue)

        subject
        expect(json_body).to have(2).items
        expect(json_body.first[:id]).to eq(second.id)
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

  describe 'POST #create' do
    subject { post :create, params: { issue: issue_attributes } }

    let(:issue_attributes) { attributes_for(:issue) }

    context 'when regular user', user: :regular do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'creates an issue' do
        expect { subject }.to change(Issue, :count).by(1)
      end

      it 'creates an issue with correct params' do
        subject
        issue = Issue.last
        expect(issue.description).to eq(issue_attributes[:description])
        expect(issue.status).to eq('pending')

        expect(issue.author_id).to eq(user.id)
        expect(issue.assignee_id).to eq(nil)
      end
    end

    context 'when user is a manager', user: :manager do
      it 'returns success' do
        is_expected.to be_forbidden
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
