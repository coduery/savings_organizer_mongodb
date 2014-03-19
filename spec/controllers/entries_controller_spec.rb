require 'spec_helper'

describe EntriesController do

  # add method examples
  it { should respond_to :add }
  
  describe '#add' do
    context 'when request.get?' do
      context 'curret_user_id not nil?' do
        context 'when categories not empty?' do
          xit 'flash alert nil' do
            session[:current_user_id] = 1
            flash[:alert].should be_nil
          end
        end
        context 'when categories empty?' do
          xit 'flash alert message' do
            session[:current_user_id] = 1
            flash[:alert].should eql "No Categories for Savings Account!  Must create at least one category."
          end
        end
      end
      # context 'curret_user_id nil?' do
#         
      # end
    end
    
    # context 'when request.post?' do
#       
    # end
  end
  
end
