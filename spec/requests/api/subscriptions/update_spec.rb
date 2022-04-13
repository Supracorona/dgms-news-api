RSpec.describe 'POST /api/subscriptions', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }

  subject { response }

  describe 'as a authenticated user, when subscribing' do
    before do
      post '/api/subscriptions', params: { user: { id: user.id } }, headers: credentials
    end

    it { is_expected.to have_http_status 201 }

    it 'is expected to return a message that subscription status was changed' do
      expect(response_json['message']).to eq 'You are now subscribed.'
    end

    it 'is expected that the user subscription status is changed' do
      expect(User.last.subscribed).to eq true
    end
  end

  describe 'as an unauthenticated user, when subsribing' do
    before do
      post '/api/subscriptions', params: { user: { id: user.id } }, headers: nil
    end

    it { is_expected.to have_http_status 401 }

    it 'is expected to return an error message' do
      expect(response_json['errors'][0]).to eq 'You need to sign in or sign up before continuing.'
    end

    it 'is expected not to change the user subscription status' do
      expect(User.last.subscribed).to eq false
    end
  end
end
