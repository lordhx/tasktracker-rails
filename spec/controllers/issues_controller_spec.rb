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

      it 'returns 25 issues per page' do
        (Issue::PER_PAGE + 2).times { create(:issue) }

        subject
        expect(json_body).to have(Issue::PER_PAGE).items
        expect(json_body.first[:id]).to eq(Issue.last.id)

        get :index, params: { offset: Issue::PER_PAGE }
        result = json_body(true)
        expect(result).to have(2).items
        expect(result.last[:id]).to eq(Issue.first.id)
      end
    end
  end

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

  describe 'PUT #update' do
    subject { put :update, params: { id: issue.id, issue: issue_attributes } }
    let(:issue_attributes) { attributes_for(:issue) }
    let!(:issue) { create(:issue, author: author) }
    let(:author) { user }

    context 'when regular user', user: :regular do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'does not create an issue' do
        expect { subject }.to_not change(Issue, :count)
      end

      it 'updates an issue with new params' do
        expect { subject }.to change { issue.reload.description }.to(issue_attributes[:description])
      end

      context 'when author does not match current user' do
        let(:author) { create(:user) }

        it 'returns not_found' do
          is_expected.to be_not_found
        end
      end
    end

    context 'when user is a manager', user: :manager do
      it 'returns success' do
        is_expected.to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: issue.id } }
    let!(:issue) { create(:issue, author: author) }
    let(:author) { user }

    context 'when regular user', user: :regular do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'deletes an issue' do
        expect { subject }.to change(Issue, :count).by(-1)
      end

      context 'when author does not match current user' do
        let(:author) { create(:user) }

        it 'returns not_found' do
          is_expected.to be_not_found
        end
      end
    end

    context 'when user is a manager', user: :manager do
      it 'returns forbidden' do
        is_expected.to be_forbidden
      end
    end
  end
end
