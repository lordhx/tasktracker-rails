require 'rails_helper'

RSpec.describe Issue::AssignmentsController, type: :controller do
  let!(:issue) { create(:issue, assignee: assignee) }

  describe 'POST #create' do
    subject { post :create, params: { issue_id: issue.id } }
    let(:assignee) { nil }

    context 'when user is a manager', user: :manager do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'assigns an issue to a user' do
        expect { subject }.to change { issue.reload.assignee_id }.to(user.id)
      end

      context 'when an issues is already assigned' do
        let(:assignee) { create(:manager) }

        it 'returns forbidden' do
          is_expected.to be_forbidden
        end
      end
    end

    context 'when regular user', user: :regular do
      it 'returns not found' do
        is_expected.to be_not_found
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { issue_id: issue.id, assignment: assignment_params } }
    let(:assignment_params) { attributes_for(:issue, status: Issue.statuses.keys.without(issue.status).sample) }
    let(:assignee) { user }

    context 'when user is a manager', user: :manager do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'updates status' do
        expect { subject }.to change { issue.reload.status }.to(assignment_params[:status])
      end

      it 'doesn''t update description' do
        expect { subject }.to_not change { issue.reload.description }
      end

      context 'when an issues is assigned to another manger' do
        let(:assignee) { create(:manager) }

        it 'returns forbidden' do
          is_expected.to be_forbidden
        end
      end
    end

    context 'when regular user', user: :regular do
      it 'returns not found' do
        is_expected.to be_not_found
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { issue_id: issue.id } }
    let(:assignee) { user }

    context 'when user is a manager', user: :manager do
      it 'returns success' do
        is_expected.to be_success
      end

      it 'unassigns an issue to a user' do
        expect { subject }.to change { issue.reload.assignee_id }.to(nil)
      end

      context 'when an issues is assigned to another manger' do
        let(:assignee) { create(:manager) }

        it 'returns forbidden' do
          is_expected.to be_forbidden
        end
      end
    end

    context 'when regular user', user: :regular do
      it 'returns not found' do
        is_expected.to be_not_found
      end
    end
  end
end
