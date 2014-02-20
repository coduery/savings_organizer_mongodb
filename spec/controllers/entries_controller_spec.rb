require 'spec_helper'

describe EntriesController do

  describe "GET 'add'" do
    it "returns http success" do
      get 'add'
      response.should be_success
    end
  end

end
