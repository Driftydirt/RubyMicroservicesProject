class MessagesTest < ActionDispatch::IntegrationTest
    test "can' get messages with no auth" do
        get "/messages"
        assert_response :forbidden
    end